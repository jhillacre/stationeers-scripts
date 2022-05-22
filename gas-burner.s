alias furnace d0
alias fuelpump d1
alias exhaustpump d2
alias fuelsensor d3
alias exhaustsensor d4
define O2CombustRatio 0.05
define H2CombustRatio 0.1
define FuelFillPressure 1000
define MaxExhaustPressure 10000

init:
s exhaustpump On 0
s exhaustpump Setting 100
s fuelpump On 0
s fuelpump Setting 10

combust:
yield
l r0 furnace Combustion
breqz r0 3
sleep 1
j combust
l r0 furnace RatioOxygen
l r1 furnace RatioVolatiles
sgt r0 r0 O2CombustRatio
sgt r1 r1 H2CombustRatio
and r0 r0 r1
breqz r0 4
s furnace Activate 1
sleep 1
j combust
exhaust:
yield
l r0 furnace Pressure
breqz r0 4
s exhaustpump On 1
sleep 1
j exhaust
s exhaustpump On 0
l r0 exhaustsensor Pressure
brlt r0 MaxExhaustPressure 2
j combust
fill:
yield
l r0 furnace Pressure
brge r0 FuelFillPressure 3
s fuelpump On 1
j fill
s fuelpump On 0
s furnace Activate 1
j combust
