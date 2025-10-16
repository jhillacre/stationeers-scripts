# Power Analyzer Mirror

[power-analyzer-mirror.ic10](../../power-analyzer-mirror.ic10)

## Purpose
Copies live cable analyzer readings into memory registers so other controllers can reference power metrics remotely.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Cable Analyzer (source) |     1 | Yes | Provides `PowerActual` and `PowerPotential` readings upstream of a battery. |
| Cable Analyzer (load) |     1 | Yes | Provides `PowerRequired` readings downstream of the battery. |
| Memory |     3 | Yes | Mirrors actual, potential, and required power values for other scripts. |

## Device Labeling
None.

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Source analyzer | Supplies actual power draw. |
| `d1` | Load analyzer | Supplies required power. |
| `d3` | Memory A | Stores actual power (`Setting`). |
| `d4` | Memory P | Stores potential power. |
| `d5` | Memory R | Stores required power. |

## Stack
Not used.

## Batch
Not used.

## Usage
1. Wire the upstream cable analyzer (before the battery) to `d0` and the downstream analyzer (after the battery) to `d1`.
2. Attach three memory chips to `d3`, `d4`, and `d5` for the mirrored values.
3. Load and run the script; it continuously writes the analyzer readings to the memories’ `Setting` fields each tick.
4. Other IC10 scripts can `l`oad from the shared memories to make decisions without polling the analyzers directly.

## Notes
- Expand the script with additional aliases if you need to mirror more analyzer fields (e.g., `Power` or `Charge`).
- Keep the mirrors on the same network as consumers to avoid costly cross-network polling.
- Displays and logic writers can read memory values directly, so mirroring analyzer data into memory makes it accessible without custom device support.

## Status
Functional
