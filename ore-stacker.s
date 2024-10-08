# Manages an array of digital flip flop splitters
# as sorters for ores into stackers. Configure a
# kill lever to pin 0.
# This is the experiment that showed that digital
# flip flop splitters as sorters can't keep up
# and let items leak under heavy use.
define SCDFFSR HASH("StructureChuteDigitalFlipFlopSplitterRight")
define SCDFFSL HASH("StructureChuteDigitalFlipFlopSplitterLeft")
define SS HASH("StructureStacker")
define SSR HASH("StructureStackerReverse")

alias Lever d0
alias ThrottleStacker d1
alias LeverState r0
alias FFOccupied r1
alias FFItemHash r2
alias HashMatch r3
alias FFTypeIndex r4
alias CurFFType r5
alias OreHash r6
alias MaxSP r15

init:
bdns Lever init
bdns ThrottleStacker init
move sp 0
push HASH("ItemCoalOre")
push HASH("ItemCobaltOre")
push HASH("ItemCopperOre")
push HASH("ItemGoldOre")
push HASH("ItemIronOre")
push HASH("ItemLeadOre")
push HASH("ItemNickelOre")
push HASH("ItemSiliconOre")
push HASH("ItemSilverOre")
push HASH("ItemUraniumOre")
move MaxSP sp

# stacker settings
sb SS On 1
sb SSR On 1
# IC mode, waits for activate
# instead of auto-activating
s ThrottleStacker Mode 1
sb SS Setting 50
sb SSR Setting 50

# flip flop splitter settings
sb SCDFFSR On 0
sb SCDFFSL On 0
sb SCDFFSR Mode 0
sb SCDFFSL Mode 0
sb SCDFFSR Setting 0
sb SCDFFSL Setting 0
sb SCDFFSR SettingOutput 0
sb SCDFFSL SettingOutput 0

main:
# let one item through
s ThrottleStacker Activate 1
yield

# kill lever, pull to allow work
l LeverState Lever Open
beqz LeverState main

# loop through ore hashes
move sp MaxSP
loopOres:
blez sp main # pop with sp=0 causes underflow
pop OreHash
# loop through flip flop splitters
move FFTypeIndex -1
loopFFs:
add FFTypeIndex FFTypeIndex 1
select CurFFType FFTypeIndex SCDFFSR SCDFFSL
beq FFTypeIndex 2 loopOres # stop loop if done
jal checkFF
j loopFFs

# check and activate devices based on hash match
checkFF:
lbns FFOccupied CurFFType OreHash 0 Occupied Sum
blez FFOccupied nextFF
lbns FFItemHash CurFFType OreHash 0 OccupantHash Sum
seq HashMatch FFItemHash OreHash
sbn CurFFType OreHash Mode HashMatch
sbn CurFFType OreHash On 1
# if we continue processing, items will squeek by
yield
sbn CurFFType OreHash On 0
sbn CurFFType OreHash Mode 0
nextFF:
j ra
