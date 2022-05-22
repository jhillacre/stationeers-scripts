alias coolsensor d0
alias warmpumpin d1
alias warmpumpout d2
alias warmsensor d3

define TARGET 293.15
define SAMPLEPRESSURE 1000
define MAXWARMPRESSURE 5000

init:
s coolsensor On 1
s warmsensor On 1
s warmpumpin Setting 1
s warmpumpout Setting 100

waittoreset:
sleep 5

reset:
s warmpumpin On 0
s warmpumpout On 1

waitforreset:
yield
l r0 coolsensor Pressure
beqz r0 waitforreset
l r0 warmsensor Pressure
bnez r0 waitforreset
s warmpumpout On 0

# reset if cool is warm enough
l r0 coolsensor Temperature
bge r0 TARGET waittoreset

warmfill:
s warmpumpin On 1
s warmpumpout On 0

waitforwarmfill:
yield
l r0 warmsensor Pressure
bge r0 MAXWARMPRESSURE reset
l r0 coolsensor Temperature
blt r0 TARGET waitforwarmfill
j reset
