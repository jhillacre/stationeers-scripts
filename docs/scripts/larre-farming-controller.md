# LArRE Farming Controller

[larre-farming-controller.ic10](../../larre-farming-controller.ic10)

## Purpose
Automates a Linear Articulated Rail Entity (LArRE) arm to harvest, replant, and stage produce from hydroponic trays while managing grow lights.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| LArRE Arm | 1 | Yes | Drives the articulated rail arm that picks and places crops. |
| Hydroponic Device | 1 | Yes | Exposes tray `Seeding` state for the current rail position. |
| Conveyor or Smart Bin (Bin 1) | 1 | Yes | Receives harvest from the first half of the farm. |
| Conveyor or Smart Bin (Bin 2) | 1 | Yes | Receives harvest from the second half of the farm. |
| Daylight Sensor | 1 | Yes | Provides arm heading to infer daylight for grow-light control. |
| Grow Light | 1 | Optional | Switched on/off based on daylight sensor readings. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | LArRE arm | Controls arm `Setting` and `Activate` commands. |
| `d1` | Hydroponic device | Provides tray seeding state. |
| `d2` | Bin 1 | Receives harvest from early trays. |
| `d3` | Bin 2 | Receives harvest from late trays. |
| `d4` | Daylight sensor | Supplies `Horizontal` heading for grow-light logic. |
| `d5` | Grow light | Toggled based on daylight sensor angle. |
## Batch
- Relies on the arm’s internal tray index and quantity checks.

## Usage
1. Configure `MinTrayIndex`, `MaxTrayIndex`, `DeviceIndex`, `Bin1Index`, and `Bin2Index` to match the LArRE rail layout; ensure trays and bin slots follow the expected numbering.
2. Connect the arm, hydroponic device, bins, daylight sensor, and optional grow light to the designated screws.
3. Start the script. It cycles through the trays, executing the following phases:
   - **MOVE**: Position the arm at the current tray and determine whether it is a tray or staging bin.
   - **WAIT**: Monitor the hydroponic tray’s `Seeding` value to detect ripe produce.
   - **PICK FIRST / PLANT PREV**: Harvest the first items, plant seeds from the previous tray, and check for remaining produce.
   - **PICK REMAINING / PLACE**: Continue harvesting and deliver produce to Bin 1 or Bin 2 based on the tray index (`BinTravelSplit`).
   - **DONE**: Advance to the next tray, wrapping around at `MaxTrayIndex`.
4. The grow light toggles when the daylight sensor angle leaves the configured window (`LightOn`/`LightOff`).

## Notes
- `BinTravelSplit` determines which trays use Bin 1 vs Bin 2; adjust for your layout.
- The script assumes trays provide seeds for the next planting cycle; ensure bins maintain sufficient seeds.
- Add seeding or hydration logic around the hydroponic device if needed—this controller focuses on pick/place.

## Status
Work in Progress
