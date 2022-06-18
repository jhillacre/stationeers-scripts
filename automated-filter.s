alias filtration d0 # atmospheris filter
alias unfiltered d1 # pipe analyzer
alias filtered d2 # pipe analyzer

alias unfilteredPressure r7
alias filteredPressure r8
alias unfilteredRatio r9
alias filterNumber r10
alias badFilter r11
alias overPressure r12
alias alarmOn r13
alias filtrationOn r14

define LightHash -1535893860
define AlarmHash -828056979
define RatioMax 0 # leave under this ratio in the unfiltered side
define PressureMax 18000 # fill filtered side up to this amount

main:
jal load
slez r0 unfilteredRatio
nor filtrationOn r0 overPressure
s filtration On filtrationOn
or alarmOn badFilter overPressure
sb LightHash On alarmOn
sb AlarmHash On alarmOn
s db Setting alarmOn
yield
j main

load:
l unfilteredPressure unfiltered Pressure
l filteredPressure filtered Pressure
sge overPressure filteredPressure PressureMax
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
ls r0 filtration filterNumber Quantity
blez r0 setBadFilter
ls r0 filtration filterNumber PrefabHash
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
l unfilteredRatio unfiltered RatioNitrogen
j ra
checkOxygen:
l unfilteredRatio unfiltered RatioOxygen
j ra
checkVolatiles:
l unfilteredRatio unfiltered RatioVolatiles
j ra
checkCarbonDioxide:
l unfilteredRatio unfiltered RatioCarbonDioxide
j ra
checkNitrous:
l unfilteredRatio unfiltered RatioNitrousOxide
j ra
checkPollutants:
l unfilteredRatio unfiltered RatioPollutant
j ra
