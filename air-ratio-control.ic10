# Manage Room Gas Ratio via Pumps
alias CO2Pump d0
alias NPump d1
alias O2Pump d2
alias ExhaustPump d3
alias ExhaustActiveVent d4
alias RoomPipeAnalysizer d5
define GASSENSORHASH HASH("StructureGasSensor")
define TARGETCO2 0.01
define TARGETN 0.69
define TARGETO2 0.30
define PRESSURETARGET 149
define PRESSUREMIN 101
alias CO2Ratio r0
alias NRatio r1
alias O2Ratio r2
alias CO2PumpSetting r3
alias NPumpSetting r4
alias O2PumpSetting r5
alias ExhaustPumpSetting r6
alias RoomPressure r7
alias Proportional r9
alias Derivative r10
alias CurrError r11
alias LastError r12 # hold the popped value
alias CurrentRatio r13 # pumpSettingPD args
alias TargetRatio r14 # pumpSettingPD args
alias ScaledSetting r15# pumpSettingPD return
init:
yield
bdns CO2Pump init
bdns NPump init
bdns O2Pump init
bdns ExhaustPump init
bdns ExhaustActiveVent continueInit
s ExhaustActiveVent Mode 1
s ExhaustActiveVent On 0
s ExhaustActiveVent Lock 0
continueInit:
push 0
brlt sp 4 -1
loop:
yield
bdns RoomPipeAnalysizer useGasSensor
l CO2Ratio RoomPipeAnalysizer RatioCarbonDioxide
l NRatio RoomPipeAnalysizer RatioNitrogen
l O2Ratio RoomPipeAnalysizer RatioOxygen
l RoomPressure RoomPipeAnalysizer Pressure
j continueLoop
useGasSensor:
lb CO2Ratio GASSENSORHASH RatioCarbonDioxide 0
lb NRatio GASSENSORHASH RatioNitrogen 0
lb O2Ratio GASSENSORHASH RatioOxygen 0
lb RoomPressure GASSENSORHASH Pressure 0
continueLoop:
blt RoomPressure PRESSURETARGET underPressure
move ExhaustPumpSetting 100 # above 149 kPa
move CO2PumpSetting 0
move NPumpSetting 0
move O2PumpSetting 0
bdns ExhaustActiveVent setPumps
s ExhaustActiveVent On 1
j setPumps
underPressure:
bdns ExhaustActiveVent continueUnderPressure
s ExhaustActiveVent On 0
continueUnderPressure:
bgt RoomPressure PRESSUREMIN inRange
move ExhaustPumpSetting 0 # under 101 kPa
move CO2PumpSetting 0
move NPumpSetting 100
move O2PumpSetting 100
j setPumps
inRange:
move CurrentRatio CO2Ratio # between
move TargetRatio TARGETCO2
move sp 1
jal pumpSettingPD
move CO2PumpSetting ScaledSetting
move CurrentRatio NRatio
move TargetRatio TARGETN
move sp 2
jal pumpSettingPD
move NPumpSetting ScaledSetting
move CurrentRatio O2Ratio
move TargetRatio TARGETO2
move sp 3
jal pumpSettingPD
move O2PumpSetting ScaledSetting
div CurrentRatio RoomPressure PRESSURETARGET
move TargetRatio 1
move sp 4
jal pumpSettingPD
move ExhaustPumpSetting ScaledSetting
setPumps:
s CO2Pump Setting CO2PumpSetting
snez r15 CO2PumpSetting
s CO2Pump On r15
s NPump Setting NPumpSetting
snez r15 NPumpSetting
s NPump On r15
s O2Pump Setting O2PumpSetting
snez r15 O2PumpSetting
s O2Pump On r15
s ExhaustPump Setting ExhaustPumpSetting
snez r15 ExhaustPumpSetting
s ExhaustPump On r15
j loop
pumpSettingPD:
pop LastError
sub CurrError TargetRatio CurrentRatio
sub Derivative CurrError LastError
mul Proportional CurrError 10 # p gain
mul Derivative Derivative 2 # d gain
add ScaledSetting Proportional Derivative
push CurrError # update last error
mul ScaledSetting ScaledSetting 1000 # <0.001 = 0
round ScaledSetting ScaledSetting
div ScaledSetting ScaledSetting 1000
max ScaledSetting ScaledSetting 0
j ra
