//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WolverineCannon extends DHVehicleCannon;

defaultproperties
{
    InitialTertiaryAmmo=24
    TertiaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellHE'
    SecondarySpread=0.001
    TertiarySpread=0.00135
    ManualRotationsPerSecond=0.01
    FrontArmorFactor=5.7
    RightArmorFactor=2.5
    LeftArmorFactor=2.5
    RearArmorFactor=2.5
    FrontArmorSlope=45.0
    RightArmorSlope=25.0
    LeftArmorSlope=25.0
    FrontLeftAngle=332.0
    FrontRightAngle=28.0
    RearRightAngle=152.0
    RearLeftAngle=208.0
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_02s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire03'
    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(1)="HVAP"
    ProjectileDescriptions(2)="HE"
    AddedPitch=52
    MinCommanderHitHeight=43.0;
    VehHitpoints(0)=(PointRadius=9.0,PointScale=1.0,PointBone="com_player",PointOffset=(X=15.0,Y=6.0,Z=3.0))
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Gun"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=200.0
    FireInterval=5.0
    FireSoundVolume=512.0
    FireForce="Explosion05"
    ProjectileClass=class'DH_Vehicles.DH_WolverineCannonShell'
    ShakeRotMag=(Z=50.0)
    ShakeRotRate=(Z=1000.0)
    ShakeRotTime=4.0
    ShakeOffsetMag=(Z=1.0)
    ShakeOffsetRate=(Z=100.0)
    ShakeOffsetTime=10.0
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
    CustomPitchUpLimit=5461
    CustomPitchDownLimit=63715
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=25
    InitialSecondaryAmmo=5
    PrimaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellHVAP'
    Mesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.M10_turret_ext'
    Skins(1)=texture'DH_VehiclesUS_tex.int_vehicles.M10_turret_int'
    Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.M10_turret_int'
    SoundVolume=80
    SoundRadius=300.0
}
