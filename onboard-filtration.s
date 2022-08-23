alias alarm d0 # attention getter
alias emgvent d1 # emergency active vent

alias unfilteredPressure r7
alias filteredPressure r8
alias unfilteredRatio r9
alias filterNumber r10
alias badFilter r11
alias overPressure r12
alias alarmOn r13
alias filtrationOn r14
alias venting r15

define RatioMax 0 # leave under this ratio in the unfiltered side
define PressureMax 39000 # fill filtered side up to
define VentTo 38500 # Bigger number for less constant alarm...

init:
bdns alarm init
s alarm On 1
s db Setting 1
s emgvent On 0
s emgvent Mode 0
s emgvent PressureExternal 99999
s emgvent PressureInternal VentTo
s emgvent Lock 1
move venting 0
sleep 3.5

main:
jal load
slez r0 unfilteredRatio
nor filtrationOn r0 overPressure
s db Setting filtrationOn
or alarmOn badFilter overPressure
s emgvent On venting
s alarm On alarmOn
yield
j main

load:
l unfilteredPressure db PressureInput
l filteredPressure db PressureOutput
sge overPressure filteredPressure PressureMax
or venting overPressure venting
sge r0 filteredPressure VentTo
and venting r0 venting
move badFilter 0
move unfilteredRatio 0
blez unfilteredPressure ra
move filterNumber 0
push ra
jal loadRatio
pop ra
bgtz unfilteredRatio ra
move filterNumber 1
push ra
jal loadRatio
pop ra
j ra

loadRatio:
ls r0 db filterNumber Quantity
blez r0 setBadFilter
ls r0 db filterNumber PrefabHash
beq r0 632853248 checkNitrogen
beq r0 -632657357 checkNitrogen
beq r0 -1387439451 checkNitrogen
beq r0 -721824748 checkOxygen
beq r0 -1067319543 checkOxygen
beq r0 -1217998945 checkOxygen
beq r0 15011598 checkVolatiles
beq r0 1255156286 checkVolatiles
beq r0 1037507240 checkVolatiles
beq r0 1635000764 checkCarbonDioxide
beq r0 416897318 checkCarbonDioxide
beq r0 1876847024 checkCarbonDioxide
beq r0 -1247674305 checkNitrous
beq r0 1824284061 checkNitrous
beq r0 465267979 checkNitrous
beq r0 1915566057 checkPollutants
beq r0 1959564765 checkPollutants
beq r0 63677771 checkPollutants
setBadFilter:
move badFilter 1
j ra
checkNitrogen:
l unfilteredRatio db RatioNitrogenInput
j ra
checkOxygen:
l unfilteredRatio db RatioOxygenInput
j ra
checkVolatiles:
l unfilteredRatio db RatioVolatilesInput
j ra
checkCarbonDioxide:
l unfilteredRatio db RatioCarbonDioxideInput
j ra
checkNitrous:
l unfilteredRatio db RatioNitrousOxideInput
j ra
checkPollutants:
l unfilteredRatio db RatioPollutantInput
j ra
