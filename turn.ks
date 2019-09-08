global function turn{

  parameter dx.
  unlock steering.
  set orig to x.
  set xleft to 0 - x.
  set xleft to abs(xleft - dx).
  set xright to dx - x.

  if xright > xleft {
    set r to xright/4.
    lock steering to heading(dx, p)*r(0,0,r).
  }

  if xleft > xright {
    set r to -(xleft/4).
    lock steering to heading(dx, p)*r(0,0,r).
  }

  wait until vang(steering:vector, facing:vector) < 10.
  set r to 0.
  set x to dx.
  lock steering to heading(x, p)*r(0,0,r).

}
