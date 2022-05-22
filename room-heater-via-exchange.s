alias coolpumpin d0
alias coolpumpout d1
alias coolsensor d2
alias warmpumpin d3
alias warmpumpout d4
alias warmsensor d5

define TARGET 293.15
define SAMPLEPRESSURE 1000
define MAXWARMPRESSURE 5000

init:
s coolsensor On 1
s warmsensor On 1
s coolpumpin Setting 100
s coolpumpout Setting 100
s warmpumpin Setting 1
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

coolfill:
s coolpumpin On 1
s coolpumpout On 0
s warmpumpin On 0
s warmpumpout On 0

waitforcoolfill:
yield
l r0 coolsensor Pressure
ble r0 SAMPLEPRESSURE waitforcoolfill
s coolpumpin On 0

# reset if cool is warm enough
l r0 coolsensor Temperature
bge r0 TARGET reset

warmfill:
# overtarget Temperature by how cool it is, we likely aren't heating the whole room at once.
l r0 coolsensor Temperature
sub TARGET r0 r1
add r1 TARGET r1
s coolpumpin On 0
s coolpumpout On 0
s warmpumpin On 1
s warmpumpout On 0

waitforwarmfill:
yield
l r0 warmsensor Pressure
bge r0 MAXWARMPRESSURE reset
l r0 coolsensor Temperature
blt r0 r1 waitforwarmfill
j reset
