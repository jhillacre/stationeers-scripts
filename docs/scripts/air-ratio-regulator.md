# Air Ratio Regulator

[air-ratio-regulator.ic10](../../air-ratio-regulator.ic10)

## Purpose
Automates an atmospheric filter, only running it when the intake mix is short on oxygen and exhaust pressure remains safe.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Atmospheric Filter |     1 | Yes | Separates the target gas from the mixed intake. |
| Gas Sensor (intake) |     1 | Yes | Reports intake pressure and oxygen ratio. |
| Gas Sensor (output) |     1 | Yes | Monitors filtered output pressure. |
| Alarm |     1 | Optional | Warns when the filter output is over-pressured. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Atmospheric filter | Toggles the filter on or off. |
| `d1` | Intake sensor | Provides intake pressure and oxygen ratio. |
| `d2` | Output sensor | Provides filtered-output pressure. |
| `d3` | Alarm | Sounds when output pressure exceeds the safe limit. |

## Usage
1. Connect the intake gas sensor to the filter’s feed line and wire it to `d1`.
2. Place the output sensor on the filtered-gas line and wire it to `d2`.
3. Connect the filter data port to `d0`; optionally wire an alarm to `d3`.
4. Adjust `DesiredRatio`, `FudgeFactor`, `MinIntakePressure`, and `MaxOutputPressure` to suit your targets.
5. Load and run the script. It enables the filter when intake oxygen is below `(DesiredRatio + FudgeFactor)` and disables it if the intake pressure drops too low or the output pressure exceeds the maximum.

## Notes
- Update the ratio register read (`RatioOxygen`) to match whichever gas the filter should isolate.
- Increase `FudgeFactor` if the intake mix fluctuates and you want the filter to stay on longer per cycle.
- The alarm toggles while over-pressure persists; remove the device if audible alerts are unwanted.

## Status
Functional
