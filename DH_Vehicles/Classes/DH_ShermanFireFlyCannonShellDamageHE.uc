//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanFireFlyCannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.04
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.85
    KDeathVel=300.0
    KDeathUpKick=60.0
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    VehicleMomentumScaling=1.4
    HumanObliterationThreshhold=325
}
