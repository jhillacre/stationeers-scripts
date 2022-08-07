# display from actual & potential from before batgtery and requried after battery
alias cableanalin d0
alias cableanalout d1
alias memorya d3
alias memoryp d4
alias memoryr d5

init:
l r0 cableanalin PowerActual
l r1 cableanalin PowerPotential
l r2 cableanalout PowerRequired
s memorya Setting r0
s memoryp Setting r1
s memoryr Setting r2
yield
j init
