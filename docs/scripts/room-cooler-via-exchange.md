# Room Cooler via Exchange

[room-cooler-via-exchange.ic10](../../room-cooler-via-exchange.ic10)

## Purpose
Cycles chilled loop gas into an occupied room whenever the room temperature drifts above 22 C (about 295 K), then purges the exchanger line so it can re-cool between runs.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Volume Pump (cool intake) | 1 | Yes | Pushes chilled gas from the exchanger buffer into the room. |
| Volume Pump (cool purge) | 1 | Yes | Pulls the exchanger buffer back to vacuum after each cooling run. |
| Pipe Analyzer (exchanger buffer) | 1 | Yes | Confirms the buffer starts empty and caps buffer pressure at 5 MPa. |
| Gas Sensor (room) | 1 | Yes | Watches the conditioned room for temperature and pressure. |

## Device Labeling
| Device Type | Label | Purpose |
|-------------|-------|---------|
| Volume Pump | `CoolPumpIn` | Keep devices ordered so `d0` is the intake pump. |
| Volume Pump | `CoolPumpOut` | Ensures the purge pump binds to `d1`. |
| Pipe Analyzer | `CoolBuffer` | Attach to the exchanger/manifold you chill between cycles. |
| Gas Sensor | `RoomSensor` | Mount in the room being cooled; becomes `d3`. |

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Intake pump | Runs while cooling to draw chilled gas toward the room. |
| `d1` | Purge pump | Runs while idle to evacuate the exchanger buffer. |
| `d2` | Buffer analyzer | Provides pressure/temperature feedback for the chilled side. |
| `d3` | Room sensor | Drives the temperature checks that start/stop the cycle. |

## Stack
Not used.

## Batch
Not used.

## Usage
1. Plumb the intake pump from the chilled exchanger buffer toward the room and the purge pump from the buffer back toward your chiller or waste line.
2. Place the `CoolBuffer` pipe analyzer on the exchanger side and the `RoomSensor` gas sensor inside the room you want to cool. Power both sensors; the script toggles their `On` state during init.
3. Link the two pumps and both sensors/analyzers to the logic reader so they appear as `d0`–`d3` in the order shown above (use labels to lock the order if your setup reboots often).
4. Optionally retune the constants near the top of the IC10 file: `TARGET` (21 C), `TOOWARM` (22 C trigger), and `MAXCOOLPRESSURE` (5 MPa buffer cap). `SAMPLEPRESSURE` is reserved for future sampling logic.
5. Start the script. It idles with the purge pump running until the buffer is empty and the room has pressure, then waits until the room exceeds `TOOWARM`. Once triggered it runs the intake pump until the room cools back to `TARGET` or the buffer reaches the pressure limit, then returns to purge.

## Notes
- Keep the exchanger buffer connected to active radiators, freezers, or coolant loops so it can shed heat while the script purges.
- If the buffer never reaches vacuum, drop the purge pump setting below 100 to avoid starving the chiller side.
- Tune `MAXCOOLPRESSURE` to match the volume you assigned to the exchanger; small manifolds may need a lower ceiling.

## Status
Functional
