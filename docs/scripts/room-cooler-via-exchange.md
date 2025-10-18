# Cooler-only PID with Safety Box
[cooler-only-pid.ic10](../../cooler-only-pid.ic10)

## Purpose
Closed-loop room cooling using only the cold loop (no heater). A PID holds the room near 21–22 °C while a safety box derates or trips on low loop temp and high pressure. Pump outputs auto-scale to each device’s `Maximum` so Volume and Turbo pumps are interchangeable.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| (Turbo) Volume Pump — **Loop Inlet** | 1 | Yes | Pushes gas **into the cold loop** during cooling. |
| (Turbo) Volume Pump — **Loop Outlet** | 1 | Yes | Pulls gas **out of the cold loop** when idle or on scram. |
| Pipe Analyzer — loop              | 1 | Yes | Reads loop Pressure, Temperature, VolumeOfLiquid for safety/derates. |
| Gas Sensor — room                 | 1 | Yes | Reads room Temperature for the PID target. |
| Switch — kill (normally closed)   | 1 | Yes | Hardware kill; open = scram (locks policy flips to allow purge). |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Loop Inlet Pump  | Moves gas **into** the cooling loop when room temperature rises. |
| `d1` | Loop Outlet Pump | Evacuates gas **from** the loop after cooling or on trip. |
| `d2` | Loop analyzer    | Provides `Pressure`, `Temperature`, `VolumeOfLiquid`. |
| `d3` | Room sensor      | Provides `Temperature` for control error. |
| `d4` | Kill switch      | `Open` triggers scram; devices unlock so purge can run. |

## Usage
1. Connect **d0 (Loop Inlet Pump)** so it pushes gas **into the cold loop** from your supply or room side.  
   Connect **d1 (Loop Outlet Pump)** so it **draws gas out of the loop** toward exhaust, chiller return, or vacuum line.  
   Place **d2 (loop analyzer)** anywhere in the loop plumbing and **d3 (room sensor)** inside the conditioned space.  
   Wire a normally-closed kill switch to **d4** (open = scram).
2. Link devices to the logic chip in the order shown so they appear as `d0…d4`.  
3. Start the script. It **locks devices during normal operation** and **unlocks on scram**, then forces purge and clamps authority on trip conditions (liquid in loop, very low loop temp, or hard over-pressure).  
4. Pumps auto-scale: the script reads each pump’s `Maximum` and maps 0–100 % effort into 0..`Maximum`.  
   You can mix Volume and Turbo pumps freely on each side.

## Notes
- The loop must have a way to shed heat between cooling runs:
  - **Luna:** Standard radiators or space radiators.
  - **Europa / Mars:** Convection radiators or external cooling loops that dump to atmosphere.
  - **Venus / Vulcan:** Radiators are useless — you’ll need **phase-change cooling** (e.g., condensing CO₂, N₂, or H₂) or an **active exchanger** tied to a large-scale HVAC plant.  
    These setups consume power and often rely on refrigerant cycling or cryo storage to move heat from your loop into a controlled cold reservoir.
- Keep the loop isolated from base gases; it should only circulate chilled coolant.
- If the loop can’t reach vacuum after purge, reduce the outlet pump’s setting to avoid starving the cooling source.
- Tune constants (`TMIN`, `TT`, `KP`, etc.) for your fluid and planetary conditions.
- **Targets & bands**: `TT` (294.15 K ≈ 21 °C) with `BAND` deadband; tune `KP/KI/KD` and `ICLAMP` as needed.
- **Soft derates**: Authority is the min of two scales:  
  • Pressure derate above `PSHIGH` (feather over `PSPAN`).  
  • Temperature floor derate above `TMIN` with margin `TMARG` (only if gas present).
- **Hard trips**: Clamp authority to 0 if any liquid is detected, loop temp ≤ `TMIN` (with gas), loop pressure ≥ `PSHARD`, or kill is open.
- **Anti-windup**: On trip, integral and `last` error are zeroed.
- **Purge behavior**: Outlet pump runs harder as authority drops; on scram it goes to full. Inlet is blocked if loop pressure ≤ 0 to avoid sucking vacuum.
- **Interchangeable pumps**: Because outputs are scaled to each device’s `Maximum`, you can mix Turbo/Volume per side independently.

## Status
Functional
