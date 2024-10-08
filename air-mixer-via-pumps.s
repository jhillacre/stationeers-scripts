# based on CowsAreEvil code from
# https://youtu.be/O0VLyV2PX9A?t=3112
alias airsensor d0
alias nsensor d1
alias o2sensor d2
alias npump d3
alias o2pump d4
alias switch d5
alias PUMPMAX r10

define MAXPRESSURE 1000
define nRATIO 0.8
define O2RATIO 0.2
define OVERCORRECT 5
define MAXPUMP 20

init:
s airsensor On 1
s nsensor On 1
s o2sensor On 1

start:
yield
bdns airsensor init
bdns nsensor init
bdns o2sensor init
bdns npump init
bdns o2pump init
bdns switch init

# if the tank is not mixed correctly, fix it.
l r0 airsensor Pressure
beqz r0 nopressure
pressure:
l r2 airsensor RatioNitrogen
l r3 airsensor RatioOxygen
sub r4 nRATIO r2
sub r5 O2RATIO r3
# overcorrect, so it does not take 10000 MPa to fix.
mul r5 r5 OVERCORRECT
mul r4 r4 OVERCORRECT
add r2 nRATIO r4
add r3 O2RATIO r5
j temperature
nopressure:
move r2 nRATIO
move r3 O2RATIO

temperature:
# account for input temperature when mixing
l r0 nsensor Temperature
mul r0 r0 r2
l r1 o2sensor Temperature
mul r1 r1 r3
add r1 r1 r0
div r0 r0 r1

l PUMPMAX airsensor Pressure
div PUMPMAX PUMPMAX MAXPRESSURE
sub PUMPMAX 1 PUMPMAX
mul PUMPMAX PUMPMAX MAXPUMP
max PUMPMAX PUMPMAX 1

# set pump L PUMPMAX-0 not 1-0
mul r0 r0 PUMPMAX
s npump Setting r0
sub r0 PUMPMAX r0
s o2pump Setting r0

l r0 switch Open
# go, no go
brnez r0 4
s npump On 0
s o2pump On 0
j start

# turn off if we are full
l r0 airsensor Pressure
slt r0 r0 MAXPRESSURE
# or if we dont have nitrogen
l r1 nsensor Pressure
sgt r1 r1 100
# or if we dont have oxygen
l r2 o2sensor Pressure
sgt r2 r2 100
and r0 r0 r1
and r0 r0 r2
s npump On r0
s o2pump On r0
j start
