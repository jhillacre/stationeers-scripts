# turn on and activate arc furances that have work.
alias ArcFurnace1 d0
alias ArcFurnace2 d1
alias ArcFurnace3 d2
alias ArcFurnace4 d3
alias ArcFurnace5 d4
alias ArcFurnace6 d5

init:
move r0 0
s db Setting r0

loop:
yield

bdns dr0 inc
jal check
inc:
add r0 r0 1
s db Setting r0
beq r0 6 init
j loop


check:
l r2 dr0 Idle
ls r1 dr0 0 Quantity
blez r1 deactivate
blez r2 ra
s dr0 On 1
s dr0 Activate 1
j ra
deactivate:
s dr0 On 0
j ra
