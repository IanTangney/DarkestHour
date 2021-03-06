//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Soviet_Units extends DHRoleInfo
    abstract;

defaultproperties
{
    Texture=Texture'DHEngine_Tex.Allies_RoleInfo'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
    DetachedArmClass=class'ROEffects.SeveredArmSovTunic'
    DetachedLegClass=class'ROEffects.SeveredLegSovTunic'
    Side=SIDE_Allies
}
