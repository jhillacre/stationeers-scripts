# Air Conditioner Controller

[air-conditioner-controller.ic10](../../air-conditioner-controller.ic10)

## Purpose
Uses a PID loop to counter the air conditioner’s non-linear setpoint so the outlet temperature lands on the desired target.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Air Conditioner |     1 | Yes | Provides temperature feedback and accepts the corrected setting. |

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `db` | Air conditioner | Full control of the air conditioner’s telemetry and setpoint. |

## Usage
1. Install the chip in an IC housing that shares a data network with the target air conditioner.
2. Set the `TARGET` constant (or update the device’s `Setting`) to the temperature you want to hold in kelvin.
3. Power the housing; the controller idles the unit while it is within the `FUDGEK` deadband, then modulates the setting toward the target when the outlet temperature drifts.

The loop stores the previous error on the stack between passes so proportional, integral, and derivative terms blend smoothly.

## Notes
- Adjust `FUDGEK` if you prefer a tighter or wider temperature window before the controller wakes up.
- Works best when the air conditioner is the dominant device in the line; competing heaters can cause oscillation.

## Status
Functional
