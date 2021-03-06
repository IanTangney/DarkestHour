//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_P08LugerDamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_P08LugerWeapon'
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b9mm'
    KDamageImpulse=750.0
    KDeathVel=100.0
    KDeathUpKick=0.0
}
