# fills from a reserve N2 network to a cooling loop network for condensation in the pipe.
# doesn't deal with the resulting liquid.
define LS HASH("StructureLogicSwitch")
alias CoolingPA d0
alias ReservePA d1
alias TVP d2 # point default towards the cooling loop
define N2BOILINGTEMP 75 # Stationeers N2 is built difference
define N2BOILINGPRESSURE 100
define N2MINCONDENSATIONTEMP 45 # 40, safety
define N2MINCONDENSATIONPRESSURE 10 # 6.3, safety
define N2MAXLIQUIDPRESSURE 5500 # 6000, safety
define N2LATENTHEAT 500
define RGASCONSTANT 8.3144
define MAXSTRESSFROMLIQUID 50 # %, 100% is bad
alias CoolingGasTemperature r0
alias CoolingGasPressure r1
alias CoolingGasMoles r2
alias CoolingLoopLiquid r3
alias CoolingLoopVolume r4
alias ReserveGasTemperature r5
alias ReserveGasPressure r6
alias ReserveGasMoles r7
alias ReserveTankVolume r8
alias CoolingCondensationPressure r9
alias ReserveCondensationPressure r10
alias CoolingLoopStress r11
alias Control r12
alias LastError r13
init:
yield
bdns CoolingPA init
bdns ReservePA init
bdns TVP init
s CoolingPA On 1
s ReservePA On 1
s TVP Mode 0
s TVP On 0
s TVP Setting 0
move LastError 0
next:
yield
l CoolingGasTemperature CoolingPA Temperature
l CoolingGasPressure CoolingPA Pressure
l CoolingGasMoles CoolingPA TotalMoles
l CoolingLoopLiquid CoolingPA VolumeOfLiquid
l CoolingLoopVolume CoolingPA Volume
l ReserveGasTemperature ReservePA Temperature
l ReserveGasPressure ReservePA Pressure
l ReserveGasMoles ReservePA TotalMoles
l ReserveTankVolume ReservePA Volume
lb r14 LS Open 2 # safety lockout
beqz r14 withdraw # if any closed
move r15 CoolingGasTemperature
jal calculateCondensationPressure
move CoolingCondensationPressure r15
move r15 ReserveGasTemperature
jal calculateCondensationPressure
move ReserveCondensationPressure r15
mul CoolingLoopStress CoolingLoopLiquid 5000
div CoolingLoopStress CoolingLoopStress CoolingLoopVolume
blt CoolingGasTemperature N2MINCONDENSATIONTEMP withdraw
ble ReserveGasPressure ReserveCondensationPressure withdraw
jal calculateAllInPressure
bgt CoolingCondensationPressure r15 withdraw
bgt CoolingLoopStress MAXSTRESSFROMLIQUID lowerPressure
raisePressure:
move r14 N2MAXLIQUIDPRESSURE
j setDevices
lowerPressure:
move r14 CoolingCondensationPressure
j setDevices
setDevices:
sub r14 r14 CoolingGasPressure # error
sub Control r14 LastError # derivative
move LastError r14
mul r14 r14 500 # p gain
mul Control Control 100 # d gain
add Control Control r14 # control
div Control Control ReserveGasPressure
mul Control Control 100
round Control Control
bnez Control on
s TVP On 0
j next
on:
sltz r14 Control # negative = remove
s TVP Mode r14
div Control Control 100
abs Control Control
s TVP Setting Control
s TVP On 1
j next
withdraw:
s TVP Mode 1
s TVP Setting 100
s TVP On 1
l r1 CoolingPA Pressure
bnez r1 withdraw
j next
calculateCondensationPressure:
div r14 1 r15 # 1/CurrentTemperature
div r15 1 N2BOILINGTEMP
sub r15 r15 r14
div r14 N2LATENTHEAT RGASCONSTANT
mul r15 r15 r14
exp r15 r15
mul r15 N2BOILINGPRESSURE r15
j ra
calculateAllInPressure:
add r15 ReserveGasMoles CoolingGasMoles
mul r14 ReserveGasMoles ReserveGasTemperature
# clobber ReserveCondensationPressure, low on registers, don't need it until next time.
mul ReserveCondensationPressure CoolingGasMoles CoolingGasTemperature
add r14 r14 ReserveCondensationPressure
div r14 r14 r15
mul r15 r15 RGASCONSTANT
mul r15 r15 r14
div r15 r15 CoolingLoopVolume
j ra
