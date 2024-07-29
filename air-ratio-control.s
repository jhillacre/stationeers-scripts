# Manage Room Gas Ratio via Pumps
alias CO2Pump d0
alias N2Pump d1
alias O2Pump d2
alias ExhaustPump d3

define GASSENSORHASH HASH("StructureGasSensor")
define TARGETCO2 0.01
define TARGETN2 0.69
define TARGETO2 0.30
define PRESSURETARGET 149
define PRESSUREMIN 101

alias CO2Ratio r0
alias N2Ratio r1
alias O2Ratio r2
alias CO2PumpSetting r3
alias N2PumpSetting r4
alias O2PumpSetting r5
alias ExhaustPumpSetting r6
alias RoomPressure r7
alias CO2PumpMax r8
alias N2PumpMax r9
alias O2PumpMax r10
alias ExhaustPumpMax r11
# scalePump args
alias MaxPumpSetting r12
alias CurrentRatio r13
alias TargetRatio r14
alias ScaledSetting r15

init:
yield
bdns CO2Pump init
bdns N2Pump init
bdns O2Pump init
bdns ExhaustPump init
l CO2PumpMax CO2Pump Maximum
l N2PumpMax N2Pump Maximum
l O2PumpMax O2Pump Maximum
l ExhaustPumpMax ExhaustPump Maximum

loop:
yield
lb CO2Ratio GASSENSORHASH RatioCarbonDioxide 0
lb N2Ratio GASSENSORHASH RatioNitrogen 0
lb O2Ratio GASSENSORHASH RatioOxygen 0
lb RoomPressure GASSENSORHASH Pressure 0
blt RoomPressure PRESSURETARGET underPressure
# above 149 kPa
move ExhaustPumpSetting ExhaustPumpMax
move CO2PumpSetting 0
move N2PumpSetting 0
move O2PumpSetting 0
j setPumps

underPressure:
bgt RoomPressure PRESSUREMIN inRange
# under 101 kPa
move ExhaustPumpSetting 0
move CO2PumpSetting 0
move N2PumpSetting N2PumpMax
move O2PumpSetting O2PumpMax
j setPumps

inRange:
move MaxPumpSetting CO2PumpMax
move CurrentRatio CO2Ratio
move TargetRatio TARGETCO2
jal scalePump
move CO2PumpSetting ScaledSetting

move MaxPumpSetting N2PumpMax
move CurrentRatio N2Ratio
move TargetRatio TARGETN2
jal scalePump
move N2PumpSetting ScaledSetting

move MaxPumpSetting O2PumpMax
move CurrentRatio O2Ratio
move TargetRatio TARGETO2
jal scalePump
move O2PumpSetting ScaledSetting

move MaxPumpSetting ExhaustPumpMax
move CurrentRatio RoomPressure
move TargetRatio PRESSURETARGET
jal scalePump
move ExhaustPumpSetting ScaledSetting

setPumps:
s CO2Pump Setting CO2PumpSetting
snez r15 CO2PumpSetting
s CO2Pump On r15

s N2Pump Setting N2PumpSetting
snez r15 N2PumpSetting
s N2Pump On r15

s O2Pump Setting O2PumpSetting
snez r15 O2PumpSetting
s O2Pump On r15

s ExhaustPump On ExhaustPumpSetting
snez r15 ExhaustPumpSetting
s ExhaustPump On r15
j loop

scalePump:
sub ScaledSetting TargetRatio CurrentRatio
abs ScaledSetting ScaledSetting
mul ScaledSetting ScaledSetting ScaledSetting
mul ScaledSetting ScaledSetting MaxPumpSetting
mul ScaledSetting ScaledSetting 0.8
add ScaledSetting ScaledSetting MaxPumpSetting
j ra
