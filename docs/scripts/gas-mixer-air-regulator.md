# Gas Mixer Air Regulator

[gas-mixer-air-regulator.ic10](../../gas-mixer-air-regulator.ic10)

## Purpose
Blends nitrogen and oxygen into a target atmosphere using two supply pumps, correcting temperature and ratio on the fly.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Gas Sensor |     3 | Yes | Samples the mixed volume plus the nitrogen and oxygen feed pressures and temperatures. |
| Pump |     2 | Yes | Meters nitrogen and oxygen flow into the mixing volume. |
| Lever / Switch |     1 | Optional | Acts as a manual stop; open disables both pumps. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Mixed-atmosphere gas sensor | Provides pressure and gas ratios for the controlled volume. |
| `d1` | Nitrogen feed sensor | Reports pressure and temperature of the nitrogen supply. |
| `d2` | Oxygen feed sensor | Reports pressure and temperature of the oxygen supply. |
| `d3` | Nitrogen pump | Delivers nitrogen toward the mixed tank. |
| `d4` | Oxygen pump | Delivers oxygen toward the mixed tank. |
| `d5` | Lever or switch | When open, shuts both pumps off; closed allows mixing. |

## Usage
1. Mount the three gas sensors so `d0` reads the destination tank, `d1` the nitrogen source, and `d2` the oxygen source.
2. Plumb `d3` and `d4` to the respective supply pumps feeding the mixed atmosphere.
3. (Optional) Wire a lever or switch to `d5` as a manual lockout.
4. Load and start the script; it drives the pumps until the mixed tank reaches `MAXPRESSURE`, targeting an 80/20 nitrogen/oxygen blend.

The script scales pump output with tank pressure to avoid overshooting and compensates for feed-gas temperature while balancing the ratio.

## Notes
- Adjust `nRATIO` and `O2RATIO` if you want a different final mix; keep them normalized to 1.0.
- Increase `MAXPRESSURE` or `MAXPUMP` when filling larger tanks or using high-capacity pumps.

## Status
Functional

## Credit
Based on CowsAreEvil’s air-mixing controller shown in [Stationeers Advanced Carts & Atmospherics](https://youtu.be/O0VLyV2PX9A?t=3112).
