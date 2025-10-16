# Automated Filter

[automated-filter.ic10](../../automated-filter.ic10)

## Purpose
Automates a single atmospheric filter by selecting the active cartridge, stopping when output storage is full, and raising alarms when the wrong cartridge is installed.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Atmospheric Filter |     1 | Yes | Primary filter driven by the script. |
| Gas Sensor (waste) |     1 | Yes | Measures pressure and gas ratios on the unfiltered input line. |
| Gas Sensor (storage) |     1 | Yes | Monitors pressure in the filtered output tank. |
| Light |     1 | Optional | Visual indicator when the system is in alarm or venting. |
| Alarm |     1 | Optional | Audible indicator under the same conditions. |
| Active Vent |     1 | Optional | Emergency vent that relieves filtered-side over-pressure. |

## Device Labeling
None.

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Atmospheric filter | Enables or disables the filtration unit. |
| `d1` | Waste-line sensor | Supplies unfiltered pressure and gas ratios. |
| `d2` | Storage sensor | Supplies filtered-side pressure. |
| `d3` | Light | Illuminates during alarms or venting. |
| `d4` | Alarm | Sounds during alarms or venting. |
| `d5` | Active vent | Dumps filtered gas when pressure exceeds the threshold. |

## Stack
Not used.

## Batch
- Scans both filter slots to determine which cartridge is installed and match it to the incoming gas species.
- Uses hard-coded prefab hashes for nitrogen, oxygen, volatiles, carbon dioxide, nitrous oxide, and pollutant cartridges.

## Usage
1. Wire the atmospheric filter, waste sensor, storage sensor, and optional indicators to the designated screws.
2. Configure constants:
   - `RatioMax`: maximum target-gas fraction permitted on the waste side before the filter pauses.
   - `PressureMax`: filtered-side pressure cap; hitting it stops the filter.
   - `VentTo`: pressure the emergency vent should relieve down to.
3. Install the appropriate cartridge in filter slot 0 or 1.
4. Start the script. It keeps the filter running while the waste line contains the target gas below `RatioMax` and storage pressure stays under `PressureMax`. If either limit is exceeded—or the cartridge does not match the waste gas—the filter shuts off, alarms fire, and the emergency vent engages until pressure falls below `VentTo`.

## Notes
- Add or adjust prefab hashes in `loadRatio` if new cartridge variants are introduced.
- `VentTo` should be comfortably below `PressureMax` to avoid rapid cycling of the alarm and vent.
- Set `RatioMax` slightly higher than the expected residual fraction to avoid false positives when the supply gas is already mostly pure.

## Status
Functional
