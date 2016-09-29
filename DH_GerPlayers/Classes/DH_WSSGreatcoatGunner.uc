//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSGreatcoatGunner extends DH_WaffenSSGreatcoat;

defaultproperties
{
    MyName="SS Machine-gunner"
    AltName="MG-Sch�tze-SS"
    Article="a "
    PluralName="SS Machine-gunners"
    bIsGunner=True
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MG34Weapon',Amount=6)
    SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    Limit=2
    bCarriesMGAmmo=false
}
