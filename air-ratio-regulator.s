# Manage Atmospheric Filter (from IC Housing)
alias filter d0
alias inputsensor d1
alias outputsensor d2
alias alarm d3

define DesiredRatio 0.20
define FudgeFactor 0.025
define MinIntakePressure 50
define MaxOutputPressure 18000

init:
s inputsensor On 1
s filter On 0

start:
yield
bdns filter init
bdns inputsensor init
bdns outputsensor init

l r0 outputsensor Pressure
bge r0 MaxOutputPressure overpressure
l r0 inputsensor Pressure
blt r0 MinIntakePressure turnoff
# todo: Change ratio gas to match your filter
l r0 inputsensor RatioOxygen
add r1 DesiredRatio FudgeFactor
bgt r0 r1 turnon
# do not turn off yet, but do not turn on.
bgt r0 DesiredRatio start
# fall through
turnoff:
s filter On 0
j start

turnon:
s filter On 1
j start

overpressure:
s filter On 0
bdns alarm start
s alarm On 1
l r0 outputsensor Pressure
blt r0 MaxOutputPressure overpressure
s alarm On 0
j start
