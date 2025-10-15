# fills from a reserve N network to a cooling loop
# network for condensation in the pipe.
# doesn't deal with the resulting liquid.
define LS HASH("StructureLogicSwitch")
alias CoolingPA d0
alias ReservePA d1
alias TVP d2 # point default towards the cooling loop
# Stationeers N is built different
define NBOILINGTEMP 75
define NBOILINGPRESSURE 100
define NMINCONDENSATIONTEMP 45 # 40, safety
define NMINCONDENSATIONPRESSURE 10 # 6.3, safety
define NMAXLIQUIDPRESSURE 5500 # 6000, safety
define NLATENTHEAT 500
define RGASCONSTANT 8.3144
define MAXSTRESSFROMLIQUID 50 # %, 100% is bad
alias CGT r0 # CoolingGasTemperature
alias CGP r1 # CoolingGasPressure
alias CGM r2 # CoolingGasMoles
alias CLL r3 # CoolingLoopLiquid
alias CLV r4 # CoolingLoopVolume
alias RGT r5 # ReserveGasTemperature
alias RGP r6 # ReserveGasPressure
alias RGM r7 # ReserveGasMoles
alias RTV r8 # ReserveTankVolume
alias CCP r9 # CoolingCondensationPressure
alias RCP r10 # ReserveCondensationPressure
alias CLS r11 # CoolingLoopStress
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
l CGT CoolingPA Temperature
l CGP CoolingPA Pressure
l CGM CoolingPA TotalMoles
l CLL CoolingPA VolumeOfLiquid
l CLV CoolingPA Volume
l RGT ReservePA Temperature
l RGP ReservePA Pressure
l RGM ReservePA TotalMoles
l RTV ReservePA Volume
lb r14 LS Open 2 # safety lockout
beqz r14 withdraw # if any closed
move r15 CGT
jal calculateCondensationPressure
move CCP r15
move r15 RGT
jal calculateCondensationPressure
move RCP r15
mul CLS CLL 5000
div CLS CLS CLV
blt CGT NMINCONDENSATIONTEMP withdraw
ble RGP RCP withdraw
jal calculateAllInPressure
bgt CCP r15 withdraw
bgt CLS MAXSTRESSFROMLIQUID lowerPressure
raisePressure:
move r14 NMAXLIQUIDPRESSURE
j setDevices
lowerPressure:
move r14 CCP
j setDevices
setDevices:
sub r14 r14 CGP # error
sub Control r14 LastError # derivative
move LastError r14
mul r14 r14 500 # p gain
mul Control Control 100 # d gain
add Control Control r14 # control
div Control Control RGP
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
div r15 1 NBOILINGTEMP
sub r15 r15 r14
div r14 NLATENTHEAT RGASCONSTANT
mul r15 r15 r14
exp r15 r15
mul r15 NBOILINGPRESSURE r15
j ra
calculateAllInPressure:
add r15 RGM CGM
mul r14 RGM RGT
# clobber RCP, low on registers,
# don't need it until next time.
mul RCP CGM CGT
add r14 r14 RCP
div r14 r14 r15
mul r15 r15 RGASCONSTANT
mul r15 r15 r14
div r15 r15 CLV
j ra
