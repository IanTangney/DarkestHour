//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHArtilleryShell extends ROArtilleryShell;

// Matt: modified to handle new collision mesh actor - if we hit a col mesh, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    if (Other != none && (Other.bProjTarget || Other.bBlockActors))
    {
        if (Other.IsA('DHCollisionMeshActor'))
        {
            if (DHCollisionMeshActor(Other).bWontStopShell)
            {
                return; // exit, doing nothing, if col mesh actor is set not to stop a shell
            }

            Other = Other.Owner;
        }

        LastTouched = Other;

        if (Velocity == vect(0.0, 0.0, 0.0) || Other.IsA('Mover'))
        {
            ProcessTouch(Other, Location);
            LastTouched = none;
        }
        else
        {
            if (Other.TraceThisActor(HitLocation, HitNormal, Location, Location - 2.0 * Velocity, GetCollisionExtent()))
            {
                HitLocation = Location;
            }

            ProcessTouch(Other, HitLocation);
            LastTouched = none;

            if (Role < ROLE_Authority && Other.Role == ROLE_Authority && Pawn(Other) != none)
            {
                ClientSideTouch(Other, HitLocation);
            }
        }
    }
}

// Matt: modified to handle new collision mesh actor - if we hit a col mesh, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
// Also to call CheckVehicleOccupantsRadiusDamage() instead of DriverRadiusDamage() on a hit vehicle, to properly handle blast damage to any exposed vehicle occupants
// Also to update Instigator, so HurtRadius attributes damage to the player's current pawn
function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor         Victims, TraceHitActor;
    local ROPawn        P;
    local array<ROPawn> CheckedROPawns;
    local bool          bAlreadyChecked;
    local vector        Direction, TraceHitLocation, TraceHitNormal;
    local float         DamageScale, Distance, DamageExposure;
    local int           i;

    // Make sure nothing else runs HurtRadius() while we are in the middle of the function
    if (bHurtEntry)
    {
        return;
    }

    bHurtEntry = true;

    UpdateInstigator();

    // Find all colliding actors within blast radius, which the blast should damage
    foreach VisibleCollidingActors(class'Actor', Victims, DamageRadius, HitLocation)
    {
        // If hit collision mesh actor, switch to its owner
        if (Victims.IsA('DHCollisionMeshActor'))
        {
            if (DHCollisionMeshActor(Victims).bWontStopBlastDamage)
            {
                continue; // ignore col mesh actor if it is set not to stop blast damage
            }

            Victims = Victims.Owner;
        }

        // Don't damage this projectile, an actor already damaged by projectile impact (HurtWall), non-authority actors, or fluids
        if (Victims != self && HurtWall != Victims && Victims.Role == ROLE_Authority && !Victims.IsA('FluidSurfaceInfo'))
        {
            // Do a trace to the actor & if there's a vehicle between it & the explosion, don't apply damage
            TraceHitActor = Trace(TraceHitLocation, TraceHitNormal, Victims.Location, HitLocation);

            if (Vehicle(TraceHitActor) != none && TraceHitActor != Victims)
            {
                continue;
            }

            // Check for hit on player pawn
            P = ROPawn(Victims);

            if (P == none)
            {
                P = ROPawn(Victims.Base);
            }

            // If we hit a player pawn, make sure we haven't already registered the hit & add pawn to array of already hit/checked pawns
            if (P != none)
            {
                for (i = 0; i < CheckedROPawns.Length; ++i)
                {
                    if (CheckedROPawns[i] == P)
                    {
                        bAlreadyChecked = true;
                        break;
                    }
                }

                if (bAlreadyChecked)
                {
                    bAlreadyChecked = false;
                    continue;
                }

                CheckedROPawns[CheckedROPawns.Length] = P;

                // If player is partially shielded from the blast, calculate damage reduction scale
                DamageExposure = P.GetExposureTo(HitLocation + 50.0 * -Normal(PhysicsVolume.Gravity));

                if (DamageExposure <= 0.0)
                {
                    continue;
                }

                Victims = P;
            }

            // Calculate damage based on distance from explosion
            Direction = Victims.Location - HitLocation;
            Distance = FMax(1.0, VSize(Direction));
            Direction = Direction / Distance;
            DamageScale = 1.0 - FMax(0.0, (Distance - Victims.CollisionRadius) / DamageRadius);

            if (P != none)
            {
                DamageScale *= DamageExposure;
            }

            // Record player responsible for damage caused, & if we're damaging the LastTouched actor, reset that to avoid damaging it again at the end of function
            if (Instigator == none || Instigator.Controller == none)
            {
                Victims.SetDelayedDamageInstigatorController(InstigatorController);
            }

            if (Victims == LastTouched)
            {
                LastTouched = none;
            }

            // Damage the actor hit by the blast - if it's a vehicle, check for damage to any occupants
            Victims.TakeDamage(DamageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * Direction,
                DamageScale * Momentum * Direction, DamageType);

            if (ROVehicle(Victims) != none && ROVehicle(Victims).Health > 0)
            {
                CheckVehicleOccupantsRadiusDamage(ROVehicle(Victims), DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
            }
        }
    }

    // Same (or very similar) process for the last actor this projectile hit (Touched), but only happens if actor wasn't found by the check for VisibleCollidingActors
    if (LastTouched != none && LastTouched != self && LastTouched.Role == ROLE_Authority && !LastTouched.IsA('FluidSurfaceInfo'))
    {
        Victims = LastTouched;
        LastTouched = none;

        if (Victims.IsA('DHCollisionMeshActor'))
        {
            if (DHCollisionMeshActor(Victims).bWontStopBlastDamage)
            {
                bHurtEntry = false;

                return; // exit, doing nothing, if col mesh actor is set not to stop blast damage
            }

            Victims = Victims.Owner;
        }

        Direction = Victims.Location - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = FMax(Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight), 1.0 - FMax(0.0, (Distance - Victims.CollisionRadius) / DamageRadius));

        if (Instigator == none || Instigator.Controller == none)
        {
            Victims.SetDelayedDamageInstigatorController(InstigatorController);
        }

        Victims.TakeDamage(DamageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * Direction,
            DamageScale * Momentum * Direction, DamageType);

        if (ROVehicle(Victims) != none && ROVehicle(Victims).Health > 0)
        {
            CheckVehicleOccupantsRadiusDamage(ROVehicle(Victims), DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }
    }

    bHurtEntry = false;
}

