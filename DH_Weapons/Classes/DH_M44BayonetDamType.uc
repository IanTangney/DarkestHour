//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M44BayonetDamType extends DHWeaponBayonetDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_M44Weapon'
    DeathString="%o was stabbed by %k's mounted bayonet."
    FemaleSuicide="%o turned the bayonet on herself."
    MaleSuicide="%o turned the bayonet on himself."
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    KDamageImpulse=400.0
}