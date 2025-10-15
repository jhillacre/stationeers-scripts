# Based on Printer Logistics V4 by CowsAreEvil
alias printer d0
alias stacker d1 # Optional
alias sorter d2 # Optional
alias vending d3 # Optional
alias button d4 # Optional
alias counter r10
alias ingot r11
alias oldimport r12
define CLEARINGOT -1
define STACKSIZE 36
setup:
move sp 0
push HASH("ItemWaspaloyIngot")
push HASH("Waspaloy")
push HASH("ItemStelliteIngot")
push HASH("Stellite")
push HASH("ItemInconelIngot")
push HASH("Inconel")
push HASH("ItemHastelloyIngot")
push HASH("Hastelloy")
push HASH("ItemAstroloyIngot")
push HASH("Astroloy")
push HASH("ItemSolderIngot")
push HASH("Solder")
push HASH("ItemInvarIngot")
push HASH("Invar")
push HASH("ItemElectrumIngot")
push HASH("Electrum")
push HASH("ItemConstantanIngot")
push HASH("Constantan")
push HASH("ItemSilverIngot")
push HASH("Silver")
push HASH("ItemNickelIngot")
push HASH("Nickel")
push HASH("ItemLeadIngot")
push HASH("Lead")
push 0 # above ingots requested as required
push 0 # below ingots are kept in stock
push HASH("ItemSteelIngot")
push HASH("Steel")
push HASH("ItemSiliconIngot")
push HASH("Silicon")
push HASH("ItemGoldIngot")
push HASH("Gold")
push HASH("ItemCopperIngot")
push HASH("Copper")
push HASH("ItemIronIngot")
push HASH("Iron")
move ingot CLEARINGOT
s db Setting ingot
bdns sorter start
s sorter Mode 2
s sorter On 1
start:
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
