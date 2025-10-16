# Onboard Filtration

[onboard-filtration.ic10](../../onboard-filtration.ic10)

## Purpose
Runs directly inside an atmospheric filter’s onboard chip slot, automatically enabling or disabling filtration based on installed cartridges, detected gas, and output pressure.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Filtration (with onboard IC slot) | 1 | Yes | Hosts the script and processes gases. |
| Flashing Light | 1 | Optional | Visual alert when a filter cartridge is depleted. |
| Klaxon | 1 | Optional | Audible alert when a filter cartridge is depleted. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `db` | Atmospheric filter | Direct control of the onboard filter. |
| `d0` | Flashing light | Turns on when any installed cartridge reports zero condition. |
| `d1` | Klaxon | Mirrors the flashing light alert for an audible warning. |

## Stack
Used to store filter hash tables by gas type so each slot can be validated against its cartridges.

## Batch
- Cycles through both filter slots to verify cartridges and remaining quantity.
- Compares slot occupants against known filter hashes for carbon dioxide, nitrogen, oxygen, pollutants, volatiles, water, and nitrous oxide.

## Usage
1. Install the script on an atmospheric filter’s onboard IC10 slot.
2. (Optional) Wire a flashing light to `d0` and a klaxon to `d1` if you want depleted-cartridge alerts.
3. Load appropriate cartridges into the filter slots; ensure the target gas is present on the unfiltered side.
4. Optionally tweak `PRESSURE_TARGET` (default 40 MPa) and `FILTERS_EACH` if you add new cartridge families.
5. When running, the controller:
   - Disables the filter when the outlet pressure exceeds `PRESSURE_TARGET`.
   - Checks each slot; if a slot is empty, depleted, or holds an unrecognized cartridge, filtration stops.
   - Only enables the filter when at least one valid cartridge matches the current gas type.

## Notes
- `FILTERS_EACH` defines the number of cartridge hashes per gas in the stack; extend the table if new cartridges are added.
- Because this script runs onboard, external sensors and vents are unnecessary—use `automated-filter.ic10` if you need full remote control.
- `Self Mode 0/1` directly toggles the filter; ensure no other script tries to manipulate the same filter concurrently.
- The optional light and klaxon remain off unless a slot contains a recognized cartridge at zero condition, making it easy to spot spent filters.

## Status
Work in Progress
