alias sensor d0
alias panel d1

alias panelhash r0
alias daylight r1
alias horiangle r2
alias vertangle r3
define hpark 180
define vpark 90
define hrotate 180
define vdaystart 90
define vdayend -90

reset:
# make sure panel is finished, otherwise this dies.
l panelhash panel PrefabHash

loop:
yield
l horiangle sensor Horizontal
l vertangle sensor Vertical
slt r4 vertangle vdaystart
sgt r5 vertangle vdayend
and daylight r4 r5
bnez daylight day
night:
move horiangle hpark
move vertangle vpark
day:
add horiangle horiangle hrotate
sub vertangle 90 vertangle
sb panelhash Horizontal horiangle
sb panelhash Vertical vertangle
sleep 1
j loop
