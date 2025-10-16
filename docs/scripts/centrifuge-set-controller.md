# Centrifuge Set Controller

[centrifuge-set-controller.ic10](../../centrifuge-set-controller.ic10)

## Purpose
Assuming a steady supply of dirty ore, empties any centrifuge on the network as soon as one becomes full.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Centrifuge (Electric) |     N | Yes | Dumps reagents through the shared network when triggered. |
| Lever |     1 | Yes | Acts as a manual lockout for the array. |
| IC Housing + IC10 chip |     1 | Yes | Hosts and powers the controller. |

## Device Labeling
None.

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Lever | Open to enable dumping; closed to pause the array. |

## Usage
1. Place the lever, IC housing, and centrifuges on the same data network.
2. Load the script into the IC10 chip and power the housing.
3. Pull the lever open to start automation; close it to stop and reset the array.
4. Add or remove centrifuges as needed—the script scans the network each cycle.

## Notes
- Update `CapacityEach` if you are running centrifuges with a different reagent capacity.
- Works with combustion centrifuges if you keep them fueled; the script only handles dumping.

## Status
Stable

## Credit
Inspired by Alex Bee’s “[Stationeers: Fully Automated Deep Mining Setup on One IC10](https://www.youtube.com/watch?v=E8AswNvx5oE)”.
