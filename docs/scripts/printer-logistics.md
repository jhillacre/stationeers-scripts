# Printer Logistics

[printer-logistics.ic10](../../printer-logistics.ic10)

## Purpose
Requests ingots from a vending machine to feed a selected printer, topping up common materials and stopping when the stacker hits its target.

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Printer (Autolathe, Electronics Printer, etc.) |     1 | Yes | Consumes ingots for production and reports the selected recipe. |
| Stacker |     1 | Yes | Defines the desired output quantity. |
| Sorter |     1 | Yes | Routes vending machine output to the printer. |
| Vending Machine |     1 | Yes | Supplies ingots. |
| Button / Important Button |     1 | Optional | Retries requests when the vending machine was empty. |
| IC Housing + IC10 chip |     1 | Yes | Hosts the controller. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Printer | Reads the active recipe and starts prints. |
| `d1` | Stacker | Reports the target quantity. |
| `d2` | Sorter | Directs ingots toward the printer. |
| `d3` | Vending machine | Fulfills ingot requests. |
| `d4` | Button | Manually re-triggers vending machine requests. |

## Usage
1. Connect the vending machine output to the sorter, feed the printer from the sorter’s secondary output, and route the printer output into the stacker.
2. Wire all devices so the IC housing can reach them.
3. Load the script, set the printer recipe, and dial the desired count on the stacker.
4. Press the button whenever you want to retry vending-machine pulls after an empty response.

The script expects to drive one printer, but multiple printers can share the same vending machine if each has its own controller.

## Notes
- Maintain fuel or power for any auxiliary devices—the script focuses on vending and printing.

## Status
Mature

## Credit
Based on CowsAreEvil’s original design. See “[Stationeers Printer Logistics 3 Full Build](https://www.youtube.com/watch?v=dkuO6sIlScI)” and the workshop release “[Printer Logistics v4](https://steamcommunity.com/sharedfiles/filedetails/?id=2839308009)”.
