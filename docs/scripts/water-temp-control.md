# Water Temperature Control Controller

[water-temp-control.ic10](../../water-temp-control.ic10)

## Purpose
Keeps a liquid cooling loop in the 30-40 C range by opening exterior cooling valves when the loop overheats and enabling inline heaters when the loop gets too cold. Originally tuned for Europa-grade ambient cooling but usable anywhere with convection-friendly atmosphere.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Liquid Pipe Analyzer | Any | Yes | Feeds the controller with an averaged temperature and pressure sample from the liquid loop. |
| Liquid Pipe Valve | Any | Optional | Opens to route loop fluid through exterior radiators or cold plumbing. |
| Liquid Pipe Heater | Any | Optional | Injects heat into the loop when the fluid is below the cold threshold. |

## Device Labeling
Not required. The script uses network-wide batch writes to target all connected valves and heaters of the specified types.

## Screws
Not used. The controller operates entirely through batch hashes.

## Stack
Not used.

## Batch
- `liquidpipeanalyzer` targets every liquid pipe analyzer on the network to fetch the average loop temperature and a pressure sample.
- `liquidpipevalve` opens or closes all liquid pipe valves when the loop overheats (`>= 40 C`) to vent heat through exterior radiators or exchangers.
- `liquidpipeheater` enables heaters when the loop temperature drops below 30 C to keep the fluid above freezing.

## Usage
1. Place one or more liquid pipe analyzers on the cooling/heating loop you want to regulate. Tie them, along with any liquid pipe valves and heaters, into the same logic network as the controller board.
2. Wire exterior radiators, heat exchangers, or cold manifolds behind the valves so opening them dumps heat into the environment (e.g., Europa’s atmosphere). Heaters should be in-line with the loop for gentle reheating.
3. Upload and start the script. It samples temperature across all analyzers; if any pressure sample indicates no liquid is present, it keeps both valves and heaters off.
4. When loop temperature is at or above `hot` (default 40 C), every valve turns on to expose the loop to the cold exchanger. When temperature falls back below `hot`, the valves close.
5. If the loop cools to `cold` (default 30 C) or lower, all heaters turn on until the temperature climbs above `cold`.
6. Adjust the `cold` and `hot` constants in the IC10 file to match the tolerances of your loop or the planet’s ambient temperature. The script assumes ambient temperatures low enough to use convection radiators (everywhere but Venus or Vulcan).

## Notes
- Batch writes act on every device of each type on the network. Segment separate loops by putting them on different logic networks or by editing the hash constants.
- The analyzer pressure check prevents the controller from running dry loops; ensure at least one analyzer always sees liquid.
- For vacuum-only environments, replace the exterior valve path with vacuum radiators or reconfigure the script with different device hashes.
- Modern phase-change mechanics will freeze any stagnant water left on the cold side; expect ice blockages unless you purge the loop after cooling.

## Status
Legacy
