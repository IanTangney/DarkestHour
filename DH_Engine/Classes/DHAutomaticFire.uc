//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHAutomaticFire extends DHProjectileFire
    abstract;

// Firing animations when player has a bipod deployed
// For weapons that can be fired three ways - from the hip, from ironsights, or from bipod deployed, e.g. Bren gun
var     name    BipodDeployFireAnim;
var     name    BipodDeployFireLoopAnim;
var     name    BipodDeployFireEndAnim;

// Modified to make the player stop firing if they are sprinting or switching to or from ironsights
simulated function bool AllowFire()
{
    if (Weapon.IsInState('IronSightZoomIn') ||
        Weapon.IsInState('IronSightZoomOut') ||
        Weapon.IsInState('TweenDown') ||
        Instigator.bIsSprinting)
    {
        return false;
    }

    return super.AllowFire();
}

// Implemented to stop weapon firing if it is no longer allowed to
function ModeTick(float DeltaTime)
{
    super.ModeTick(DeltaTime);

    if (bIsFiring && !AllowFire())
    {
        Weapon.StopFire(ThisModeNum);
    }
}

// Modified to handle different bipod firing animations
function PlayFiring()
{
    local name Anim;

    if (Weapon != none)
    {
        if (Weapon.Mesh != none)
        {
            // Weapon is auto-firing, so get an appropriate fire loop animation
            if (FireCount > 0)
            {
                if (Weapon.bUsingSights || (Instigator != none && Instigator.bBipodDeployed))
                {
                    if (Instigator != none && Instigator.bBipodDeployed && Weapon.HasAnim(BipodDeployFireLoopAnim))
                    {
                        Anim = BipodDeployFireLoopAnim;
                    }
                    else if (Weapon.HasAnim(FireIronLoopAnim))
                    {
                        Anim = FireIronLoopAnim;
                    }
                }

                if (Anim == '' && Weapon.HasAnim(FireLoopAnim))
                {
                    Anim = FireLoopAnim;
                }
            }

            // If we've identified a auto-fire loop anim then play it
            if (Anim != '')
            {
                Weapon.PlayAnim(Anim, FireLoopAnimRate, 0.0);
            }
            // Otherwise get a suitable single fire anim
            else
            {
                if (Weapon.bUsingSights || (Instigator != none && Instigator.bBipodDeployed))
                {
                    if (Instigator != none && Instigator.bBipodDeployed && Weapon.HasAnim(BipodDeployFireAnim))
                    {
                        Anim = BipodDeployFireAnim;
                    }
                    else if (Weapon.HasAnim(FireIronAnim))
                    {
                        Anim = FireIronAnim;
                    }
                }

                if (Anim == '' && Weapon.HasAnim(FireAnim))
                {
                    Anim = FireAnim;
                }

                if (Anim != '')
                {
                    Weapon.PlayAnim(Anim, FireAnimRate, FireTweenTime);
                }
            }
        }

        if (FireSounds.Length > 0)
        {
            Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);
        }
    }

    ClientPlayForceFeedback(FireForce);
    FireCount++;
}

// Modified to handle different bipod fire end animation
function PlayFireEnd()
{
    local name Anim;

    if (Weapon != none && Weapon.Mesh != none)
    {
        if (Weapon.bUsingSights || (Instigator != none && Instigator.bBipodDeployed))
        {
            if (Instigator != none && Instigator.bBipodDeployed && Weapon.HasAnim(BipodDeployFireEndAnim))
            {
                Anim = BipodDeployFireEndAnim;
            }
            else if (Weapon.HasAnim(FireIronEndAnim))
            {
                Anim = FireIronEndAnim;
            }
        }

        if (Anim == '' && Weapon.HasAnim(FireEndAnim))
        {
            Anim = FireEndAnim;
        }

        if (Anim != '')
        {
            Weapon.PlayAnim(Anim, FireEndAnimRate, FireTweenTime);
        }
    }
}

function float MaxRange()
{
    return 9000.0; // about 150 meters
}

defaultproperties
{
    bPawnRapidFireAnim=true
    FAProjSpawnOffset=(X=-20.0)
    MaxVerticalRecoilAngle=600
    MaxHorizontalRecoilAngle=120
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stSTG'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    ShellIronSightOffset=(X=15.0,Y=0.0,Z=0.0)

    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    FireIronAnim="Iron_Shoot_Loop"
    FireIronLoopAnim="Iron_Shoot_Loop"
    FireIronEndAnim="Iron_Shoot_End"

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=150.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.5

    AimError=1200.0
    BotRefireRate=0.99
}

