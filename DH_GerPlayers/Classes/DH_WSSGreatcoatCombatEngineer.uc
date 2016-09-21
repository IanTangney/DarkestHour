//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSGreatcoatCombatEngineer extends DH_WaffenSSGreatcoat;

defaultproperties
{
    MyName="SS Combat Engineer"
    AltName="SS Sturmpioniere"
    Article="a "
    PluralName="SS Combat Engineers"
    InfoText="The combat engineer is tasked with destroying front-line enemy obstacles and fortifications.  Geared for close quarters combat, the combat engineer is generally equipped with submachine-guns and grenades.  For instances where enemy fortifications or obstacles are exposed to enemy fire, he is equipped with concealment smoke so he may get close enough to destroy the target."
    menuImage=Texture'DHGermanCharactersTex.Icons.WSS_Eng'
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
    PrimaryWeaponType=WT_SMG
    limit=1
}