# Tank Filler Personal Controller

[tank-filler-personal-controller.ic10](../../tank-filler-personal-controller.ic10)

## Purpose
Automatically fills portable tanks or smart canisters from a storage tank, scaling pump output to avoid over-pressurizing the portable container.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Volume Pump | 1 | Yes | Moves gas from the storage tank into the portable tank. |
| Storage Tank | 1 | Yes | Provides the gas source being dispensed. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Volume pump | Controls pump output toward the portable tank. |
| `d1` | Storage | Provides access to the portable tank slot, pressure, and prefab hash. |
## Usage
1. Place the portable tank or canister into the storage tank’s slot.
2. Wire the volume pump to `d0` and the storage tank to `d1`, confirming the pump pushes toward the portable tank.
3. Start the script. Each loop it:
   - Waits until the storage slot is occupied.
   - Verifies the item is a smart canister or standard tank (by prefab hash).
   - Reads the portable container’s pressure and calculates a pump setting based on the target capacity (`18,000,000 Pa (18 MPa)` for smart canisters, `9,000,000 Pa (9 MPa)` for portable tanks).
   - Adjusts the pump setting between 1 and `MAXPUMP` (default 20) as the tank fills, then shuts off when the target pressure is reached.

## Notes
- Update the prefab hashes if you add new canister types
- Target pressures are expressed in pascals; `18,000,000 Pa` ≈ `18 MPa` for smart canisters, `9,000,000 Pa` ≈ `9 MPa` for standard tanks.
- `MAXPUMP` scales the maximum pump speed; reduce it for finer control when the tank is nearly full.
- The script leaves the pump off whenever the slot is empty or the item type is unsupported.
- Note: portable tank slot telemetry reports pressure in pascals (Pa), which is why the script compares against Pa constants instead of the kilometre-scaled values used by analyzers.

## Status
Functional
