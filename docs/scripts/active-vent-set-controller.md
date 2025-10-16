# Active Vent Set Controller

[active-vent-set-controller.ic10](../../active-vent-set-controller.ic10)

## Purpose
Coordinates a bank of active vents to clear, exhaust, intake, or shut down based on a shared control register.

## Devices

| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Active Vent |     N | Yes       | Target vents that should receive the chosen mode. |
| Memory / Logic |     1 | Yes | Provides the `Setting` value that encodes the command. |
| Gas Sensor |     1 | Optional  | Samples ambient pressure for intake operations. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Memory or logic register | Selects the command to apply (`0` clear, `1-7` modes). |
| `d1` | Gas sensor | Supplies the exterior pressure when running intake. |

## Batch
- `Active Vent` hash (`-1129453144`) broadcasts `Lock`, `Mode`, `PressureInternal`, `PressureExternal`, and `On` commands to every connected active vent.

## Usage
1. Place the IC housing on the network that links all active vents you want to coordinate.
2. Assign the control memory or logic output to screw `d0`. Optional: assign a gas sensor facing the intake environment to `d1`.
3. Publish a command value:
   - `0` clear
   - `1` / `2` exhaust exterior / interior
   - `3` / `4` intake exterior / interior
   - `5` / `6` off exterior / interior
   - `7` stop every vent
4. The script locks the vents, applies the requested mode, and clears the command after a short delay.

## Notes
- Flip the `RespondToInternal` constant if this vent bank should treat the “internal” variants as the active commands.
- Adjust `CLEARCMDSLEEP` if vents need more time to settle before the command resets.
- All active vents reachable through the housing respond automatically; isolate different groups on separate networks.

## Status
Functional
