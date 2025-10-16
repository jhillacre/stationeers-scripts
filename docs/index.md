# Stationeers IC10 Scripts

Reference documentation for the IC10 scripts in this repository. Each entry links to a stub that follows the shared template so details can be filled in over time.

### Naming

Scripts are grouped into the following categories:

* *Controllers* manage device behavior (directly or via feedback).
* *Set Controllers* broadcast a single command to many devices.
* *Arrays* loop through multiple devices, each acting independently.
* *Mirrors* copy values.
* *Utilities* and *Logistics* handle higher-level coordination or resource flow.

See [Categories](#categories) for more details.

### Status Scale

| Label            | Meaning                                     |
|------------------|---------------------------------------------|
| Experimental     | Proof of concept; may not work in all cases |
| Work in Progress | Functional but incomplete                   |
| Functional       | Works reliably for its intended setup       |
| Stable           | Tested and dependable                       |
| Mature           | Field-tested, minimal issues                |
| Retired          | Superseded or obsolete                      |
| Stub             | Documentation placeholder awaiting updates  |

## Script Catalog

| Script | Status | Summary |
|--------|--------|---------|
| [Active Vent Set Controller](scripts/active-vent-set-controller.md) | Functional | Coordinates active vents via a shared control memory. |
| [Air Conditioner Controller](scripts/air-conditioner-controller.md) | Functional | PID loop compensates the air conditioner’s control curve. |
| [Gas Mixer Air Regulator](scripts/gas-mixer-air-regulator.md) | Functional | Balances nitrogen and oxygen flow with paired supply pumps. |
| [Air Ratio Control](scripts/air-ratio-control.md) | Functional | PD controller that trims room gas ratios and pressure with intake/exhaust pumps. |
| [Air Ratio Regulator](scripts/air-ratio-regulator.md) | Functional | Controls an atmospheric filter based on intake mix and output pressure. |
| [Airgate Airlock](scripts/airgate-airlock.md) | Functional | Coordinates door and vent banks for high-throughput airlock cycling. |
| [Airgate Set Controller](scripts/airgate-set-controller.md) | Functional | Memory-driven broadcast to open/close every airgate in a bank. |
| [Power Analyzer Mirror](scripts/power-analyzer-mirror.md) | Functional | Mirrors cable analyzer metrics into memory registers for reuse. |
| [Arc Furnace Array](scripts/arc-furnace-array.md) | Functional | Turns on any furnace with ore queued while honoring a lockout switch. |
| [Automated Filter](scripts/automated-filter.md) | Functional | Manages an atmospheric filter with cartridge checks, overflow alarms, and venting. |
| [Centrifuge Set Controller](scripts/centrifuge-set-controller.md) | Stable | Dumps centrifuges automatically once any unit fills. |
| [Double Axis Solar Tracking](scripts/double-axis-solar.md) | Stable | Auto-calibrates and tracks the sun with a daylight sensor. |
| [Extendable Radiator Heater](scripts/extendable-radiator-heater.md) | Functional | Steers extendable radiators with daylight sensor angles for solar heating/cooling. |
| [Nitrogen Condensation Regulator](scripts/nitrogen-condensation-regulator.md) | Functional | Balances a condensation loop against a reserve manifold with PD pump control. |
| [Gas Mixer Fuel Regulator](scripts/gas-mixer-fuel-regulator.md) | Functional | Blends hydrogen and oxygen feeds into rocket fuel with temperature-aware pump control. |
| [Gas Burner](scripts/gas-burner.md) | Functional | Cycles a hydrogen furnace through fill, ignite, and exhaust phases with ratio checks. |
| [Gas-Fuel Generator Controller](scripts/gas-fuel-generator-controller.md) | Work in Progress | Keeps a gas-fueled generator on standby with PID fuel/coolant regulators. |
| [Hot/Cold Valve](scripts/hot-cold-valve.md) | Work in Progress | Pulses hot/cold valves based on ambient temperature from a gas sensor hash. |
| [LArRE Farming Controller](scripts/larre-farming-controller.md) | Work in Progress | Automates a hydroponic rail arm for picking, planting, and bin staging. |
| [Day Weather State Mirror](scripts/day-weather-state-mirror.md) | Functional | Mirrors daylight and storm telemetry into logic memories for other controllers. |
| [Onboard Filtration](scripts/onboard-filtration.md) | Work in Progress | Onboard atmospheric filter script that validates cartridges and auto-stops at pressure. |
| [Ore Stacker](scripts/ore-stacker.md) | Retired | Demonstrates digital flip-flop sorters for ore, but items leak under load. |
| [Lights Outdoor Controller](scripts/lights-outdoor-controller.md) | Functional | Turns exterior lights on at night or during storms using mirrored weather signals. |
| [Tank Filler Personal Controller](scripts/tank-filler-personal-controller.md) | Functional | Fills portable tanks/canisters from storage while throttling pump speed. |
| [Power Duplication Bug Controller](scripts/power-duplication-bug.md) | Experimental | Reproduces the transformer duplication exploit to charge batteries from a deficit. |
| [Printer Logistics (Customized)](scripts/printer-logistics.md) | Mature | Requests ingots for a selected recipe and stops at the stacker limit. |
| [Storm Recall Controller](scripts/storm-recall-controller.md) | Work in Progress | Automates storm recalls: alarms, switches, and door closures from weather events. |
| [Room Cooler via Exchange](scripts/room-cooler-via-exchange.md) | Stub | Documentation stub. |
| [Room Heater via Exchange](scripts/room-heater-via-exchange.md) | Stub | Documentation stub. |
| [Room Lights](scripts/room-lights.md) | Stub | Documentation stub. |
| [Temp-Gated Pressure Regulator](scripts/temp-gated-pressure-regulator.md) | Stub | Documentation stub. |
| [Vacuum Pipe Evaporator](scripts/vacuum-pipe-evaporator.md) | Stub | Documentation stub. |
| [Water Temperature Control](scripts/water-temp-control.md) | Stub | Documentation stub. |

## Categories

| Term                    | Scope                                                                                                   | Behavior                                                 | Typical Logic                                      | Example                                                                |
| ----------------------- | ------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- | -------------------------------------------------- | ---------------------------------------------------------------------- |
| **Controller**          | Executes automation logic for one or more devices. May read sensors, make decisions, or adjust outputs. | Can be discrete (on/off logic) or continuous (feedback). | Threshold checks, timers, feedback loops (PID/PD). | `Air Conditioner Controller`, `Automated Filter`, `Printer Logistics`. |
| **Set Controller**      | Broadcasts the same command to a group of devices.                                                      | Fan-out control from a single memory or logic signal.    | Batch writes via device hash.                      | `Active Vent Set Controller`, `Airgate Set Controller`.                |
| **Array**               | Runs logic for each device independently.                                                               | Device-level autonomy under shared rules.                | Iteration over wired screws or stack entries.      | `Centrifuge Array`, `Arc Furnace Array`.                               |
| **Mirror**              | Copies or rebroadcasts data between devices or networks.                                                | No control logic; just reflection.                       | Read → Write pairs.                                | `Power Analyzer Mirror`.                                               |
| **Logistics / Utility** | Supports higher-level automation or player QoL.                                                         | May chain other scripts or automate workflows.           | Resource checks, triggers, coordination.           | `Printer Logistics`, `Outside Lights`.                                 |

## Template

Reuse the shared template below when filling in stub details.

```markdown
# Script Name
[script-name.ic10](../../script-name.ic10)

## Purpose
*Purpose of the script, ideally one sentence.*

## Devices *optional*
*List of devices used by the script.*
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| DeviceType  |     # | Yes/No    | Describe the role this device plays. |

## Device Labeling *optional*
*Any device naming required by the script.*
| Device Type | Label | Purpose |
|-------------|-------|---------|
| DeviceType  | Label | Explain how the label is used. |

## Screws *optional*
*List of screws used by the script, and their purpose.*
| Register | Device | Purpose |
|---------:|--------|---------|
| d0 | DeviceType | What this screw controls. |

## Stack *optional*
*Describe how the device stack is used, if applicable.*
- Example: stack index 0 holds the active recipe hash.

## Batch *optional*
*Outline any batch operations that act on groups of devices.*
- Example: targets every device that matches a specific item hash.

## Usage
*Instructions on how to deploy the script.*

## Notes *optional*
- Additional considerations or tuning tips.

## Status
Experimental / Work in Progress / Functional / Stable / Mature / Retired / Stub

## Credit *optional*
*If not the original author, credit the source of the idea or code.*
- Example: Inspired by [Name or Link]() on [Topic or Link]().
```
