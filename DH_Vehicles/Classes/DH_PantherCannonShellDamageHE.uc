//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PantherCannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    TankDamageModifier=0.07
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.85
    KDeathVel=300.0
    KDeathUpKick=60.0
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    HumanObliterationThreshhold=265
}
