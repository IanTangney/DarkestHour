import os
import sys
import argparse
import subprocess
import ConfigParser
import shutil
import json
import re
from pprint import pprint
from binascii import crc32
from collections import OrderedDict


class MultiOrderedDict(OrderedDict):
    def __setitem__(self, key, value, **kwargs):
        if isinstance(value, list) and key in self:
            self[key].extend(value)
        else:
            super(OrderedDict, self).__setitem__(key, value)


def main():
    # parse options
    argparser = argparse.ArgumentParser()
    argparser.add_argument('dir', default='.', help='root directory')
    argparser.add_argument('-mod', required=True, help='mod name')
    argparser.add_argument('-ignore_dependencies', required=False, default=False, action='store_true', help='ignore package dependencies')
    argparser.add_argument('-clean', required=False, action='store_true', help='compile all packages')
    argparser.add_argument('-dumpint', required=False, action='store_true', help='dump localization files (.int)')
    args = argparser.parse_args()

    args.dir = os.path.abspath(args.dir)

    if not os.path.isdir(args.dir):
        print 'error: "{}" is not a directory'.format(dir)
        sys.exit(1)

    # system directory
    sys_dir = os.path.join(args.dir, 'System')

    if not os.path.isdir(sys_dir):
        print 'error: could not resolve System directory'
        sys.exit(1)

    # mod directory
    mod_dir = os.path.join(args.dir, args.mod)

    if not os.path.isdir(mod_dir):
        print 'error: could not resolve mod directory'
        sys.exit(1)

    # mod system directory
    mod_sys_dir = os.path.join(mod_dir, 'System')

    if not os.path.isdir(mod_sys_dir):
        print 'error could not resolve mod system directory'
        sys.exit(1)

    config = ConfigParser.RawConfigParser(dict_type=MultiOrderedDict)

    # read the default config 
    default_config_path = os.path.join(mod_sys_dir, 'Default.ini')
    if os.path.isfile(default_config_path):
        config.read(default_config_path)
        default_packages = config.get('Editor.EditorEngine', '+editpackages')
    else:
        print "error: could not resove mod config file"
        sys.exit(1)

    # delete ALL mod packages from the root system folder
    for package in default_packages:
        package_path = os.path.join(sys_dir, package + '.u')
        if os.path.isfile(package_path):
            try:
                os.remove(package_path)
            except OSError:
                print 'error: failed to remove \'{}\' (is the client, server or editor running?)'.format(package)
                sys.exit(1)

    # mod config path
    config_path = os.path.join(mod_sys_dir, args.mod + '.ini')

    if args.clean and os.path.isfile(config_path):
        # clean build deletes the existing mod config
        # TODO: only have this find and re-set the EditPackages and ServerPackages entries!
        os.remove(config_path)

    # get packages from generated INI?
    if os.path.isfile(config_path):
        config.read(config_path)
        packages = config.get('Editor.EditorEngine', 'editpackages')
    else:
        packages = default_packages

    packages_to_compile = set()
    changed_packages = set()
    package_crcs = dict()

    manifest_path = os.path.join(mod_dir, '.make'.format(args.mod))

    if args.clean and os.path.isfile(manifest_path):
        os.remove(manifest_path)

    try:
        with open(manifest_path, 'r') as f:
            package_crcs = json.load(f)
    except IOError:
        pass

    # store the old CRCs before we overwrite them
    old_package_crcs = package_crcs

    for package in packages:
        sys_package_path = os.path.join(sys_dir, package + '.u')

        if os.path.isfile(sys_package_path):
            # compiled file exists in root system folder
            continue

        should_compile_package = False

        if not args.ignore_dependencies and len(packages_to_compile) > 0:
            should_compile_package = True
        
        package_src_dir = os.path.join(args.dir, package, 'Classes')
        package_crc = 0

        for root, dirs, filenames in os.walk(package_src_dir):
            for filename in filter(lambda x: x.endswith('.uc'), filenames):
                with open(os.path.join(root, filename), 'rb') as f:
                    package_crc = crc32(f.read(), package_crc)

        if package not in package_crcs or package_crcs[package] != package_crc:
            changed_packages.add(package + '.u')
            should_compile_package = True

        if should_compile_package:
            packages_to_compile.add(package + '.u')

        package_crcs[package] = package_crc

    if len(packages_to_compile) == 0:
        print 'no packages to compile'
        sys.exit(0)

    print 'compiling the following packages:'

    pprint(packages_to_compile)

    # delete packages marked for compiling from both the root AND mod system folder
    for package in packages_to_compile:
        for package_dir in [sys_dir, mod_sys_dir]:
            package_path = os.path.join(package_dir, package)
            if os.path.isfile(package_path):
                try:
                    os.remove(package_path)
                except OSError:
                    print 'error: failed to remove \'{}\' (is the client, server or editor running?)'.format(package)
                    sys.exit(1)

    os.chdir(sys_dir)

    # run ucc make
    proc = subprocess.Popen(['ucc', 'make', '-mod=' + args.mod, '-silentbuild'])
    proc.communicate()

    # store contents of ucc.log before it's overwritten
    ucc_log_file = open('ucc.log', 'rb')
    ucc_log_contents = ucc_log_file.read()
    ucc_log_file.close()

    compiled_packages = set()

    # move compiled packages to mod directory
    for root, dirs, filenames in os.walk(sys_dir):
        for filename in filenames:
            if filename in packages_to_compile:
                shutil.copy(os.path.join(root, filename), mod_sys_dir)
                os.remove(os.path.join(root, filename))
                compiled_packages.add(filename)

    # run dumpint on changed and compiled packages
    if args.dumpint:
        print 'running dumpint (note: output may be garbled due to ucc writing to stdout in parallel)'
        processes = []
        for package in (compiled_packages & changed_packages):
            processes.append(subprocess.Popen(['ucc', 'dumpint', package, '-mod=' + args.mod]))

        [p.wait() for p in processes]

        # move localization files to mod directory
        for root, dirs, filenames in os.walk(sys_dir):
            for filename in filenames:
                if filename.replace('.int', '.u') in packages_to_compile:
                    shutil.copy(os.path.join(root, filename), mod_sys_dir)
                    os.remove(os.path.join(root, filename))

    # rewrite ucc.log to be the contents of the original ucc make command (so that WOTgreal can parse it correctly)
    ucc_log_file = open('ucc.log', 'wb')
    ucc_log_file.truncate()
    ucc_log_file.write(ucc_log_contents)
    ucc_log_file.close()

    print 'Compiled ' + str(len(compiled_packages)) + ' of ' + str(len(packages_to_compile)) + ' package(s)'

    # search for success message in log
    # this is a better option than searching for the failure message since GPF errors don't generate this line
    did_build_fail = re.search('Success - \d+ error\(s\)', ucc_log_contents) is None

    for package_name in compiled_packages:
        package_name = os.path.splitext(package_name)[0]
        old_package_crcs[package_name] = package_crcs[package_name]

    # delete the CRCs of changed packages that failed to compile
    for package_name in ((packages_to_compile - compiled_packages) & changed_packages):
        package_name = os.path.splitext(package_name)[0]
        del old_package_crcs[package_name]

    # write package manifest
    try:
        with open(manifest_path, 'w') as f:
            json.dump(old_package_crcs, f)
    except OSError:
        print 'could not write mod make manifest'

if __name__ == "__main__":
    main()
