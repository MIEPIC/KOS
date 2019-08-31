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
//launch
CLEARSCREEN.
UNTIL SHIP:ALTITUDE > 50000{

    SET PITCH TO (90 + SQRT(SHIP:ALTITUDE * 0.2) * (-0.8)).

    PRINT "PITCH: " + PITCH AT (0,0).

    PRINT "ALT: " + SHIP:ALTITUDE AT (0,1).

    LOCK STEERING TO HEADING(INC, (90 + SQRT(SHIP:ALTITUDE * 0.2) * (-0.8))).

    IF STAGE:LIQUIDFUEL < 10 {
      LOCK THROTTLE TO 0.33.
      WAIT 5.
      STAGE.
      WAIT 5.
      LOCK THROTTLE TO 1.
    }
<<<<<<< HEAD
    IF 30000 < SHIP:ALTITUDE AND SHIP:ALTITUDE < 40000{
=======
    // Liquid fuel checker to when to stage
    IF 30000 < SHIP:ALTITUDE AND SHIP:ALTITUDE < 40000 {
>>>>>>> 9862d3c8ecadce856d7289d987efdf029eece64a
      LOCK THROTTLE TO 0.6.
    }
}
LOCK STEERING TO HEADING(INC,0).

WAIT UNTIL STAGE:LIQUIDFUEL < 1.
//test
STAGE.
// side boosters
LOCK THROTTLE TO 0.

WHEN ALTITUDE > 70000 THEN GEAR ON.

STAGE.
//core booster
SET X TO 0.

SET ORBITNODE TO NODE(TIME:SECONDS + ETA:APOAPSIS, 0, 0, 0).

ADD ORBITNODE.

UNTIL NEXTNODE:ORBIT:PERIAPSIS > NEXTNODE:ORBIT:APOAPSIS - 5000 AND NEXTNODE:ORBIT:PERIAPSIS < NEXTNODE:ORBIT:APOAPSIS{
WAIT 0.01.

SET X TO X + 1.

SET NEXTNODE:PROGRADE TO X.

}

//SET X TO 0.

//SET ORBITNODE TO NODE(TIME:SECONDS + ETA:APOAPSIS, 0, 0, 0).

//ADD ORBITNODE.

//UNTIL NEXTNODE:ORBIT:PERIAPSIS > NEXTNODE:ORBIT:APOAPSIS - 5000 AND NEXTNODE:ORBIT:PERIAPSIS < NEXTNODE:ORBIT:APOAPSIS{
//WAIT 0.01.

//SET X TO X + 1.

//SET NEXTNODE:PROGRADE TO X.

//}

CLEARSCREEN.

LIST ENGINES IN E.
SET ENGINE TO E[0].

IF NEXTNODE:DELTAV:MAG >= 40 {
  SET ENGINE:THRUSTLIMIT TO 100.
}


IF NEXTNODE:DELTAV:MAG < 40 AND NEXTNODE:DELTAV:MAG > 10 {
SET ENGINE:THRUSTLIMIT TO 10.
}

IF NEXTNODE:DELTAV:MAG <= 10{
  SET ENGINE:THRUSTLIMIT TO 0.5.
}

SET ANGLE TO NEXTNODE:DELTAV.

PRINT ANGLE.
LOCK STEERING TO NEXTNODE:DELTAV.

SET TTB TO 1.

SET ACCEL TO (ENGINE:POSSIBLETHRUST/1000)/(SHIP:MASS/1000).
// Calculates Ship acceleration
PRINT ACCEL AT (0,5).

SET TTB TO NEXTNODE:DELTAV:MAG/ACCEL.
// Calculates time to burn
PRINT TTB AT (0,2).

WARPTO(TIME:SECONDS + NEXTNODE:ETA - TTB/2 - 4).

CLEARSCREEN.

UNTIL 0 {

  PRINT NEXTNODE:DELTAV:MAG AT (0,3).
  PRINT "TTB: " + TTB/2 AT (0,1).
  PRINT "ETA: " + NEXTNODE:ETA AT (0,2).
  IF NEXTNODE:ETA <= TTB/2{BREAK.}

}
LOCK THROTTLE TO 1.

WAIT UNTIL VANG(ANGLE, NEXTNODE:DELTAV) > 90.

LOCK THROTTLE TO 0.

CLEARSCREEN.

PRINT "PROGRAM FINISHING..." AT (0,0).

WAIT 5.
SET ENGINE:THRUSTLIMIT TO 100.
