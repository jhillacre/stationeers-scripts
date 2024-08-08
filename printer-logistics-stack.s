# this script's job is to be the stack for other printer script.
# run this first on your chip, then load and run printer-logistics.s for the runtime.

init:
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
s db Setting sp
