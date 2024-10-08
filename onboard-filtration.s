# manage a filtration unit via onboard chip slot
# stop filtering if filtered pressure is above target
#  or if both slots are empty or not good
# start filtering if gas is present that is
#  our target gas and we have filters to use
alias Self db
define FILTERS_EACH 4
define PRESSURE_TARGET 40000
alias ReturnValue r15
alias MaxSP r10
alias SlotNum r9
alias SlotZeroStatus r8
alias SlotOneStatus r7
init:
push HASH("ItemGasFilterCarbonDioxide")
push HASH("ItemGasFilterCarbonDioxideM")
push HASH("ItemGasFilterCarbonDioxideL")
push HASH("ItemGasFilterCarbonDioxideInfinite")
push LogicType.RatioCarbonDioxideInput
push HASH("ItemGasFilterNitrogen")
push HASH("ItemGasFilterNitrogenM")
push HASH("ItemGasFilterNitrogenL")
push HASH("ItemGasFilterNitrogenInfinite")
push LogicType.RatioNitrogenInput
push HASH("ItemGasFilterOxygen")
push HASH("ItemGasFilterOxygenM")
push HASH("ItemGasFilterOxygenL")
push HASH("ItemGasFilterOxygenInfinite")
push LogicType.RatioOxygenInput
push HASH("ItemGasFilterPollutants")
push HASH("ItemGasFilterPollutantsM")
push HASH("ItemGasFilterPollutantsL")
push HASH("ItemGasFilterPollutantsInfinite")
push LogicType.RatioPollutantInput
push HASH("ItemGasFilterVolatiles")
push HASH("ItemGasFilterVolatilesM")
push HASH("ItemGasFilterVolatilesL")
push HASH("ItemGasFilterVolatilesInfinite")
push LogicType.RatioVolatilesInput
push HASH("ItemGasFilterWater")
push HASH("ItemGasFilterWaterM")
push HASH("ItemGasFilterWaterL")
push HASH("ItemGasFilterWaterInfinite")
push LogicType.RatioSteamInput
push HASH("ItemGasFilterNitrousOxide")
push HASH("ItemGasFilterNitrousOxideM")
push HASH("ItemGasFilterNitrousOxideL")
push HASH("ItemGasFilterNitrousOxideInfinite")
push LogicType.RatioNitrousOxideInput
move MaxSP sp
s Self Mode 0

loop:
yield
l r0 Self PressureOutput
l r1 Self PressureOutput2
bgt r0 PRESSURE_TARGET stopFiltering
bgt r1 PRESSURE_TARGET stopFiltering
move SlotNum 0
jal checkFilterSlot
move SlotZeroStatus ReturnValue
move SlotNum 1
jal checkFilterSlot
move SlotOneStatus ReturnValue
seq r0 SlotZeroStatus SlotOneStatus # both are equal
seq r1 SlotZeroStatus -1 # slot 0 is empty
seq r2 SlotOneStatus -1 # slot 1 is empty
and r3 r1 r2 # both are empty
seqz r4 SlotZeroStatus # slot 0 is not good
seqz r5 SlotOneStatus # slot 1 is not good
or r6 r4 r5 # either slot is not good
or r7 r3 r6 # stop if both are empty or either is not good
bnez r7 stopFiltering
l r0 Self Mode
beqz r0 startFiltering
j loop

stopFiltering:
s Self Mode 0
j loop

startFiltering:
s Self Mode 1
j loop

checkFilterSlot: # args: SlotNum
# return: isOk on ReturnValue,
# -1 is ignore, 0 is stop, 1 is fine
ls r0 Self SlotNum Occupied
select ReturnValue r0 0 -1 # ignore empty slots
beqz r0 ra
ls r0 Self SlotNum Quantity
move ReturnValue 0 # stop if filter is used up
beqz r0 ra
ls r0 Self SlotNum OccupantHash
move sp MaxSP
loopGasType:
pop r2 # gas logic type
move r4 0
loopFilters:
pop r3 # filter hash
seq r1 r0 r3
bnez r1 foundFilter
add r4 r4 1
blt r4 FILTERS_EACH loopFilters
blez sp noMatchedGasType
j loopGasType
noMatchedGasType:
move ReturnValue 0 # new filter type?
j ra
foundFilter:
l r0 Self r2
sgtz ReturnValue r0 # has gas?
j ra
