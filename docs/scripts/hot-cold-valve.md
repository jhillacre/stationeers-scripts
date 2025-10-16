# Hot Cold Valve

[hot-cold-valve.ic10](../../hot-cold-valve.ic10)

## Purpose
Maintains a target room temperature by pulsing hot and cold loop valves based on a shared gas sensor reading.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Volume Pump / Valve (hot loop) | 1 | Yes | Injects hot gas or liquid when the room is below target. |
| Volume Pump / Valve (cold loop) | 1 | Yes | Injects cold gas or liquid when the room is above target. |
| Gas Sensor | 1 | Yes | Measures ambient temperature (read via device hash). |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Hot valve | Pulsed on when the room is colder than `COLDTARGET`. |
| `d1` | Cold valve | Pulsed on when the room is warmer than `HOTTARGET`. |
## Batch
- Reads temperature from the first `StructureGasSensor` hash present on the network; ensure only one ambient sensor is reachable.

## Usage
1. Connect the hot and cold valves to `d0` and `d1`.
2. Place a gas sensor on the same network so the script can read ambient temperature; leave only one `StructureGasSensor` accessible to avoid ambiguity.
3. (Optional) Adjust `HOTTARGET`, `COLDTARGET`, and `WARMTARGET` to define the acceptable temperature window.
4. Run the script; it pulses the appropriate valve for 5 seconds when the room is outside the target band.

## Notes
- `WARMTARGET` is defined but unused; extend the script if you need a mid-band behaviour.
- The 5-second sleeps are coarse; shorten them for tighter control or replace with a PID if needed.
- Ensure the hot and cold loops are isolated so pulsing one does not affect the other’s supply temperature.

## Status
Work in Progress
