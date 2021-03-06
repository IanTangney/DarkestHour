//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_G41Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_G41Bullet'
    AmmoClass=class'ROAmmo.G41Ammo'
    FireRate=0.28
    Spread=100.0
    MaxVerticalRecoilAngle=1900
    FireSounds(0)=SoundGroup'DH_WeaponSounds.g41.g41_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.g41.g41_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.g41.g41_fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)
}
