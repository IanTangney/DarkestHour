//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RKKA_SnowSniper extends DH_RKKA_Snow;

defaultproperties
{
    MyName="Sniper"
    AltName="Sniper"
    Article="a "
    PluralName="Snipers"
    PrimaryWeaponType=WT_Sniper
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130ScopedWeapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietFurHat'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietFurHat'
    Headgear(2)=class'DH_SovietPlayers.DH_SovietFurHat'
    limit=1
}