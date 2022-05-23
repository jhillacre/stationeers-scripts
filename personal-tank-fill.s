alias pump d0
alias storage d1

define STORAGE 1632165346
define SMARTCANISTER -668314371
define MAXPUMP 20

init:
bdns pump init
bdns storage init
l r0 storage PrefabHash
bne r0 STORAGE init

checkforfill:
yield
ls r0 storage 0 Occupied
bnez r0 fill

stop:
s pump Setting 0
s pump On 0
j checkforfill

fill:
ls r0 storage 0 PrefabHash
brne SMARTCANISTER r0 3
move r1 18000000
jr 2
move r1 9000000
ls r0 storage 0 Pressure
bgt r0 r1 stop
move r2 1
div r0 r0 r1
sub r2 r2 r0
mul r2 r2 MAXPUMP
add r2 r2 1
s pump Setting r2
s pump On 1
j checkforfill
