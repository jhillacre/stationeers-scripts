alias coolpumpin d0
alias coolpumpout d1
alias coolsensor d2
alias warmpumpin d3
alias warmpumpout d4
alias warmsensor d5

define TARGET 296.15
define SAMPLEPRESSURE 1000
define MAXCOOLPRESSURE 5000

init:
s coolsensor On 1
s warmsensor On 1
s coolpumpin Setting 1
s coolpumpout Setting 100
s warmpumpin Setting 100
s warmpumpout Setting 100

reset:
s coolpumpin On 0
s coolpumpout On 1
s warmpumpin On 0
s warmpumpout On 1
sleep 5

waitforreset:
yield
l r0 coolsensor Pressure
bnez r0 waitforreset
l r0 warmsensor Pressure
bnez r0 waitforreset
s coolpumpout On 0
s warmpumpout On 0

warmfill:
s warmpumpin On 1
s warmpumpout On 0
s coolpumpin On 0
s coolpumpout On 0

waitforwarmfill:
yield
l r0 warmsensor Pressure
ble r0 SAMPLEPRESSURE waitforwarmfill
s warmpumpin On 0

# reset if warm is cool enough
l r0 warmsensor Temperature
ble r0 TARGET reset

coolfill:
# overtarget Temperature by how warm it is
# we likely aren't cooling the whole room at once.
l r0 coolsensor Temperature
sub r1 r0 TARGET
sub r1 TARGET r1
s coolpumpin On 1
s coolpumpout On 0
s warmpumpin On 0
s warmpumpout On 0

waitforcoolfill:
yield
l r0 coolsensor Pressure
bge r0 MAXCOOLPRESSURE reset
l r0 coolsensor Temperature
bgt r0 TARGET waitforcoolfill
j reset
