# Ore Stacker

[ore-stacker.ic10](../../ore-stacker.ic10)

## Purpose
Attempts to route ore automatically into stackers using digital flip-flop splitters, but loses track of items under sustained load.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Lever | 1 | Yes | Lockout switch to pause the sorter when closed. |
| Stacker | 1 | Yes | Receives and stores sorted ore. |
| Stacker (Reverse) | 1 | Yes | Complementary stacker for overflow/alternate sorting. |
| Digital Flip-Flop Splitter (Left/Right) | N | Yes | Acts as a programmable chute splitter for each ore type. |
| Throttle Stacker / Chute Gate | 1 | Yes | Allows one item at a time into the sorter loop. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Lever | Pauses automation when closed. |
| `d1` | Throttle stacker | Gates individual ore items into the sorter. |

## Stack
Stores the list of ore item hashes to iterate through when scanning the chute network.

## Batch
- Sets up every digital flip-flop splitter and stacker via device hash.
- Iterates through chute networks to check slot occupancy for each ore type.

## Usage
1. Wire the lever to `d0` and the throttle stacker / chute gate to `d1`.
2. Configure the chute network: create pairs of left/right digital flip-flop splitters for each ore, labeling them consistently so the IC can address them, and connect the splitters to stackers.
3. Start the script. In each cycle it:
   - Pulses the throttle stacker to allow a single item into the sorter.
   - Skips work if the lever is closed.
   - For each ore hash, scans the matched splitters. When a splitter holds the target ore, it toggles the splitter to route the item to the correct stacker, then resets.

## Notes
- Digital flip-flop splitters cannot keep up with sustained mining output; items slip through or end up in the wrong chute under heavy load.
- Consider replacing the splitter network with dedicated sorters or IC-driven conveyors; this script is retained for reference only.
- Ensure the hash list in `init` matches the ores you intend to process.

## Status
Retired
