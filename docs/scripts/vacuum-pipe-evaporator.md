# Vacuum Pipe Evaporator Controller

[vacuum-pipe-evaporator.ic10](../../vacuum-pipe-evaporator.ic10)

## Purpose
Cycles a water purifier feed pipe between partial fills and vacuum purges so the liquid regulator continuously evaporates impurities into a vacuum manifold.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Pipe Analyzer (evaporator manifold) | 1 | Yes | Measures liquid volume, pipe volume, and pressure inside the evaporator manifold. |
| Liquid Pipe Regulator | 1 | Yes | Meters incoming dirty water to the evaporator manifold. |
| Gas Pressure Regulator (vacuum purge) | 1 | Yes | Bleeds the evaporator manifold down to vacuum between fill cycles. |
| Logic Switch | 1 | Optional | Provides a manual kill switch that forces regulators off. |

## Device Labeling
| Device Type | Label | Purpose |
|-------------|-------|---------|
| Pipe Analyzer | `EvapAnalyzer` | Keeps the analyzer on `d0`. |
| Liquid Pipe Regulator | `FeedReg` | Ensures the fill regulator binds to `d1`. |
| Gas Pressure Regulator | `PurgeReg` | Keeps the purge regulator on `d2`. |
| Logic Switch | `EvapKill` | Optional; binds to `d3` for safe-off control. |

## Screws
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Pipe analyzer | Supplies pipe volume, liquid volume, and manifold pressure. |
| `d1` | Liquid pipe regulator | Receives the target fill level (liters) and on/off commands. |
| `d2` | Gas pressure regulator | Holds the purge regulator at 0 kPa to maintain vacuum. |
| `d3` | Logic switch (optional) | When open, forces the controller into kill mode. |

## Stack
Not used.

## Batch
Not used.

## Usage
1. Build an evaporator manifold that vents to vacuum through the purge regulator and accepts dirty water through the liquid regulator. Install the analyzer on the same manifold so it reads the evaporator volume.
2. Wire the analyzer, liquid regulator, and purge regulator to `d0`–`d2` respectively. Connect an optional kill switch to `d3` if you want a manual shutdown input. The script binds all devices to the logic network named `M`; adjust the `bdns` calls in the IC10 file if you use a different network.
3. Start the script. The purge regulator is forced on and set to 0 kPa so any gas is immediately drawn to vacuum while the liquid regulator idles.
4. When pipe pressure is at or below `PREFILL_P` (default 10 kPa), the controller enables the liquid regulator and sets its target volume to 40 percent of the pipe volume (`FPM = 400`). Once the analyzer reports that fill percentage or the pressure rises above the threshold, the regulator turns off and the purge cycle resumes.
5. Tune constants as needed:
   - `FPM` controls the fill fraction; increasing it feeds more liquid per cycle.
   - `PREFILL_P` determines how much residual pressure is allowed before refilling.
   - `PURGE_SET` can be raised slightly above zero if you want a small back-pressure rather than hard vacuum.

## Notes
- The controller keeps the purge regulator locked on even if the analyzer or switch go offline, preventing the manifold from overpressurizing.
- Use the optional kill switch during maintenance; it unlocks the liquid regulator and holds both regulators off without disabling the purge safety.
- Pair this script with a condenser or filtration stage that captures the evaporated vapor on the vacuum side.

## Status
Functional
