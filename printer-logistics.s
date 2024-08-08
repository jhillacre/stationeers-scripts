# Based on Printer Logistics V4 by CowsAreEvil
# I wanted to not hardcode the hashes and 
# have digital flip flops as sorters.
# Succuess on both parts, but the non-hardcoding of hashes
# would make the script not fit in 128 lines.
# run printer-logistics-stack.s first, then this, on the same chip
alias printer d0
alias stacker d1 # Optional
alias sorter d2 # Optional, Sorter or DigitalFlipFlop
alias vending d3 # Optional
alias button d4 # Optional
alias counter r10
alias ingot r11
alias oldimport r12
define CLEARINGOT -1
define SORTERHASH HASH("StructureSorter")
define STACKSIZE 36
setup:
move ingot CLEARINGOT
s db Setting ingot
bdns sorter continueSetup
l r0 sorter PrefabHash
beq r0 SORTERHASH oldSorterSetup
newFlipFlopSetup:
s sorter Mode 0
s sorter On 0
s sorter Setting 0
s sorter SettingOutput 0
j start
oldSorterSetup:
s sorter Mode 2
s sorter On 1
continueSetup:
start:
checkButton:
bdns button checkCounter
l r0 button Setting
beqz r0 checkSorter
move ingot CLEARINGOT
s db Setting ingot
checkSorter:
bdns sorter checkCounter
ls r0 sorter 0 Occupied
beqz r0 checkIngotArrived
ls r0 sorter 0 OccupantHash
seq r0 r0 ingot
l r1 sorter PrefabHash
beq r1 SORTERHASH oldSorter
newFlipFlop: # assume non-sorters are digital flip flop chutes.
s sorter Mode r0
s sorter On 1
yield
s sorter On 0 # let us react to the next item.
j checkIngotArrived
oldSorter:
s sorter Output r0
checkIngotArrived:
l r0 printer ImportCount
ble r0 oldimport checkCounter
move ingot CLEARINGOT
s db Setting ingot
move oldimport r0
checkCounter:
bdns stacker checkRestock
l counter stacker Setting
l r0 printer Activate
bnez r0 continueCounter
s printer ClearMemory 1
move oldimport 0
beqz r0 checkRestock
continueCounter:
l r0 printer ExportCount
blt r0 counter checkRestock
s printer Activate 0
checkRestock:
yield
bdns vending start
l r0 printer Open
bnez r0 start
bne ingot CLEARINGOT start
move sp STACKSIZE
move r3 0
checkRestockLoop:
beqz sp start
pop r1 # regent hash
pop r0 # item hash
beqz r0 checkRestockFlipType
bnez r3 checkRestockJIT
checkRestockBasic:
lr r2 printer Contents r1
slt r2 r2 50
select ingot r2 r0 ingot
j continueRestock
checkRestockFlipType:
move r3 1
j checkRestockLoop
checkRestockJIT:
lr r2 printer Required r1
select ingot r2 r0 ingot
continueRestock:
bne ingot CLEARINGOT requestIngot
j checkRestockLoop
requestIngot:
s db Setting ingot
s vending RequestHash ingot
j start
