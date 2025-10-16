go# Gas Burner

[gas-burner.ic10](../../gas-burner.ic10)

## Purpose
Controls a furnace equipped with hydrogen/oxygen supply and exhaust pumps, keeping the chamber fueled, maintaining mixture ratios, and venting when exhaust pressure climbs.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Furnace | 1 | Yes | Target combustion chamber to ignite. |
| Volume Pump (fuel) | 1 | Yes | Feeds hydrogen into the furnace. |
| Volume Pump (exhaust) | 1 | Yes | Pulls exhaust gases out of the furnace. |
| Gas Sensor (fuel supply) | 1 | Yes | Measures hydrogen tank pressure/purity. |
| Gas Sensor (exhaust loop) | 1 | Yes | Monitors backpressure to avoid overfilling the exhaust line. |

## Device Labeling
None. Orient the volume pumps so fuel mode pushes toward the furnace and exhaust mode pulls away.

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Furnace | Exposes activation state and combustion ratios. |
| `d1` | Fuel pump | Controls hydrogen inflow. |
| `d2` | Exhaust pump | Controls exhaust outflow. |
| `d3` | Fuel sensor | Supplies pressure data for the fuel source. |
| `d4` | Exhaust sensor | Supplies exhaust pressure for overpressure detection. |

## Stack
Not used.

## Batch
Not used.

## Usage
1. Wire the furnace, two volume pumps, and both gas sensors to the designated screws.
2. Tune the constants if needed: `FuelFillPressure` sets the target furnace charge, `MaxExhaustPressure` caps exhaust backpressure, and the `*CombustRatio` values define minimum oxygen/hydrogen ratios before attempting ignition.
3. Start the script. It cycles through three phases:
   - **Combust**: Monitors `Combustion`; once active ratios fall below the thresholds it triggers `Activate`.
   - **Exhaust**: When furnace pressure is non-zero and `MaxExhaustPressure` is exceeded, turns on the exhaust pump until pressure drops or the chamber empties.
   - **Fill**: If the furnace is empty or below `FuelFillPressure`, runs the fuel pump (setting 10) until full, then re-ignites.
4. The pumps remain off when their phase completes; the loop repeats.

## Notes
- The ignition check also waits until both hydrogen and oxygen ratios meet combustion minimums; adjust `H2CombustRatio`/`O2CombustRatio` for different fuel mixes.
- `FuelFillPressure` and pump settings assume standard volume pumps; retune for industrial pumps.
- Consider placing an active vent on the exhaust line if pressure frequently hits the cap.

## Status
Functional
