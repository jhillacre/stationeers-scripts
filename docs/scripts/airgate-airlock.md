# Airgate Airlock

[airgate-airlock.ic10](../../airgate-airlock.ic10)

## Purpose
Coordinates a multi-door airlock using paired airgate and active-vent controllers to cycle between interior and exterior atmospheres.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Memory (door command) |     1 | Yes | Sends encoded door commands to `airgate-set-controller`. |
| Memory (vent command) |     1 | Yes | Issues vent commands to `active-vent-set-controller`. |
| Gas Sensor (airlock) |     1 | Yes | Measures pressure within the airlock volume. |
| Gas Sensor (internal mirror) |     1 | Yes | Mirrors interior atmosphere for comparison. |
| Gas Sensor (external mirror) |     1 | Yes | Mirrors exterior atmosphere for comparison. |
| Button |     1 | Optional | Triggers airlock cycling on demand. |
| Airgate Bank |     N | External | Doors driven by `airgate-set-controller`. |
| Active Vent Bank |     N | External | Vents managed by `active-vent-set-controller`. |

## Device Labeling
None; control happens via shared command memories.

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Door command memory | Publishes door codes (`OPEN/CLOSE` variants). |
| `d1` | Vent command memory | Publishes vent mode codes. |
| `d2` | Internal sensor mirror | Provides reference metrics for interior atmosphere. |
| `d3` | External sensor mirror | Provides reference metrics for exterior atmosphere. |

## Stack
Not used.

## Batch
- Relies on external batch controllers (`airgate-set-controller`, `active-vent-set-controller`) to fan out door/vent commands.

## Usage
1. Install `airgate-set-controller` and `active-vent-set-controller` on the same data networks as their respective door/vent banks.
2. Feed their command registers from memories wired to this script’s `d0` (doors) and `d1` (vents).
3. Place mirrored internal and external gas sensors where they capture the desired reference atmospheres; wire them independently so they are not caught in the airlock’s batch queries.
4. Mount a gas sensor inside the airlock chamber on the same network as this controller.
5. (Optional) Attach a button to the data network to trigger the airlock cycle.
6. Load and run all three scripts. Pressing the button seals the current side, purges to vacuum, intakes the target side, and finally opens the destination doors with configurable delays.

## Notes
- `updateIsInternalAir` infers which side the airlock is currently open to by comparing temperature and gas ratios.
- Keep `internalSensorMirror` and `externalSensorMirror` isolated from the active vent batch network to avoid issuing commands to unintended devices.
- Adjust `DOORSLEEP` and `VENTSLEEP` to match the response time of your door and vent banks.

## Status
Functional

## Credit
Pairs with `airgate-set-controller.ic10` and `active-vent-set-controller.ic10` for door and vent batching.
