//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_IS2CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    // Have changed several damage & similar properties to broadly comparable DH HE shells, as the RO values were at odds with them
    ShellDiameter=12.2
    BallisticCoefficient=2.35
    Speed=45866.0 // 760 m/s
    MaxSpeed=45866.0
    Damage=600.0
    DamageRadius=2000.0
    MyDamageType=class'DH_Engine.DHShellHE105mmDamageType' // a 122mm shell, but 105mm is close enough (it's a very big shell that will throw stuff around more)
    ImpactDamage=900
    ShellImpactDamage=class'DH_Vehicles.
    PenetrationMag=1250.0
    Tag="" // TODO
    StaticMesh=StaticMesh'WeaponPickupSM.Ammo.122mm_Shell'

    DHPenetrationTable(0)=9.5  // 100m
    DHPenetrationTable(1)=8.9  // 250m
    DHPenetrationTable(2)=8.5  // 500m
    DHPenetrationTable(3)=8.0
    DHPenetrationTable(4)=7.6  // 1000m
    DHPenetrationTable(5)=7.3
    DHPenetrationTable(6)=7.0  // 1500m
    DHPenetrationTable(7)=6.6
    DHPenetrationTable(8)=6.1  // 2000m
    DHPenetrationTable(9)=5.6
    DHPenetrationTable(10)=5.3 // 3000m

    ShellDeflectEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitDirtEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=class'ROEffects.ROArtillerySnowEmitter'
    ShellHitWoodEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitRockEffectClass=class'ROEffects.ROArtilleryDirtEmitter'
    ShellHitWaterEffectClass=class'ROEffects.ROArtilleryWaterEmitter'

    bMechanicalAiming=true
    MechanicalRanges(0)=(Range=0,RangeValue=0)
    MechanicalRanges(1)=(Range=400,RangeValue=38)
    MechanicalRanges(2)=(Range=500,RangeValue=45)
    MechanicalRanges(3)=(Range=600,RangeValue=57)
    MechanicalRanges(4)=(Range=700,RangeValue=65)
    MechanicalRanges(5)=(Range=800,RangeValue=77)
    MechanicalRanges(6)=(Range=900,RangeValue=88)
    MechanicalRanges(7)=(Range=1000,RangeValue=100)
    MechanicalRanges(8)=(Range=1200,RangeValue=122)
    MechanicalRanges(9)=(Range=1400,RangeValue=153)
    MechanicalRanges(10)=(Range=1600,RangeValue=185)
    MechanicalRanges(11)=(Range=1800,RangeValue=208)
    MechanicalRanges(12)=(Range=2000,RangeValue=237)
    MechanicalRanges(13)=(Range=2200,RangeValue=265)
    MechanicalRanges(14)=(Range=2400,RangeValue=298)
    MechanicalRanges(15)=(Range=2600,RangeValue=332)
    MechanicalRanges(16)=(Range=2800,RangeValue=372)
    MechanicalRanges(17)=(Range=3000,RangeValue=402)
    MechanicalRanges(18)=(Range=3200,RangeValue=447)
    MechanicalRanges(19)=(Range=3400,RangeValue=489)
    MechanicalRanges(20)=(Range=3600,RangeValue=535)
    MechanicalRanges(21)=(Range=3800,RangeValue=586)
    MechanicalRanges(22)=(Range=4000,RangeValue=644)
    MechanicalRanges(23)=(Range=4200,RangeValue=705) // estimates from here on as these extreme ranges are largely theoretical
    MechanicalRanges(24)=(Range=4400,RangeValue=765)
    MechanicalRanges(25)=(Range=4600,RangeValue=835)
    MechanicalRanges(26)=(Range=4800,RangeValue=905)
    MechanicalRanges(27)=(Range=5000,RangeValue=985)
    MechanicalRanges(28)=(Range=5200,RangeValue=1065)

    bOpticalAiming=true // just a visual range indicator on the side; doesn't actually alter the aiming point
    OpticalRanges(0)=(Range=0,RangeValue=0.42)
    OpticalRanges(1)=(Range=400,RangeValue=0.397)
    OpticalRanges(2)=(Range=500,RangeValue=0.391)
    OpticalRanges(3)=(Range=600,RangeValue=0.385)
    OpticalRanges(4)=(Range=700,RangeValue=0.379)
    OpticalRanges(5)=(Range=800,RangeValue=0.373)
    OpticalRanges(6)=(Range=900,RangeValue=0.367)
    OpticalRanges(7)=(Range=1000,RangeValue=0.361)
    OpticalRanges(8)=(Range=1200,RangeValue=0.349)
    OpticalRanges(9)=(Range=1400,RangeValue=0.337)
    OpticalRanges(10)=(Range=1600,RangeValue=0.325)
    OpticalRanges(11)=(Range=1800,RangeValue=0.313)
    OpticalRanges(12)=(Range=2000,RangeValue=0.301)
    OpticalRanges(13)=(Range=2200,RangeValue=0.289)
    OpticalRanges(14)=(Range=2400,RangeValue=0.277)
    OpticalRanges(15)=(Range=2600,RangeValue=0.265)
    OpticalRanges(16)=(Range=2800,RangeValue=0.253)
    OpticalRanges(17)=(Range=3000,RangeValue=0.241)
    OpticalRanges(18)=(Range=3200,RangeValue=0.229)
    OpticalRanges(19)=(Range=3400,RangeValue=0.217)
    OpticalRanges(20)=(Range=3600,RangeValue=0.205)
    OpticalRanges(21)=(Range=3800,RangeValue=0.193)
    OpticalRanges(22)=(Range=4000,RangeValue=0.181)
    OpticalRanges(23)=(Range=4200,RangeValue=0.169)
    OpticalRanges(24)=(Range=4400,RangeValue=0.157)
    OpticalRanges(25)=(Range=4600,RangeValue=0.145)
    OpticalRanges(26)=(Range=4800,RangeValue=0.133)
    OpticalRanges(27)=(Range=5000,RangeValue=0.121)
    OpticalRanges(28)=(Range=5200,RangeValue=0.109)
}