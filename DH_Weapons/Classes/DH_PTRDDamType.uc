//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PTRDDamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.b762mm'
    WeaponClass=class'DH_Weapons.DH_PTRDWeapon'
    DeathString="%o was killed by %k's PTRD."
    FemaleSuicide="%o turned the gun on herself."
    MaleSuicide="%o turned the gun on himself."
    bThrowRagdoll=true
    bArmorStops=true
    TankDamageModifier=0.75
    APCDamageModifier=0.5
    VehicleDamageModifier=0.75
    TreadDamageModifier=0.5
    GibModifier=4.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuffLarge'
    GibPerterbation=0.15
    KDamageImpulse=4500.0
    KDeathVel=200.0
    KDeathUpKick=25.0
    VehicleMomentumScaling=0.1
}