alias CO2Pump d0
alias N2Pump d1
alias O2Pump d2

define GASSENSORHASH -1252983604
define TARGETCO2 0.01
define TARGETN2 0.69
define TARGETO2 0.30
define PRESSURETARGET 149
define PRESSUREMIN 101

loop:
yield
lb r0 GASSENSORHASH RatioCarbonDioxide 0
lb r1 GASSENSORHASH RatioNitrogen 0
lb r2 GASSENSORHASH RatioOxygen 0
lb r6 GASSENSORHASH Pressure 0
slt r3 r0 TARGETCO2
slt r4 r1 TARGETN2
slt r5 r2 TARGETO2
blt r6 PRESSURETARGET underpressure
move r3 0
move r4 0
move r5 0
j setpumps
underpressure:
bgt r6 PRESSUREMIN setpumps
move r3 0
move r4 1
move r5 1
setpumps:
s CO2Pump On r3
s N2Pump On r4
s O2Pump On r5
j loop
