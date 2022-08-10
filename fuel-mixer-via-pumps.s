# based on CowsAreEvil code from
# https://youtu.be/O0VLyV2PX9A?t=3112
alias fuelsensor d0
alias h2sensor d1
alias o2sensor d2
alias h2pump d3
alias o2pump d4
alias switch d5
alias PUMPMAX r10

define MAXPRESSURE 1000
define H2RATIO 0.666666
define O2RATIO 0.333333
define OVERCORRECT 10
define MAXPUMP 100

init:
s fuelsensor On 1
s h2sensor On 1
s o2sensor On 1

start:
yield
bdns fuelsensor init
bdns h2sensor init
bdns o2sensor init
bdns h2pump init
bdns o2pump init
bdns switch init

# is the tank isnt mixed correctly, fix it.
l r0 fuelsensor Pressure
beqz r0 nopressure
pressure:
l r2 fuelsensor RatioVolatiles
l r3 fuelsensor RatioOxygen
sub r4 H2RATIO r2
sub r5 O2RATIO r3
# overcorrect, so it doesnt take 10000 MPa to fix.
mul r5 r5 OVERCORRECT
mul r4 r4 OVERCORRECT
add r2 H2RATIO r4
add r3 O2RATIO r5
j temperature
nopressure:
move r2 H2RATIO
move r3 O2RATIO

temperature:
# account for input temperature when mixing
l r0 h2sensor Temperature
mul r0 r0 r2
l r1 o2sensor Temperature
mul r1 r1 r3
add r1 r1 r0
div r0 r0 r1

l PUMPMAX fuelsensor Pressure
div PUMPMAX PUMPMAX MAXPRESSURE
sub PUMPMAX 1 PUMPMAX
mul PUMPMAX PUMPMAX MAXPUMP
max PUMPMAX PUMPMAX 1

# set pump L 10-0 not 1-0
mul r0 r0 PUMPMAX
s h2pump Setting r0
sub r0 PUMPMAX r0
s o2pump Setting r0

l r0 switch Open
# go, no go
beqz r0 turnoff
# if the lines are mixed, don't mix.
l r2 h2sensor RatioVolatiles
blt r2 1 turnoff
l r3 o2sensor RatioOxygen
blt r3 1 turnoff
j setpumps
turnoff:
s h2pump On 0
s o2pump On 0
j start

setpumps:
# turn off if we are full
l r0 fuelsensor Pressure
slt r0 r0 MAXPRESSURE
# or if we dont have volatiles
l r1 h2sensor Pressure
sgt r1 r1 100
# or if we dont have oxygen
l r2 o2sensor Pressure
sgt r2 r2 100
and r0 r0 r1
and r0 r0 r2
s h2pump On r0
s o2pump On r0
j start
