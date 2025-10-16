# Room Lights Controller

[room-lights.ic10](../../room-lights.ic10)

## Purpose
Keeps interior lighting on whenever the occupancy sensor reports people nearby or the daylight sensor reports night-time conditions.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Occupancy Sensor | 1 | Yes | Counts nearby players to decide when the space is occupied. |
| Daylight Sensor | 1 | Yes | Provides a daylight flag so lights stay on through the night. |
| Structure Light (Long Wide) | Any | Yes | Target fixtures switched in unison by the batch hash. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Occupancy sensor | Reads `Quantity` to determine if anyone is present. |
| `d1` | Daylight sensor | Reads `Activate`; becomes zero at night to trigger lighting. |
## Batch
- `LightHash` defaults to `HASH("StructureLightLongWide")` and turns every matching fixture on or off together. Change the hash if you prefer a different light variant or a named device.

## Usage
1. Wire the occupancy sensor to `d0` and the daylight sensor to `d1`, mounting the daylight sensor with sky exposure and the occupancy sensor covering the room.
2. Ensure the lights you want to control match the `LightHash` constant (edit the script if you use a different fixture or label).
3. Upload the script and start it. The lights turn on whenever the room is occupied or the daylight sensor reports night, and turn off only when the area is empty and daylight is available.

## Notes
- The batch write toggles every light sharing the hash; separate areas should use distinct fixtures or edit the constant.
- If outdoor daylight fluctuates during storms, consider feeding a weather mirror signal instead of the raw daylight sensor.

## Status
Functional
