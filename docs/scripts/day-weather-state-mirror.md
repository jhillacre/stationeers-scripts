# Day Weather State Mirror

[day-weather-state-mirror.ic10](../../day-weather-state-mirror.ic10)

## Purpose
Mirrors day/night and storm status from weather instrumentation into logic memories so other controllers can react without polling the sensors directly.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Weather Station | 1 | Yes | Provides current weather mode and next event time. |
| Daylight Sensor | 1 | Yes | Supplies day/night activation status. |
| Memory (is day) | 1 | Yes | Receives day/night flag. |
| Memory (is storm) | 1 | Yes | Receives storm/clear flag. |
| Memory (storm time) | 1 | Yes | Stores time until the next weather event. |

## Device Labeling
None.

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Weather station | Source of `Mode` (storm flag) and `NextWeatherEventTime`. |
| `d1` | Daylight sensor | Supplies `Activate` (day/night) flag. |
| `d2` | Memory | Stores day/night flag (`Setting`). |
| `d3` | Memory | Stores storm mode (`Setting`). |
| `d4` | Memory | Stores next weather event time (`Setting`). |

## Stack
Not used.

## Batch
Not used; each device is accessed directly.

## Usage
1. Wire the weather station to `d0`, the daylight sensor to `d1`, and three logic memories to `d2`–`d4`.
2. Start the script; it updates the memories every tick with the latest weather mode, time to next event, and day/night status.
3. Optionally read the controller housing’s `Setting` register (`db`) for the storm time mirror.

## Notes
- `db` mirrors the `NextWeatherEventTime` for compatibility with existing logic chips.
- Consumers can watch the memories and react immediately instead of polling the sensors directly.
- Ensure only one script writes to each memory to avoid conflicting values.

## Status
Functional
