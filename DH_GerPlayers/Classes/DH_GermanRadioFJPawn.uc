//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_GermanRadioFJPawn extends DH_GermanFJPawn;

defaultproperties
{
    FaceSlot=0
    BodySlot=1

    Mesh=SkeletalMesh'DHCharacters_anm.Ger_Heer_Radioman'

    BodySkins(0)=texture'DHGermanCharactersTex.Luftwaffe.LW_1'
    BodySkins(1)=none
    BodySkins(2)=none
    BodySkins(3)=none

    Skins(0)=texture'Characters_tex.ger_heads.ger_face01'
    Skins(1)=texture'DHGermanCharactersTex.Luftwaffe.LW_1'
}