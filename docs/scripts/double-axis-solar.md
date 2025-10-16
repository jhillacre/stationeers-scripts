# Double Axis Solar

[double-axis-solar.ic10](../../double-axis-solar.ic10)

## Purpose
Uses a daylight sensor to calibrate azimuth and elevation, then tracks the sun throughout the day.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Daylight Sensor |     1 | Yes | Provides power readings for calibration. |
| Solar Panel |     N | Yes | Panels that will be steered by the controller. |
| IC Housing + IC10 chip |     1 | Yes | Hosts and powers the controller. |
| Area Power Controller |     1 | Optional | Keeps the housing powered overnight. |

## Usage
1. Place the daylight sensor, solar panels, and IC housing on the same data network.
2. Optionally feed the housing with a small backup battery so it survives the night.
3. Load and start the script; it cycles through quadrants every 15 seconds until it finds the highest power output, then records the optimal overnight parking position.
4. Each dawn it repositions the panels to track the sun, returning them to the stored sunrise heading at sunset.

## Notes
- Works regardless of sensor or panel orientation—the configuration routine works out offsets automatically.
- Particularly helpful on bodies like Europa where sunrise starts behind a planetary body.

## Status
Stable
