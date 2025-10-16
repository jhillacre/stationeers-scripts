# this script manages a centrifuge array
# pull the lever to signal for work
# to proceed.
define SC HASH("StructureCentrifuge")
define CapacityEach 400
alias Lever d0
init:
bdns Lever init
sb SC On 1

loop:
yield
lb r0 SC Reagents Maximum
l r4 Lever Open
beqz r4 manualOpen
seq r1 r0 CapacityEach
seqz r2 r0
move r3 -1
select r3 r1 1 r3
select r3 r2 0 r3
beq r3 -1 loop
sb SC Open r3
j loop

manualOpen:
sb SC Open r3
awaitEmpty:
yield
l r4 Lever Open
bnez r4 loop
lb r0 SC Reagents Maximum
bnez r4 awaitEmpty
j loop
