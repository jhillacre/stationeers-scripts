# open or close all network active vents depending on
#  a vent command setting
# RespondToInternal should be changed if this active
#  vent set is considered internal or external.
# intended use would have a memory / ic housing
#  mirrored from a controlling network that wants to
#  command two sets of multiple active vents.
alias ventCommand d0
alias externalSensor d1

define CLEAR 0
define EXHAUSTEXT 1
define EXHAUSTINT 2
define INTAKEEXT 3
define INTAKEINT 4
define OFFEXT 5
define OFFINT 6
define OFFALL 7

define ACTIVEVENT -1129453144
define RespondToInternal 0
define CLEARCMDSLEEP 0.5

alias doExhaust r8
alias doIntake r9
alias doOff r10

init:
sb ACTIVEVENT Lock 0
select doExhaust RespondToInternal EXHAUSTINT EXHAUSTEXT
select doIntake RespondToInternal INTAKEINT INTAKEEXT
select doOff RespondToInternal OFFINT OFFEXT

main:
yield
l r0 ventCommand Setting
beq r0 doExhaust exhaust
beq r0 doIntake intake
beq r0 doOff off
beq r0 OFFALL off
j main

exhaust:
sb ACTIVEVENT Lock 1
sb ACTIVEVENT Mode 1
sb ACTIVEVENT PressureInternal 40000
sb ACTIVEVENT PressureExternal 0
sb ACTIVEVENT On 1
j clear

intake:
sb ACTIVEVENT Lock 1
sb ACTIVEVENT Mode 0
sb ACTIVEVENT PressureInternal 0
l r0 externalSensor Pressure
sb ACTIVEVENT PressureExternal r0
sb ACTIVEVENT On 1
j clear

off:
sb ACTIVEVENT On 0
sb ACTIVEVENT Lock 0

clear:
sleep CLEARCMDSLEEP
s ventCommand Setting CLEAR
j main
