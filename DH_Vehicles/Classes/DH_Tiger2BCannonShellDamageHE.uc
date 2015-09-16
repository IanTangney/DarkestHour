//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Tiger2BCannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.08
    APCDamageModifier=0.5
    VehicleDamageModifier=1.5
    TreadDamageModifier=1.0
    KDamageImpulse=6000.0
    KDeathVel=300.0
    KDeathUpKick=60.0
    VehicleMomentumScaling=1.6
    HumanObliterationThreshhold=450
}
