# turns on heaters on the network
# or opens digital values on the network
# based on the average temperature of liquid pipe
# analyzers

define cold 303.15
define hot 313.15
define liquidpipeanalyzer -2113838091
define liquidpipevalve -517628750
define liquidpipeheater -287495560

start:
yield
lb r0 liquidpipeanalyzer Temperature 0
lb r4 liquidpipeanalyzer Pressure 2
bgtz r4 hasLiquid
sb liquidpipevalve On 0
sb liquidpipeheater On 0
j start
hasLiquid:
sge r1 r0 hot
sle r2 r0 cold
sb liquidpipevalve On r1
sb liquidpipeheater On r2
j start
