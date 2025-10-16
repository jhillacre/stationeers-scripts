# Gas Mixer Fuel Regulator

[gas-mixer-fuel-regulator.ic10](../../gas-mixer-fuel-regulator.ic10)

## Purpose
Blends hydrogen and oxygen into fuel inside a storage tank by modulating two volume pumps, compensating for temperature differences and minor contamination.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Gas Sensor (fuel tank) | 1 | Yes | Monitors tank pressure and gas ratios. |
| Gas Sensor (hydrogen supply) | 1 | Yes | Reads hydrogen feed pressure, temperature, and purity. |
| Gas Sensor (oxygen supply) | 1 | Yes | Reads oxygen feed pressure, temperature, and purity. |
| Volume Pump (hydrogen) | 1 | Yes | Pushes hydrogen toward the fuel tank. |
| Volume Pump (oxygen) | 1 | Yes | Pushes oxygen toward the fuel tank. |
| Logic Switch | 1 | Optional | Acts as a manual lockout for both pumps. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Fuel tank sensor | Provides current fuel ratios and pressure. |
| `d1` | Hydrogen sensor | Provides hydrogen supply data. |
| `d2` | Oxygen sensor | Provides oxygen supply data. |
| `d3` | Hydrogen pump | Metered hydrogen flow. |
| `d4` | Oxygen pump | Metered oxygen flow. |
| `d5` | Switch | Enables or disables mixing. |

## Usage
1. Wire the target fuel tank sensor to `d0`, the hydrogen supply sensor to `d1`, and the oxygen supply sensor to `d2`.
2. Connect each supply pump to `d3` (`Hydrogen`) and `d4` (`Oxygen`); wire the optional lockout switch to `d5`.
3. Adjust constants if needed:
   - `H2RATIO` / `O2RATIO` define the desired blend (defaults to 2:1 volatiles-to-oxygen).
   - `MAXPRESSURE` limits the tank pressure before pumping stops.
   - `MAXPUMP` caps the pump setting; `OVERCORRECT` sets how aggressively the controller compensates ratio error.
4. Start the script. When the switch is closed the controller:
   - Normalizes the tank’s gas ratios to discount contaminants.
   - Computes temperature-weighted flow so both feeds contribute proportionally.
   - Scales pump capacity based on tank pressure and drives the pumps until the tank reaches the target ratio or pressure cap.
5. If either supply is impure (ratio below 1) or the switch is open, both pumps shut off.

## Notes
- Ensure the hydrogen and oxygen feeds are isolated; the script expects nearly pure gases and shuts down otherwise.
- Increase `MAXPUMP` if you are using heavy-duty pumps or want faster fills.
- The tank ratio calculation ignores other gases but does not purge them—vent or filter contaminants separately.

## Status
Functional
