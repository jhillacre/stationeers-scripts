# Arc Furnace Array

[arc-furnace-array.ic10](../../arc-furnace-array.ic10)

## Purpose
Scans up to six arc furnaces, starting any unit that has ore waiting while observing a shared manual lockout switch.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Arc Furnace |     <=6 | Yes | Furnaces monitored for cargo and `Idle` state. |
| Logic Switch |     N | Optional | When any switch is closed, all furnaces stay offline. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0`-`d5` | Arc furnaces | Up to six furnaces to monitor (unused screws can remain unassigned). |

## Batch
- Polls every `StructureLogicSwitch` on the network via `LeverHash` to confirm the manual lockout is open.

## Usage
1. Wire as many as six arc furnaces to screws `d0`-`d5`; leave any extra screws unconnected.
2. Place one or more logic switches on the same data network to act as a safety interlock (all must be open for processing).
3. Load the script into an IC housing. It iterates over the configured furnaces, checking the item stack and `Idle` flag.
4. Whenever ore is queued and the lockout permits, the controller powers the furnace and toggles `Activate`; otherwise it shuts the furnace off.

## Notes
- The lever state is refreshed once per scan cycle; close any switch to halt every furnace until reopened.
- Extend the script with additional `d` aliases if you need to service more than six furnaces.

## Status
Functional
