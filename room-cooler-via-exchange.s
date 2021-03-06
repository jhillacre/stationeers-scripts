alias coolpumpin d0
alias coolpumpout d1
alias coolsensor d2
alias warmsensor d3

define TARGET 294.15
define TOOWARM 295.15
define SAMPLEPRESSURE 1000
define MAXCOOLPRESSURE 5000

init:
s coolsensor On 1
s warmsensor On 1
s coolpumpin Setting 100
s coolpumpout Setting 100

reset:
s coolpumpin On 0
s coolpumpout On 1

waitforreset:
yield
l r0 warmsensor Pressure
beqz r0 waitforreset
l r0 coolsensor Pressure
bnez r0 waitforreset
s coolpumpout On 0

waitforwork:
sleep 5
l r0 warmsensor Temperature
ble r0 TOOWARM waitforwork

coolfill:
s coolpumpin On 1
s coolpumpout On 0

waitforcoolfill:
yield
l r0 coolsensor Pressure
bge r0 MAXCOOLPRESSURE reset
l r0 warmsensor Temperature
bgt r0 TARGET waitforcoolfill
j reset
