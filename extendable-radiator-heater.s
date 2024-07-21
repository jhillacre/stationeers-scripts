define EXTRADHASH -566775170
define DAYLIGHTHASH 1076425094

alias daylightActive r0
alias radiatorOpen r1
alias verticalAngle r2
alias horizontalAngle r3
alias adjustedAngle r4
alias doCooling r5

init:
move doCooling 0 # Change this to 1 for cooling.

loop:
yield

lb daylightActive DAYLIGHTHASH Activate 3
lb radiatorOpen EXTRADHASH Open 3
lb verticalAngle DAYLIGHTHASH Vertical 3
lb horizontalAngle DAYLIGHTHASH Horizontal 3

bgtz daylightActive day

night:
# park angle
move adjustedAngle -45
sb EXTRADHASH Open doCooling
j continue

day:
# account for positive/negative angle so the radiator
# doesn't waste time doing a full-turn on a sign change.
sltz adjustedAngle r3
mul adjustedAngle adjustedAngle -360
add adjustedAngle adjustedAngle verticalAngle
abs adjustedAngle adjustedAngle
beq daylightActive radiatorOpen continue
sb EXTRADHASH Open 1

continue:
sb EXTRADHASH Horizontal adjustedAngle
s db Setting adjustedAngle
j loop
