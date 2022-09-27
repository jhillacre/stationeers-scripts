# assuming base of rad and sensor are north.
define EXTRADHASH -566775170
define DAYLIGHTHASH 1076425094

loop:
yield
lb r0 DAYLIGHTHASH Activate 3
lb r1 EXTRADHASH Open 3
lb r2 DAYLIGHTHASH Vertical 3
lb r3 DAYLIGHTHASH Horizontal 3
bgtz r0 day
move r4 90
j continue
day:
sgtz r4 r3
mul r4 r4 -360
add r4 r4 r2
abs r4 r4
continue:
sb EXTRADHASH Horizontal r4
s db Setting r4
beq r0 r1 loop
sb EXTRADHASH Open r0
j loop
