# Extendable Radiator Heater

[extendable-radiator-heater.ic10](../../extendable-radiator-heater.ic10)

## Purpose
Points one or more extendable radiators toward the sun during the day, then parks them at night, effectively turning them into a passive solar heater (or cooler when configured).

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Extendable Radiator | N | Yes | Targets that will be opened, closed, and steered. |
| Daylight Sensor | 1 | Yes | Supplies sun-tracking angles and an “active” flag. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `db` | Host IC housing | Stores the last commanded horizontal angle so other controllers can read it.

## Batch
- Uses the extendable radiator hash (`-566775170`) to broadcast `Open` and `Horizontal` commands to every radiator on the network.
- Reads the daylight sensor (`1076425094`) each tick for activation state and azimuth/elevation angles.

## Usage
1. Place the daylight sensor so it has a clear view of the sun and wire it to the same data network as the radiators.
2. Put every extendable radiator you want to steer on that network; no per-device wiring is required.
3. Set `doCooling` to `0` for solar heating (radiators close at night) or `1` to leave them open for cooling.
4. Load the script. During daylight the radiators open and track the sun without unnecessary wrap-around turns; at night they close (or stay open if cooling) and park at -45°. The housing’s `Setting` register (`db`) mirrors the live angle if you want to broadcast it elsewhere.

## Notes
- The wrap-around logic subtracts 360° when crossing the horizon so the radiators do not spin the long way around between sunrise and sunset.
- If you are cooling, ensure the radiators have a good line of sight to space; otherwise leave `doCooling` at `0` to trap heat.
- Extendable radiators respond slowly—consider increasing the loop delay (currently just `yield`) if you want to throttle network chatter.
- Treat the IC housing’s `Setting` as a broadcast value if other controllers need the current aim; no separate memory device is necessary.

## Status
Functional