// New function to check for possible blast damage to all vehicle occupants that don't have collision of their own & so won't be 'caught' by HurtRadius()
function CheckVehicleOccupantsRadiusDamage(ROVehicle V, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local ROVehicleWeaponPawn WP;
    local int i;

    if (V.Driver != none && V.DriverPositions[V.DriverPositionIndex].bExposed && !V.Driver.bCollideActors && !V.bRemoteControlled)
    {
        VehicleOccupantRadiusDamage(V.Driver, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
    }

    for (i = 0; i < V.WeaponPawns.Length; ++i)
    {
        WP = ROVehicleWeaponPawn(V.WeaponPawns[i]);

        if (WP != none && WP.Driver != none && ((WP.bMultiPosition && WP.DriverPositions[WP.DriverPositionIndex].bExposed) || WP.bSinglePositionExposed)
            && !WP.bCollideActors && !WP.bRemoteControlled)
        {
            VehicleOccupantRadiusDamage(WP.Driver, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }
    }
}

// New function to handle blast damage to vehicle occupants
function VehicleOccupantRadiusDamage(Pawn P, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor  TraceHitActor;
    local coords HeadBoneCoords;
    local vector HeadLocation, TraceHitLocation, TraceHitNormal, Direction;
    local float  Distance, DamageScale;

    if (P != none)
    {
        HeadBoneCoords = P.GetBoneCoords(P.HeadBone);
        HeadLocation = HeadBoneCoords.Origin + ((P.HeadHeight + (0.5 * P.HeadRadius)) * P.HeadScale * HeadBoneCoords.XAxis);

        // Trace from the explosion to the top of player pawn's head & if there's a blocking actor in between (probably the vehicle), exit without damaging pawn
        foreach TraceActors(class'Actor', TraceHitActor, TraceHitLocation, TraceHitNormal, HeadLocation, HitLocation)
        {
            if (TraceHitActor.bBlockActors)
            {
                return;
            }
        }

        // Calculate damage based on distance from explosion
        Direction = P.Location - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = 1.0 - FMax(0.0, (Distance - P.CollisionRadius) / DamageRadius);

        // Damage the vehicle occupant
        if (DamageScale > 0.0)
        {
            P.SetDelayedDamageInstigatorController(InstigatorController);

            P.TakeDamage(DamageScale * DamageAmount, InstigatorController.Pawn, P.Location - (0.5 * (P.CollisionHeight + P.CollisionRadius)) * Direction,
                DamageScale * Momentum * Direction, DamageType);
        }
    }
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing explosion effects to be skipped
// Vehicle's rotation was not being factored into calcs using the PlayerController's rotation, which effectively randomised the result of this function
// Also re-factored to make it a little more optimised, direct & easy to follow (without repeated use of bResult)
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated)
{
    local PlayerController    PC;
    local Vehicle             V;
    local VehicleWeaponPawn   VWP;
    local DHVehicleCannonPawn CP;
    local rotator             PCRelativeRotation;
    local vector              PCNonRelativeRotationVector;

    // Only relevant on a dedicated server if the bForceDedicated option has been passed
    if (Level.NetMode == NM_DedicatedServer)
    {
        return bForceDedicated;
    }

    // Net clients
    if (Role < ROLE_Authority)
    {
        // Always relevant for the owning net player, i.e. the player that fired the projectile
        if (Instigator != none && Instigator.IsHumanControlled())
        {
            return true;
        }

        // Not relevant for other net clients if projectile has not been drawn on their screen recently
        if (SpawnLocation == Location)
        {
            if ((Level.TimeSeconds - LastRenderTime) >= 3.0)
            {
                return false;
            }
        }
        else if (Instigator == none || (Level.TimeSeconds - Instigator.LastRenderTime) >= 3.0)
        {
            return false;
        }
    }

    PC = Level.GetLocalPlayerController();

    if (PC == none || PC.ViewTarget == none)
    {
        return false;
    }

    // Check to see whether the effect would spawn off to the side or behind where the player is facing, & if so then only spawn if within quite close distance
    // (doesn't apply to the player that fired the projectile)
    if (PC.Pawn != Instigator)
    {
        V = Vehicle(PC.Pawn);

        // If player is in a vehicle using relative view rotation (nearly all of them), we need to factor in the vehicle's rotation
        if (V != none && V.bPCRelativeFPRotation)
        {
            VWP = VehicleWeaponPawn(V);

            // For vehicle weapons we must use the Gun or VehicleBase rotation (they match), not the weapon pawn's rotation
            if (VWP != none)
            {
                PCRelativeRotation = PC.Rotation;
                CP = DHVehicleCannonPawn(VWP);

                // For turrets we also need to factor in the turret's yaw
                if (CP != none && CP.Cannon != none && CP.Cannon.bHasTurret)
                {
                    PCRelativeRotation.Yaw += CP.Cannon.CurrentAim.Yaw;
                }

                PCNonRelativeRotationVector = vector(PCRelativeRotation) >> VWP.Gun.Rotation; // note Gun's rotation is effectively same as the vehicle base
            }
            // For vehicle themselves, we just use the vehicle's rotation
            else
            {
                PCNonRelativeRotationVector = vector(PC.Rotation) >> V.Rotation;
            }
        }
        // For player's that aren't in vehicles or the vehicle doesn't use relative view rotation, we simply use the PC's rotation
        else
        {
            PCNonRelativeRotationVector = vector(PC.Rotation);
        }

        // Effect would spawn off to the side or behind where the player is facing, so only spawn if within quite close distance
        if (PCNonRelativeRotationVector dot (SpawnLocation - PC.ViewTarget.Location) < 0.0)
        {
            return VSizeSquared(PC.ViewTarget.Location - SpawnLocation) < 2560000.0; // equivalent to 1600 UU or 26.5m (changed to VSizeSquared as more efficient)
        }
    }

    // Effect relevance is based on normal distance check
    // If we got here, it means the effect would spawn broadly in front of where the player is facing, or we are the player responsible for the projectile
    return CheckMaxEffectDistance(PC, SpawnLocation);
}

// New function updating Instigator reference to ensure damage is attributed to correct player, as may have switched to different pawn since calling arty, e.g. entered vehicle or died
simulated function UpdateInstigator()
{
    if (InstigatorController != none && InstigatorController.Pawn != none)
    {
        Instigator = InstigatorController.Pawn;
    }
}

defaultproperties
{
}
