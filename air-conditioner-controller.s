# The AC Setting doesn't match face value.
# Manage the setting via a PID controller,
# to get to a true target temperature.

alias Self db

define TARGET 294.15
define FUDGEK 1.5

alias PreviousError r15

init:
s Self Setting TARGET
s Self Mode 0 # idle
move PreviousError 0

loop:
yield
l r0 Self TemperatureOutput
l r1 Self Setting
# fudge check
sub r2 TARGET FUDGEK
add r3 TARGET FUDGEK
slt r4 r2 r0
sgt r5 r2 r0
or r6 r4 r5
s Self Mode r6
beqz r6 loop
# out of range, activated, now scale
# push and pop to pass arguments and return values
# As a stack, order is reversed on the other side
push r0 # current value
push TARGET # target value
push PreviousError # previous error
push r1 # previous setting
jal scaleSetting
pop PreviousError # new error
pop r1 # new setting
s Self Setting r1
j loop

scaleSetting:
# wipes out r0, r1, r2, r3, r4, r5, r6, r7
# args via stack: current value, target value, previous error, previous setting
# returns via stack: new value, new error
pop r3 # previous setting
pop r2 # previous error
pop r1 # target value
pop r0 # current value
sub r4 r1 r0 # error (current_error - target_value)
mul r5 r4 0.1 # proportional term (P)
mul r6 r2 0.1 # integral term (I)
sub r7 r4 r2 # derivative (difference of errors)
mul r7 r7 0.1 # derivative term (D)
add r5 r5 r6 # P + I
add r5 r5 r7 # P + I + D
add r5 r5 r3 # new setting = previous setting + P + I + D
push r5 # return new setting
push r4 # return new error
j ra
