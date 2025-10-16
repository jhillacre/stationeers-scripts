# Gas Fuel Generator Controller

[gas-fuel-generator-controller.ic10](../../gas-fuel-generator-controller.ic10)

## Purpose
Keeps a gas-fueled generator on standby whenever base batteries dip below the configured threshold, managing fuel and coolant regulators via PID loops while venting exhaust.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Gas Fuel Generator | 1 | Yes | Backup generator whose `On` state is controlled. |
| Gas Sensor | 1 | Yes | Monitors generator exhaust temperature for PID loops. |
| Pressure Regulator (fuel) | 1 | Yes | Heats the generator by supplying hot gas. |
| Pressure Regulator (coolant) | 1 | Yes | Cools the generator toward ambient when idle. |
| Active Vent (exhaust) | 1 | Yes | Dumps exhaust gases to maintain safe pressure. |
| Logic Switch | N | Optional | Acts as a manual lockout; closed switches suppress generation. |
| Active Vents (intake/exhaust) | N | Optional | Script pre-configures vents named `AV Intake` / `AV Exhaust`. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Gas fuel generator | Exposes telemetry and accepts the `On` control. |
| `d1` | Gas sensor | Provides exhaust temperature for PID loops. |
| `d2` | Fuel pressure regulator | Pushes heating gas toward the generator. |
| `d3` | Coolant pressure regulator | Pushes cooling gas toward the generator. |
| `d4` | Exhaust active vent | Relieves exhaust pressure when the chamber is charged. |
| `d5` | Lockout switch | Manual interlock; when closed, generation is disabled. |

## Batch
- Aggregates all small (`StructureBattery`) and large (`StructureBatteryLarge`) batteries to compute state of charge.
- Checks every logic switch (`StructureLogicSwitch`) for lockout state.

## Usage
1. Wire the generator, gas sensor, fuel and coolant regulators, exhaust vent, and lockout switch to their respective screws.
2. (Optional) Label intake/exhaust active vents `AV Intake` and `AV Exhaust` so the script can configure their modes and pressure targets.
3. Review constants:
   - `LOWBATTERY` / `FULLBATTERY` trigger generation below 10% charge and stop above 90%.
   - `COOLING_TARGET` / `HEATING_TARGET` define idle and operational temperature targets.
   - `PRESSURE_TARGET` (currently unused) can drive coolant pressure if extended.
4. Start the script. Each cycle it:
   - Computes battery charge ratio and lockout status to decide whether backup power is needed.
   - Runs a PID loop on the coolant regulator to hold `room_temp` near `COOLING_TARGET`.
   - If power is required, runs a PID loop on the fuel regulator to push toward `HEATING_TARGET`, respecting a 40 MPa cap.
   - Opens the exhaust vent when furnace pressure is non-zero and closes it once the exhaust sensor drops below `MaxExhaustPressure`.
   - Enables the generator when the heating loop is active and temperature meets target.

## Notes
- PID gains (P=0.1, I=0.01, D=0.1) suit standard regulators; retune for industrial setups.
- `PRESSURE_TARGET` is defined but unused—extend the coolant loop if pressure control is desired.
- Multiple lockout switches act as an AND; open all to allow generation.
- The script assumes the same network for all batteries; isolate UPS banks if they shouldn’t trigger generation.

## Status
Work in Progress
