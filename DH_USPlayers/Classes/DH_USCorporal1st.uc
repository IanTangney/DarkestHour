//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_USCorporal1st extends DH_US_1st_Infantry;

defaultproperties
{
    MyName="Corporal"
    AltName="Corporal"
    Article="a "
    PluralName="Corporals"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1GarandWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stEMb'
    Limit=2
}
