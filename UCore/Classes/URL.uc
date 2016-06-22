//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================
// https://github.com/php/php-src/blob/c72282a13b12b7e572469eba7a7ce593d900a8a2/ext/standard/url.c
//==============================================================================

class URL extends Object;

var string Scheme;
var string User;
var string Pass;
var string Host;
var string Path;
var string Query;
var string Fragment;
var int Port;

static final function URL FromString(string URL)
{
    local URL U;
    local int l, s, e, ue, p, pp;
    local int Port, Query, Fragment;

    U = new class'URL';
    l = Len(URL);
    ue = s + l;
    e = InStr(URL, ":");

    /* parse scheme */
    if (e >= 0)
    {
        while (p < e)
        {
            if (!class'UString'.static.IsAlpha(Mid(URL, p, 1)) &&
                !class'UString'.static.IsDigit(Mid(URL, p, 1)) &&
                Mid(URL, p, 1) != "+" && Mid(URL, p, 1) != "." && Mid(URL, p, 1) != "-")
            {
                if (e + 1 < l && e < s + class'UString'.static.FindFirstOf(URL, "?#"))
                {
                    goto ParsePort;
                }
                else
                {
                    goto JustPath;
                }
            }

            ++p;
        }

        if (e + 1 == l)
        {
            /* only scheme is available */
            U.Scheme = Mid(URL, 0, e);
            // TODO: replace control characters
            goto End;
        }

        /*
         * certain schemas like mailto: and zlib: may not have any / after them
         * this check ensures we support those.
         */
        if (Mid(URL, e + 1, 1) != "/")
        {
            /* check if the data we get is a port this allows us to correctly parse things like a.com:80 */
            p = e + 1;

            while (class'UString'.static.IsDigit(Mid(URL, p, 1)))
            {
                ++p;
            }

            if ((p == Len(URL) || Mid(URL, p, 1) == "/") && (p - e) < 7)
            {
                goto ParsePort;
            }

            U.Scheme = Mid(URL, s, e);
            // TODO: replace control characters

            l -= ++e - s;
            s = e;

            goto JustPath;
        }
        else
        {
            U.Scheme = Mid(URL, 0, e);
            // TODO: replace control characters

            if (Mid(URL, e + 2, 1) == "/")
            {
                s = e + 3;

                if (U.Scheme ~= "file")
                {
                    if (Mid(URL, e + 3, 1) == "/")
                    {
                        /* support windows drive letters as in: file:///c:/somedir/file.txt */
                        if (Mid(URL, e + 5, 1) == ":")
                        {
                            s = e + 4;
                        }

                        goto NoHost;
                    }
                }
            }
            else
            {
                if (U.Scheme ~= "file")
                {
                    s = e + 1;

                    goto NoHost;
                }
                else
                {
                    l -= ++e - s;
                    s = e;

                    goto JustPath;
                }
            }
        }
    }
    else if (e != -1)
    {
        /* no scheme; starts with colon: look for port */
ParsePort:
        p = e + 1;
        pp = p;

        while (pp - p < 6 && class'UString'.static.IsDigit(Mid(URL, pp, 1)))
        {
            ++pp;
        }

        if (pp - p > 0 && pp - p < 6 && (Mid(URL, pp, 1) == "/" || pp == Len(S)))
        {
            Port = int(Mid(URL, p, pp - p));

            if (Port > 0  && Port < 65536)
            {
                U.Port = Port;

                if (Mid(URL, s, 1) == "/" && Mid(URL, s + 1, 1) == "/")
                {
                    /* relative-scheme URL */
                    s += 2;
                }
            }
            else
            {
                Warn("Invalid port.");
                return none;
            }
        }
        else if (p == pp && pp == Len(S))
        {
            Warn("Expected port.");
            return None;
        }
        else if (Mid(URL, s, 1) == "/" && Mid(URL, s + 1, 1) == "/")
        {
            /* relative-scheme URL */
            s += 2;
        }
        else
        {
            goto JustPath;
        }
    }
    else if (Mid(URL, 0, 1) == "/" && Mid(URL, 1, 1) == "/")
    {
        /* relative-scheme URL */
        s += 2;
    }
    else
    {
JustPath:
        ue = s + Len(URL);
        goto NoHost;
    }

    e = ue;

    p = InStr(Mid(URL, s), "/");

    if (p == -1)
    {
        Query = InStr(Mid(URL, s), "?");
        Fragment = InStr(Mid(URL, s), "#");

        if (Query != -1 && Fragment != -1)
        {
            if (Query > Fragment)
            {
                e = Fragment;
            }
            else
            {
                e = Query;
            }
        }
        else if (Query != -1)
        {
            e = Query;
        }
        else if (Fragment != -1)
        {
            e = Fragment;
        }
    }
    else
    {
        e = p;
    }

    /* check for login and password */
    p = InStr(Mid(URL, s, e), "@");

    if (p != -1)
    {
        /* check for invalid chars inside login/pass */
        pp = s;

        while (pp < p)
        {
            if (!class'UString'.static.IsAlphaNumeric(Mid(URL, pp, 1)) &&
                Mid(URL, pp, 1) != ":" &&
                Mid(URL, pp, 1) != ";" &&
                Mid(URL, pp, 1) != "=" &&
                (Asc(Mid(URL, pp, 1)) >= Asc("!") && Asc(Mid(URL, pp, 1)) <= Asc(",")))
            {
                Warn("Invalid characters inside credentials");
                return None;
            }
        }

        pp = InStr(Mid(URL, s, p - s), ":");

        if (pp != -1)
        {
            U.User = Mid(URL, s, pp);
            // TODO: replace control characters

            ++p;

            U.Pass = Mid(URL, pp, p - pp);
            // TODO: replace control characters
        }
        else
        {
            U.User = Mid(URL, 0, p);
            // TODO: replace control characters
        }

        s = p + 1;
    }

    /* check for port */
NoHost:
End:
    return U;
}
