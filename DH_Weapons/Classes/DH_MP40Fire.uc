//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_MP40Fire extends DHAutomaticFire;

defaultproperties
{
    // THEEL DEBUG TODO TESTING TESTING
    // because the MP40 seems to be significantly bad when server tick rate is below average, I thought it'd be good to test out removing PLT on it
    // this might give us better insight if PLT is something we could remove on other guns as well
    bUsePreLaunchTrace=false

    ProjectileClass=class'DH_Weapons.DH_MP40Bullet'
    AmmoClass=class'ROAmmo.MP32Rd9x19Ammo'
    FireRate=0.13
    Spread=310.0
    RecoilRate=0.05
    MaxVerticalRecoilAngle=300
    MaxHorizontalRecoilAngle=40
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.mp40.mp40_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.mp40.mp40_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.mp40.mp40_fire03'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
}
