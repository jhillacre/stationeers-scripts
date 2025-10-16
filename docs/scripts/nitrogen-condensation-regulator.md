# Nitrogen Condensation Regulator

[nitrogen-condensation-regulator.ic10](../../nitrogen-condensation-regulator.ic10)

## Purpose
Keeps a nitrogen condensation loop fed from a reserve manifold while avoiding liquid overpressure and respecting a manual lockout.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Pipe Analyzer (cooling loop) | 1 | Yes | Measures temperature, pressure, moles, and liquid volume in the condensation loop. |
| Pipe Analyzer (reserve) | 1 | Yes | Reports conditions in the storage manifold. |
| Volume Pump | 1 | Yes | Moves nitrogen between the reserve and cooling loop. |
| Logic Switch | N | Optional | Acts as a safety interlock; any closed switch forces the loop to drain. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Cooling-loop pipe analyzer | Supplies loop temperature, pressure, moles, and liquid volume. |
| `d1` | Reserve pipe analyzer | Supplies reserve temperature, pressure, and moles. |
| `d2` | Volume pump | Bidirectional flow control between reserve and loop. |
## Batch
- Polls every `StructureLogicSwitch` on the network; if any switch is closed the controller enters the drain routine.
- Uses nitrogen material constants to compute saturation pressure via the Clausius–Clapeyron relation.

## Usage
1. Connect the reserve manifold, volume pump, and condensation loop so that pump mode `0` feeds the loop (mode `1` drains back toward the reserve).
2. Attach pipe analyzers to both networks and wire them to `d0` and `d1`. Wire the pump to `d2`.
3. Optional: add one or more logic switches to the data network as safety lockouts (closed = drain).
4. Load the script. When lockouts are open the controller:
   - Calculates the target saturation pressure for both reserve and loop.
   - Computes the combined pressure that would result from transferring all reserve gas.
   - Adjusts the pump with a PD controller to raise or lower loop pressure toward the chosen limit (`NMAXLIQUIDPRESSURE` or the current saturation pressure).
5. If the loop gets too cold, the reserve cannot condense further, or liquid stress exceeds `MAXSTRESSFROMLIQUID`, the pump reverses to drain until safe.

## Notes
- Tune `NMINCONDENSATIONTEMP`, `NMINCONDENSATIONPRESSURE`, and `MAXSTRESSFROMLIQUID` to match your target condenser design.
- The controller assumes the reserve stays gaseous; set `NMAXLIQUIDPRESSURE` below the condensation threshold of any downstream tanks.
- With multiple logic switches the script requires *all* to be open before filling resumes.
- The PD gains (`500` / `100`) are sized for standard volume pumps; adjust if you see oscillation.

## Status
Functional
