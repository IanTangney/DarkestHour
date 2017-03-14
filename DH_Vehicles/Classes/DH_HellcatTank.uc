//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_HellcatTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Hellcat_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex5.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_allies_vehicles_stc3

defaultproperties
{
    // Vehicle properties
    VehicleNameString="M18 Hellcat"
    VehicleTeam=1
    VehicleMass=11.0

    // Hull mesh
    Mesh=SkeletalMesh'DH_Hellcat_anm.hellcat_body_ext'
    Skins(0)=texture'DH_VehiclesUS_tex5.ext_vehicles.hellcat_body_ext'
    Skins(1)=texture'DH_VehiclesUS_tex5.ext_vehicles.hellcat_armor_ext'
    Skins(2)=texture'DH_VehiclesUS_tex5.ext_vehicles.hellcat_turret_ext'
    Skins(3)=texture'DH_VehiclesUS_tex5.Treads.hellcat_treads'
    Skins(4)=texture'DH_VehiclesUS_tex5.Treads.hellcat_treads'
    Skins(5)=texture'DH_VehiclesUS_tex5.int_vehicles.hellcat_body_int'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_HellcatCannonPawn',WeaponBone="Turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-125.0,Y=-75.0,Z=45.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-160.0,Y=-35.0,Z=47.5),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-160.0,Y=35.0,Z=47.5),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-125.0,Y=75.0,Z=45.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Hellcat_anm.hellcat_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Hellcat_anm.hellcat_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Hellcat_anm.hellcat_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    DrivePos=(X=2.0,Y=0.0,Z=-20.0)
    DriveAnim="VPanzer3_driver_idle_open"

    // Hull armor
    FrontArmor(0)=(Thickness=1.27,Slope=-53.0,MaxRelativeHeight=-20.0,LocationName="lower nose")
    FrontArmor(1)=(Thickness=1.27,Slope=-24.0,MaxRelativeHeight=-1.9,LocationName="nose")
    FrontArmor(2)=(Thickness=1.27,Slope=38.0,MaxRelativeHeight=17.0,LocationName="upper nose")
    FrontArmor(3)=(Thickness=1.27,Slope=64.0,LocationName="upper")
    RightArmor(0)=(Thickness=1.27,MaxRelativeHeight=14.5,LocationName="lower")
    RightArmor(1)=(Thickness=1.27,Slope=23.0,LocationName="upper")
    LeftArmor(0)=(Thickness=1.27,MaxRelativeHeight=14.5,LocationName="lower")
    LeftArmor(1)=(Thickness=1.27,Slope=23.0,LocationName="upper")
    RearArmor(0)=(Thickness=1.27,Slope=-35.0,MaxRelativeHeight=20.5,LocationName="lower")
    RearArmor(1)=(Thickness=1.27,Slope=13.0,LocationName="upper")

    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=150.0
    RearLeftAngle=210.0
/*
    UFrontArmorFactor=1.3
    URightArmorFactor=1.3
    ULeftArmorFactor=1.3
    URearArmorFactor=1.3
    UFrontArmorSlope=38.0
    URightArmorSlope=23.0
    ULeftArmorSlope=23.0
    URearArmorSlope=13.0
*/
    // Movement
    MaxCriticalSpeed=1193.0 // 71 kph
    GearRatios(3)=0.62
    GearRatios(4)=0.85
    TransRatio=0.17

    // Damage
    Health=500
    HealthMax=500.0
    VehHitpoints(0)=(PointRadius=40.0,PointOffset=(X=-100.0,Z=4.0)) // engine
    VehHitpoints(1)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=30.0,Y=-30.0,Z=4.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=30.0,Y=30.0,Z=4.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=8.0
    DamagedEffectOffset=(X=-140.0,Y=0.0,Z=35.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.Hellcat.Hellcat_dest'

    // Exit
    ExitPositions(0)=(X=107.0,Y=-41.0,Z=98.0)  // driver
    ExitPositions(1)=(X=40.0,Y=-15.0,Z=165.0)  // commander
    ExitPositions(2)=(X=-125.0,Y=-158.0,Z=5.0) // passenger (l)
    ExitPositions(3)=(X=-244.0,Y=-37.0,Z=5.0)  // passenger (bl)
    ExitPositions(4)=(X=-241.0,Y=34.0,Z=5.0)   // passenger (br)
    ExitPositions(5)=(X=-125.0,Y=156.0,Z=5.0)  // passenger (r)

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.SU76.SU76_engine_loop'
    StartUpSound=sound'Vehicle_Engines.SU76.SU76_engine_start'
    ShutDownSound=sound'Vehicle_Engines.SU76.SU76_engine_stop'
    LeftTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSoundBone="driver_attachment"
    RumbleSound=sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'

    // Visual effects
    LeftTreadIndex=4
    RightTreadIndex=3
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=32768,Yaw=0,Roll=16384)
    TreadVelocityScale=110.0
    WheelRotationScale=500
    ExhaustPipes(0)=(ExhaustPosition=(X=-160.0,Y=65.0,Z=-10.0),ExhaustRotation=(Pitch=31000,Yaw=-16384))
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.M18_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.M18_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.M18_turret_look'
    VehicleHudEngineX=0.51
    VehicleHudTreadsPosX(0)=0.36
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.7
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsY(0)=0.32
    VehicleHudOccupantsX(1)=0.5
    VehicleHudOccupantsY(1)=0.5
    VehicleHudOccupantsX(2)=0.375
    VehicleHudOccupantsY(2)=0.75
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.8
    VehicleHudOccupantsX(4)=0.55
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsX(5)=0.625
    VehicleHudOccupantsY(5)=0.75
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.m18_hellcat'

    // Visible wheels
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    LeftWheelBones(6)="Wheel_L_7"
    LeftWheelBones(7)="Wheel_L_8"
    LeftWheelBones(8)="Wheel_L_9"
    LeftWheelBones(9)="Wheel_L_10"
    LeftWheelBones(10)="Wheel_L_11"
    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"
    RightWheelBones(6)="Wheel_R_7"
    RightWheelBones(7)="Wheel_R_8"
    RightWheelBones(8)="Wheel_R_9"
    RightWheelBones(9)="Wheel_R_10"
    RightWheelBones(10)="Wheel_R_11"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0,Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0,Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.Right_Drive_Wheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.0) // default is -0.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.9 // default is 1.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_HellcatTank.KParams0'
}
