# using airgate-set-controller.s and active-vent-set-controller.s,
#  implement a multi-airgate airlock with many active vents for speed.
# external and internal sensors should be on seperate networks to
#  dodge batch reads to inside the airlock sensors, which can be many.
# condensed formatting for lines...
alias doorCommandMemory d0
alias ventCommandMemory d1
alias internalSensorMirror d2
alias externalSensorMirror d3
define GASSENSOR -1252983604
define BUTTON 491845673
define OPENALL 1
define OPENINT 2
define OPENEXT 3
define CLOSEINT 4
define CLOSEEXT 5
define CLOSEALL 6
define EXHAUSTEXT 1
define EXHAUSTINT 2
define INTAKEEXT 3
define INTAKEINT 4
define OFFEXT 5
define OFFINT 6
define OFFALL 7
define DOORSLEEP 1
define VENTSLEEP 1
alias buttonPushed r8
alias isInternalAir r9
alias openInternal r10
init:
s ventCommandMemory Setting OFFALL
s doorCommandMemory Setting CLOSEALL
sleep DOORSLEEP
jal updateIsInternalAir
sleep 1
select r0 isInternalAir OPENINT OPENEXT
s doorCommandMemory Setting r0
sleep DOORSLEEP
move openInternal r0
main:
yield
lb buttonPushed BUTTON Activate 3
beqz buttonPushed main
pressed:
select r0 openInternal switchToExternal switchToInternal
jal r0
j main
switchToExternal:
s doorCommandMemory Setting CLOSEINT
s ventCommandMemory Setting EXHAUSTINT
push ra
jal waitForVacuum
s ventCommandMemory Setting OFFINT
sleep VENTSLEEP
s ventCommandMemory Setting INTAKEEXT
jal waitForExternalPressure
s ventCommandMemory Setting OFFEXT
s doorCommandMemory Setting OPENEXT
sleep DOORSLEEP
pop ra
move openInternal 0
j ra
switchToInternal:
s doorCommandMemory Setting CLOSEEXT
s ventCommandMemory Setting EXHAUSTEXT
push ra
jal waitForVacuum
s ventCommandMemory Setting OFFEXT
sleep VENTSLEEP
s ventCommandMemory Setting INTAKEINT
jal waitForInternalPressure
s ventCommandMemory Setting OFFINT
s doorCommandMemory Setting OPENINT
sleep DOORSLEEP
pop ra
move openInternal 1
j ra
waitForVacuum:
lb r0 GASSENSOR Pressure 3
beqz r0 ra
j waitForVacuum
waitForInternalPressure:
lb r0 GASSENSOR Pressure 3
l r1 internalSensorMirror Pressure
bap r0 r1 0.01 ra
bge r0 r1 ra
j waitForInternalPressure
waitForExternalPressure:
lb r0 GASSENSOR Pressure 3
l r1 externalSensorMirror Pressure
bap r0 r1 0.01 ra
bge r0 r1 ra
j waitForExternalPressure
updateIsInternalAir:
lb r0 GASSENSOR Temperature 0
l r1 internalSensorMirror Temperature
sap isInternalAir r0 r1 0.01
bnez isInternalAir ra
lb r0 GASSENSOR RatioCarbonDioxide 0
l r1 internalSensorMirror RatioCarbonDioxide
sap isInternalAir r0 r1 0.01
bnez isInternalAir ra
lb r0 GASSENSOR RatioNitrogen 0
l r1 internalSensorMirror RatioNitrogen
sap isInternalAir r0 r1 0.01
bnez isInternalAir ra
lb r0 GASSENSOR RatioNitrousOxide 0
l r1 internalSensorMirror RatioNitrousOxide
sap isInternalAir r0 r1 0.01
bnez isInternalAir ra
lb r0 GASSENSOR RatioOxygen 0
l r1 internalSensorMirror RatioOxygen
sap isInternalAir r0 r1 0.01
bnez isInternalAir ra
lb r0 GASSENSOR RatioPollutant 0
l r1 internalSensorMirror RatioPollutant
sap isInternalAir r0 r1 0.01
bnez isInternalAir ra
lb r0 GASSENSOR RatioVolatiles 0
l r1 internalSensorMirror RatioVolatiles
sap isInternalAir r0 r1 0.01
j ra
