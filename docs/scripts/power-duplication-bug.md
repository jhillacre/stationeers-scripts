# Power Duplication Bug Controller

[power-duplication-bug.ic10](../../power-duplication-bug.ic10)

## Purpose
Reproduces the transformer duplication bug where parallel transformers pull the same power twice, eventually charging both battery banks from a deficit.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Battery (batt1) | 1 | Yes | First battery bank in the loop. |
| Battery (batt2) | 1 | Yes | Second battery bank in the loop. |
| Transformer (xformer11) | 1 | Yes | Parallel path from batt1 to batt2. |
| Transformer (xformer12) | 1 | Yes | Parallel path from batt1 to batt2. |
| Transformer (xformer21) | 1 | Yes | Parallel path from batt2 to batt1. |
| Transformer (xformer22) | 1 | Yes | Parallel path from batt2 to batt1. |

## Device Labeling
None.

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Battery 1 | Provides current charge and maximum capacity. |
| `d1` | Transformer 11 | Drive settings from batt1 to batt2. |
| `d2` | Transformer 12 | Duplicate path from batt1 to batt2. |
| `d3` | Battery 2 | Provides charge and maximum capacity. |
| `d4` | Transformer 21 | Drive settings from batt2 to batt1. |
| `d5` | Transformer 22 | Duplicate path from batt2 to batt1. |

## Stack
Not used.

## Batch
Not used.

## Usage
1. Wire the components in a loop so batt1 and batt2 can feed each other via two parallel transformers per direction. Pre-charge one battery slightly, leave the other empty.
2. Start the script. It alternates between the two transformer pairs:
   - When batt2 is empty, it disables the batt2→batt1 pair and enables the batt1→batt2 pair at half the maximum transformer setting.
   - When batt1 is empty, it disables the batt1→batt2 pair and enables the batt2→batt1 pair similarly.
   - Once either battery is full, it shuts all transformers off.
3. Observe that repeated toggling gradually charges both banks despite the closed loop, demonstrating the duplication bug.

## Notes
- This script is for demonstration only; running it can burn cables due to loop detection, so use low settings and supervision.
- The bug requires the grid to be power-deficit when transformers switch; adjust loads accordingly.
- Halting conditions are minimal—stop the script once the bug is reproduced.

## Status
Experimental
