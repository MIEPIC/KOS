PARAMETER INC.

CLEARSCREEN.
PRINT "3..." AT (0,0).
WAIT 1.
PRINT "2..." AT (0,0).
WAIT 1.
PRINT "1..." AT (0,0).
WAIT 1.
PRINT "LAUNCH" AT (0,0).
LOCK THROTTLE TO 1.
STAGE.
// Launch sequence

CLEARSCREEN.
UNTIL SHIP:ALTITUDE > 50000 {

    SET PITCH TO (90 + SQRT(SHIP:ALTITUDE * 0.2) * (-0.8)).

    PRINT "PITCH: " + PITCH AT (0,0).

    PRINT "ALT: " + SHIP:ALTITUDE AT (0,1).

    LOCK STEERING TO HEADING(INC, (90 + SQRT(SHIP:ALTITUDE * 0.2) * (-0.8))).
    // Pitch over equation
    IF STAGE:LIQUIDFUEL < 10 {
      LOCK THROTTLE TO 0.33.
      WAIT 5.
      STAGE.
      WAIT 5.
      LOCK THROTTLE TO 1.
    }
    // Liquid fuel checker to when to stage
    IF 30000 < SHIP:ALTITUDE AND SHIP:ALTITUDE < 40000 {
      LOCK THROTTLE TO 0.6.
    }
    // Max Q throttle lowerer
}

LOCK STEERING TO HEADING(INC,0).
// Bottoms out pitch when above 50k Meters

WAIT UNTIL STAGE:LIQUIDFUEL < 1.
// Stager

STAGE.
// Side boosters separation

LOCK THROTTLE TO 0.
WAIT 1.

STAGE.
// Core booster seperation

SET X TO 0.

SET ORBITNODE TO NODE(TIME:SECONDS + ETA:APOAPSIS, 0, 0, 0).

ADD ORBITNODE.

UNTIL NEXTNODE:ORBIT:PERIAPSIS > NEXTNODE:ORBIT:APOAPSIS - 5000 AND NEXTNODE:ORBIT:PERIAPSIS < NEXTNODE:ORBIT:APOAPSIS {
// Incrementally increasing the node deltaV until the apoapsis and periapsis are close

WAIT 0.01.

SET X TO X + 1.

SET NEXTNODE:PROGRADE TO X.

}
// Setting up node

CLEARSCREEN.

SET ENGINE TO SHIP:PARTSTAGGED("ENGINE")[0].
// Declaring engine

IF NEXTNODE:DELTAV:MAG >= 40 {
  SET ENGINE:THRUSTLIMIT TO 100.
}


IF NEXTNODE:DELTAV:MAG < 40 AND NEXTNODE:DELTAV:MAG > 10 {
SET ENGINE:THRUSTLIMIT TO 10.
}

IF NEXTNODE:DELTAV:MAG <= 10 {
  SET ENGINE:THRUSTLIMIT TO 0.5.
}
// Changing thrust limiter


SET ANGLE TO NEXTNODE:DELTAV.

PRINT ANGLE.
LOCK STEERING TO NEXTNODE:DELTAV.
// Locks steering to node vector

SET ACCEL TO (ENGINE:POSSIBLETHRUST/1000)/(SHIP:MASS/1000).
// Calculates Ship acceleration
PRINT ACCEL AT (0,5).

SET TTB TO NEXTNODE:DELTAV:MAG/ACCEL.
// Calculates time to burn for node
PRINT TTB AT (0,2).

WARPTO(TIME:SECONDS + NEXTNODE:ETA - TTB/2 - 60).
WAIT UNTIL VANG(SHIP:FACING:VECTOR, NEXTNODE:DELTAV) < 5.
WARPTO(TIME:SECONDS + NEXTNODE:ETA - TTB/2 - 4).
// Warping and lineup sequence

CLEARSCREEN.

UNTIL 0 {

  PRINT NEXTNODE:DELTAV:MAG AT (0,3).
  PRINT "TTB: " + TTB/2 AT (0,1).
  PRINT "ETA: " + NEXTNODE:ETA AT (0,2).
  IF NEXTNODE:ETA <= TTB/2 {
    BREAK.
  }

}
// Waits until burn time

LOCK THROTTLE TO 1.
WHEN NEXTNODE:DELTAV:MAG < 50 THEN LOCK THROTTLE TO NEXTNODE:DELTAV:MAG/50 + 0.1.
// Sets throttle curve

WAIT UNTIL VANG(ANGLE, NEXTNODE:DELTAV) > 90.
// Sees when deltav of nextnode is low

LOCK THROTTLE TO 0.

CLEARSCREEN.

PRINT "PROGRAM FINISHING..." AT (0,0).

WAIT 5.
SET ENGINE:THRUSTLIMIT TO 100.
// Resets engine thrust limit
