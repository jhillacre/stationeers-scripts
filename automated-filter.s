alias filter d0
alias inputsensor d1
alias outputsensor d2
alias alarm d3

define RatioMax 0
define PressureMax 18000

wait:
yield
s filter On 0
s inputsensor On 1
s outputsensor On 1
# read pressure first so we dont get NaN ratio.
l r0 inputsensor Pressure
blez r0 wait
# todo: Change ratio gas to match your filter
l r0 inputsensor RatioCarbonDioxide
ble r0 RatioMax wait

filter:
yield
l r0 outputsensor Pressure
bge r0 PressureMax overpressure
# read pressure first so we dont get NaN ratio.
l r0 inputsensor Pressure
blez r0 wait
# todo: Change ratio gas to match your filter
l r0 inputsensor RatioCarbonDioxide
ble r0 RatioMax wait
s filter On 1
j filter

overpressure:
s filter On 0
s alarm On 1
l r0 outputsensor Pressure
blt r0 PressureMax overpressure
s alarm On 0
j wait
