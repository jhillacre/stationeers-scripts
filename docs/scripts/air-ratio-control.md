# Air Ratio Control

[air-ratio-control.ic10](../../air-ratio-control.ic10)

## Purpose
Keeps a room near target gas ratios and pressure by modulating intake pumps and an exhaust bank.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Pump (CO₂ intake) |     1 | Yes | Injects carbon dioxide when below the target ratio. |
| Pump (Nitrogen intake) |     1 | Yes | Supplies nitrogen. |
| Pump (Oxygen intake) |     1 | Yes | Supplies oxygen. |
| Pump (Exhaust) |     1 | Yes | Vents excess pressure. |
| Active Vent |     1 | Optional | Provides faster exhaust when pressure climbs above the cap. |
| Gas Sensor |     1 | Optional | Fallback telemetry if no pipe analyzer is wired. |
| Pipe Analyzer |     1 | Optional | Primary telemetry source for the room mix. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | CO₂ intake pump | Adjusts carbon dioxide flow into the room. |
| `d1` | Nitrogen intake pump | Adjusts nitrogen flow into the room. |
| `d2` | Oxygen intake pump | Adjusts oxygen flow into the room. |
| `d3` | Exhaust pump | Dumps atmosphere when ratios or pressure exceed targets. |
| `d4` | Active vent | Optional high-volume exhaust when pressure is too high. |
| `d5` | Pipe analyzer | Reports current ratios and pressure (preferred). |

## Stack
- Stack entries 1–4 store the previous error for each PD controller so derivative terms remain continuous between cycles.

## Batch
- When no analyzer is connected, the script queries the first registered `StructureGasSensor` on the network for telemetry.

## Usage
1. Wire the three intake pumps to their respective gas sources and connect their data ports to `d0`–`d2`.
2. Attach the exhaust pump (and optional active vent) to the room’s outlet path and wire them to `d3` and `d4`.
3. Preferably mount a pipe analyzer on the room’s piping and connect it to `d5`; otherwise place a gas sensor on the network.
4. Load and run the script; it drives each pump toward the target ratios (1% CO₂, 69% N₂, 30% O₂) while maintaining pressure between 101–149 kPa.

## Notes
- Tune `TARGET*` constants to match your desired atmosphere; keep them normalized to a sum of 1.0.
- Adjust the proportional (`10`) and derivative (`2`) gains inside `pumpSettingPD` if the system oscillates.
- The exhaust active vent only engages above the high-pressure threshold; omit the device if not needed.

## Status
Functional
