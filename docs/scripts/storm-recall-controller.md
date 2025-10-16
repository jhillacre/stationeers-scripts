# Storm Recall Controller

[storm-recall-controller.ic10](../../storm-recall-controller.ic10)

## Purpose
Automates storm response: sounds alarms, flips recall switches, and closes hangar/airlock doors when the weather station issues warnings or storms.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Weather Station | 1 | Yes | Source of storm warnings and event timing. |
| Klaxon | 1 | Optional | Sounds when a warning is issued. |
| Logic Switch (Recall 1–4) | 1–4 | Optional | Recall switches that are toggled for storm prep. |
| Hangar Door / Airlock Gate | N | Optional | Any hangar or airlock doors to close. |
| Logic Transmitter (PlayerSuit) | 1 | Optional | Plays the recall sound. |

## Device Labeling
None.

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Weather station | Provides `Mode` (0 idle, 1 warning, 2 storm) and next weather event time. |
| `d1` | Klaxon | Audible alarm for warnings. |
| `d2`–`d5` | Recall switches | Sequential switches toggled during recall; count down after storms. |

## Stack
Not used.

## Batch
- Configures hangar/airlock doors via device hashes (`StructureAirlockGate`, `StructureMediumHangerDoor`, `StructureLargeHangerDoor`).
- Sets klaxon defaults and logic transmitter volume.

## Usage
1. Wire the weather station to `d0`, the klaxon to `d1`, and up to four recall switches to `d2`–`d5`.
2. Ensure hangar doors and airlock gates are on the same network so hash-based commands reach them.
3. Optionally connect a logic transmitter tuned to the player suit to play the recall alert.
4. Start the script. When the weather station reports a warning, the klaxon activates and the mode changes to `MODE_READY`; if a storm hits, recall switches toggle, doors close, and the system stays latched until the storm passes and the event timer exceeds thresholds.

## Notes
- `RECALL_TIME` (300 s) determines how long after a warning the recall switches should engage; adjust for your base layout.
- `CLOSE_TIME` (20 s) specifies how long before the storm the doors should close.
- Requires the day-weather-state mirror (or equivalent) to provide accurate next-weather-event timing.

## Status
Work in Progress
