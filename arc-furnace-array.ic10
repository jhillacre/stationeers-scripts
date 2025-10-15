# turn on and activate arc furnaces that have work.
alias ArcFurnace1 d0
alias ArcFurnace2 d1
alias ArcFurnace3 d2
alias ArcFurnace4 d3
alias ArcFurnace5 d4
alias ArcFurnace6 d5
alias WaitingOres r1
alias IsIdle r2
alias IsEveryLeverOn r3

define LeverHash HASH("StructureLogicSwitch")

init:
move r0 0
lb IsEveryLeverOn LeverHash Open 2

loop:
yield
# skip checking work if the device is not configured
bdns dr0 incrementLoop
jal checkWork

incrementLoop:
add r0 r0 1
beq r0 6 init
j loop

checkWork:
l IsIdle dr0 Idle
ls WaitingOres dr0 0 Quantity
beqz IsEveryLeverOn deactivateOne
blez WaitingOres deactivateOne
blez IsIdle ra
s dr0 On 1
s dr0 Activate 1
j ra

deactivateOne:
s dr0 On 0
j ra
