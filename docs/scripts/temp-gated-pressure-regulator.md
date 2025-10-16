# Temp-Gated Pressure Regulator Controller

[temp-gated-pressure-regulator.ic10](../../temp-gated-pressure-regulator.ic10)

## Purpose
Feeds a gas burner (or similar consumer) with a steady ~350 kPa fuel supply while only opening the transfer pump when source and target temperatures fall within a safe band.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Volume Pump | 1 | Yes | Moves gas from the source manifold toward the target manifold. |
| Pipe Analyzer (target) | 1 | Yes | Monitors target pressure and temperature for gating the pump. |
| Pipe Analyzer (source) | 1 | Yes | Provides source pressure/temperature feedback to throttle the pump. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Volume pump | Receives the PID-controlled `Setting` and on/off state. |
| `d1` | Target analyzer | Supplies target pressure/temperature for gating and PID error. |
| `d2` | Source analyzer | Supplies source pressure/temperature for the gating checks. |
## Usage
1. Pipe the volume pump between the source (d2) storage manifold and the low-pressure target manifold that feeds your burner or consumer, ensuring flow from source to target.
2. Mount the target analyzer on the destination manifold and the source analyzer on the supply manifold, then wire each device to the designated screws (label them if you need deterministic ordering after reboots). The script automatically sets all three devices to the `main` logic network during `init`; edit the `bdns` calls if you prefer another network name.
3. Upload the script and start it. The controller idles the pump if the target already meets the `PressureLimit` (default 350 kPa) or if the temperature band checks suggest the manifolds are too far apart in temperature.
4. Adjust the constants in the script as needed:
   - `PressureLimit` caps the target pressure.
   - `TargetTempLow`/`TargetTempHigh` define the hysteresis window when comparing source and target temperatures.
   - `PGain`, `IGain`, and `DGain` tune the pump speed response.
5. Once running, the PID loop increments the pump `Setting` while temperatures align, keeping the target manifold close to the pressure limit without rapid cycling—ideal for burners that prefer a gentle, continuous feed.

## Notes
- The dual temperature checks add hysteresis so the pump only runs when the source is meaningfully hotter (or cooler) than the target, reducing unwanted mixing that can upset burner ratios.
- If the pump oscillates or the `Setting` drifts too high, scale down the gain constants or add manual clamping around `PreviousSetting`.
- Increase `PressureLimit` only when the target manifold and downstream devices (burners, regulators) can safely hold the higher pressure.

## Status
Functional
