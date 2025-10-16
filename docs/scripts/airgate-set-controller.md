# Airgate Set Controller

[airgate-set-controller.ic10](../../airgate-set-controller.ic10)

## Purpose
Broadcasts open/close commands to every airgate on the network using a single memory-backed control register.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Airgate |     N | Yes | Doors that react to the shared command register. |
| Memory / Logic |     1 | Yes | Provides the `Setting` value that encodes the desired door state. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Memory or logic register | Receives the encoded door command (`1` open all, `2/3` open side, `4/5` close side, `6` close all). |

## Batch
- `Airgate` hash (`1736080881`) lets the controller issue `Open` toggles to every connected airgate each cycle.

## Usage
1. Place the IC housing on the same data network as all airgates you want to control.
2. Wire the controlling memory or logic output to screw `d0`.
3. Publish command codes (`1`–`6`) to drive the door bank; the script clears the register automatically after each action.
4. Tune `RespondToInternal` if this bank should treat the “internal” variants (`OPENINT`, `CLOSEINT`) as its active commands instead of the external ones.

## Notes
- `CLEARCMDSLEEP` introduces a short delay before the command register resets; increase it if slow airgates need more time.
- Pair one internal-responding controller with another configured for external commands to steer two sides of a shared airlock.

## Status
Functional
