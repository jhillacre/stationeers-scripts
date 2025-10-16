# Room Heater via Exchange

[room-heater-via-exchange.ic10](../../room-heater-via-exchange.ic10)

## Purpose
Restores a cold room to 21 C by pulling heat from a warmed exchanger buffer whenever room temperature dips below 20 C, then purging the buffer so it can recharge.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Volume Pump (warm intake) | 1 | Yes | Pushes warmed gas from the exchanger buffer toward the room. |
| Volume Pump (warm purge) | 1 | Yes | Vents the exchanger buffer after each heating cycle. |
| Gas Sensor (room) | 1 | Yes | Tracks the room temperature the script regulates. |
| Pipe Analyzer (exchanger buffer) | 1 | Yes | Guards buffer pressure and reports when the buffer is empty. |

## Device Labeling
| Device Type | Label | Purpose |
|-------------|-------|---------|
| Volume Pump | `WarmPumpIn` | Ensure the intake pump binds to `d1`. |
| Volume Pump | `WarmPumpOut` | Locks the purge pump to `d2`. |
| Gas Sensor | `RoomSensor` | Mount inside the room; becomes `d0`. |
| Pipe Analyzer | `WarmBuffer` | Attach to the warmed exchanger manifold; becomes `d3`. |

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Room sensor | Monitors room temperature/pressure to decide when to run. |
| `d1` | Intake pump | Runs while heating to deliver warm gas to the room. |
| `d2` | Purge pump | Runs outside the heating window to empty the buffer. |
| `d3` | Buffer analyzer | Keeps the exchanger side under 5 MPa and signals when it is evacuated. |

## Stack
Not used.

## Batch
Not used.

## Usage
1. Connect the intake pump so it drives gas from the warmed exchanger buffer into the room and the purge pump so it evacuates the buffer back toward heaters or waste.
2. Place the `RoomSensor` gas sensor inside the conditioned space and the `WarmBuffer` pipe analyzer on the exchanger side. Power both sensors; the script toggles them on during `init`.
3. Attach devices to the logic reader in the `d0`–`d3` order shown above (use labels to keep the order deterministic on restart).
4. Tune the constants at the top of the IC10 script if needed: `TARGET` (21 C stop point), `TOOCOOL` (20 C trigger), and `MAXWARMPRESSURE` (5 MPa buffer ceiling). `SAMPLEPRESSURE` is a reserved constant for later sampling logic.
5. Start the script. It keeps the purge pump running until the buffer is empty, then idles until the room falls below `TOOCOOL`. When triggered it enables the intake pump until the room reaches `TARGET` or the buffer hits `MAXWARMPRESSURE`, then returns to purge mode.

## Notes
- Pair the buffer with radiators or heaters so it can recharge while the purge pump is active; the script assumes heat exchange happens outside IC10.
- If the room temperature oscillates, adjust the `TOOCOOL`/`TARGET` band or lower the intake pump `Setting` from 1 to match your manifold volume.
- Adjust the pressure ceiling for small manifolds to avoid over-pressurizing the exchanger loop.

## Status
Functional
