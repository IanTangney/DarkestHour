//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_DP28VehDamType extends DHVehicleDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.b762mm'
    WeaponClass=class'DH_Weapons.DH_DP28Weapon'
    DeathString="%o was killed by %k's DP-28."
    FemaleSuicide="%o turned the gun on herself."
    MaleSuicide="%o turned the gun on himself."
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    KDamageImpulse=200.0
}