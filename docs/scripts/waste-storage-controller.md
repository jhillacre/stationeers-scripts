# Waste Storage Controller

[waste-storage-controller.ic10](../../waste-storage-controller.ic10)

## Purpose
Maintains a waste filtration manifold by cycling intake and exhaust pumps to keep the filter differential strong while keeping the waste store below its pressure limit.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Waste Storage Tank | 1 | Yes | Holds raw waste gas for recirculation and reports tank pressure. |
| Volume Pump (intake) | 1 | Yes | Pushes waste gas from storage into the filtration input manifold. |
| Pipe Analyzer (intake manifold) | 1 | Yes | Measures pressure on the filter input side. |
| Volume Pump (exhaust) | 1 | Yes | Returns filtered exhaust gas back to the waste storage tank. |
| Pipe Analyzer (exhaust manifold) | 1 | Yes | Monitors exhaust manifold pressure to decide when to purge. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Waste storage tank | Provides overall storage pressure. |
| `d1` | Intake volume pump | Controls flow into the filtration manifold. |
| `d2` | Intake manifold analyzer | Supplies manifold pressure for intake decisions. |
| `d3` | Exhaust volume pump | Purges the exhaust manifold back into storage. |
| `d4` | Exhaust manifold analyzer | Supplies exhaust pressure for purge decisions. |

## Batch
Not used.

## Usage
1. Connect the waste storage tank so its analyzer interface is exposed on `d0`.
2. Wire the intake pump (`d1`) between the waste tank and the filtration input manifold; mount an analyzer on the manifold and wire it to `d2`.
3. Wire the exhaust pump (`d3`) from the filter exhaust manifold back to the waste tank; mount an analyzer on the exhaust manifold and wire it to `d4`.
4. Tune the constants in the script (defaults: 40,000 kPa intake manifold ≈ 40 MPa, 5–10 kPa exhaust manifold floor) to match your piping and filter mix.
5. Start the controller. It will:
   - Run the intake pump whenever stored waste is available and the manifold is below target.
   - Fill the intake manifold until it reaches the operating pressure.
   - Pause intake when storage is full, the manifold exceeds the setpoint, or the exhaust side backs up.
   - Purge the exhaust manifold whenever its pressure rises above the idle threshold, even if storage is near capacity.

## Notes
- Additional logic can gate the pumps based on filter availability or cartridge status if you mirror that data onto the network.
- Adjust the exhaust purge floor higher if filters struggle to self-prime at very low pressure.
- Keep an eye on waste storage capacity; if the tank is nearly full, consider venting or compressing gas elsewhere before running the controller continuously.
- Pressure safety: in a conflict the controller keeps storage below its cap, even if the exhaust manifold has to absorb the excess.
- The intake can pause at vacuum; once waste pressure returns the script resumes filling the manifold.
- All pressure thresholds in the script are expressed in kilopascals (kPa) to match analyzer and tank telemetry.
- Intake/exhaust pumps respect their configured `Maximum` value, so turbo pumps are supported without retuning `PUMP_MAX`.

## Status
Work in Progress
