//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHWeapon extends ROWeapon
    abstract;

var float   SwayModifyFactor;
var float   BobModifyFactor;

var bool    bIsMantling;
var float   PlayerIronsightFOV;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bIsMantling;
}

function bool AssistedReload()
{
    return false;
}

function bool IsATWeapon()
{
    return false;
}

function bool IsMGWeapon()
{
    return false;
}

simulated function bool IsMortarWeapon()
{
    return false;
}

simulated function bool WeaponAllowMantle()
{
    return true;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    ResetPlayerFOV();
}

simulated function ResetPlayerFOV()
{
    if (Instigator != none && PlayerController(Instigator.Controller) != none)
    {
        SetPlayerFOV(PlayerController(Instigator.Controller).DefaultFOV);
    }
}

simulated function SetPlayerFOV(float PlayerFOV)
{
    if (Instigator != none && PlayerController(Instigator.Controller) != none)
    {
        PlayerController(Instigator.Controller).DesiredFOV = PlayerFOV;
    }
}

simulated state StartMantle extends Busy
{
    simulated function Timer()
    {
        // Stay in this state until the mantle is complete, to keep the weapon lowered without actually switching it
        if (!bIsMantling)
        {
            GoToState('RaisingWeapon');
        }
        else
        {
            SetTimer(0.2, false);
        }
    }

    simulated function BeginState()
    {
        local int Mode;

        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (Instigator.IsLocallyControlled())
            {
                for (Mode = 0; Mode < NUM_FIRE_MODES; ++Mode)
                {
                    if (FireMode[Mode].bIsFiring)
                    {
                        ClientStopFire(Mode);
                    }
                }

                if (ClientState == WS_BringUp)
                {
                    TweenAnim(SelectAnim,PutDownTime);
                }
                else if (HasAnim(PutDownAnim))
                {
                    PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
                }
            }

            ClientState = WS_PutDown;
        }

        SetTimer(GetAnimDuration(PutDownAnim, PutDownAnimRate), false);

        for (Mode = 0; Mode < NUM_FIRE_MODES; ++Mode)
        {
            FireMode[Mode].bServerDelayStartFire = false;
            FireMode[Mode].bServerDelayStopFire = false;
        }
    }

    simulated function EndState()
    {
        if (ClientState == WS_PutDown)
        {
            ClientState = WS_Hidden;
        }
    }
}

defaultproperties
{
    PlayerIronsightFOV=60.0
    ScopeDetail=RO_TextureScope
    SwayModifyFactor=1.0
    BobModifyFactor=0.2
}
