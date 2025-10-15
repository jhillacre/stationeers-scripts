# stationeers-scripts

[Integrated Circuit (IC10)](https://stationeers-wiki.com/IC10) scripts for stationeers. Some assembly required. 

IC10 is a MIPS-like assembly language. In-game computers or laptops with IC Editor Motherboards can load these
scripts into IC10 chips, which can then be placed into IC Housings, which allow access to the network of devices.
Scripts are limited to 128 lines of code, or 4096 bytes of data, whichever comes first. To respect the in-game editor
lines are limited to 52 characters.

## Scripts

- [Centrifuge Array](#centrifuge-array)
- [Double Axis Solar Tracking](#double-axis-solar-tracking)
- [Printer Logistics (Customized)](#printer-logistics-customized)
- [The Attic](#the-attic)

### Centrifuge Array
[centrifuge-array.ic10](./centrifuge-array.ic10)

Purpose: Assuming a steady supply of dirty ore, this script will empty all controlled centrifuges when one is full.

Devices: Centrifuges (Electric), Lever, IC10 Chip, IC Housing

Device Labeling: None

Screws: Lever `d0`

Usage: Place the Centrifuges, Lever, IC10 Chip, and IC Housing. Wire the devices so the IC Housing data port can access the Centrifuges's & Lever's data ports. Load the script into the IC10 Chip. Pull the Lever open to start the script, acting as a lockout. The script will empty all controlled centrifuges when one is full, or the lever is closed.

Status: 5 - Stable

This allows the script to scale without needing to have references to each centrifuge. This is a bit brute force, as
combusion fueled centrifugues work faster, but require much more management. Add more centrifuges to the network to
as needed.

Credit: Alex Bee's video explained deep miners for me. I didn't reuse her code, but the premise is straight from her video here: [Stationeers: Fully Automated Deep Mining Setup on One IC10](https://www.youtube.com/watch?v=E8AswNvx5oE)

### Double Axis Solar Tracking
[double-axis-solar.ic10](./double-axis-solar.ic10)

Purpose: Using a daylight sensor, this script will adjust the azimuth and elevation of a solar panel to track the sun.

Devices: Daylight Sensor, Solar Panels, IC10 Chip, IC Housing

Device Labeling: None

Screws: None

Usage: Place the Daylight Sensor, Solar Panels, IC10 Chip, and IC Housing. Wire the devices so the IC Housing data port can access the Daylight Sensor's & Solar Panel's data ports. You will want an Area Power Controller to provide a small battery to keep the IC Housing powered at night. Load the script into the IC10 Chip.

Status: 5 - Stable

The script configures itself, so the orientation of the Daylight Sensor and Solar Panels doesn't matter. The script will try a different quadrant every 15 seconds during configuration. Using the quadrant with the highest power output, the script will then know the adustments needed to track the sun. After configuration, at next dawn, the script will record the optimal overnight parking position. Each day, the script will adjust the azimuth and elevation of the solar panels to track the sun. At sunset, the script will return the solar panels to the optimal overnight parking position (facing sunrise). This accounts for interesting locations like Europa, where the sun rises from behind Jupiter, already somewhat high in the sky.

### Printer Logistics (Customized)
[printer-logistics.ic10](./printer-logistics.ic10)

Purpose: Request specific ingots from a vending machine to run a specific printer, maintaining common ingots, requesting rarer ingots based on the selected recipe, and then stopping printing when the desired amount is reached, as determined by the setting on a connected stacker.

Devices: Vending Machine, Printer(Autolathe, Electronics Printer, Hydraulic Pipe Bender, Tool Manufactory, Security Printer, Rocket Manufactory), Stacker, Sorter, IC10 Chip, IC Housing, Button/Important Button

Device Labeling: None

Screws: Printer `d0`, [Stacker `d1`], [Sorter `d2`], [Vending Machine `d3`], [Button `d4`]

Status: 6 - Mature

Usage: Place the Vending Machine, Printer, Stacker, Sorter, IC10 Chip, IC Housing, and Button. Wire the devices so the IC Housing data port can access the Printer's, Stacker's, Sorter's, and Vending Machine's data ports. Connect the vending machine output to the sorter's input via chutes. Connect the printer from the sorters second output via chutes. Connect the stacker from the printer's output. Load the script into the IC10 Chip. Set the desired recipe on the Printer. Set the desired amount on the Stacker. Use the Button to re-request ingots from the vending machine. The script will request specific ingots from the Vending Machine to run the Printer, maintaining common ingots, requesting rarer ingots based on the selected recipe, and then stopping printing when the desired amount is reached.

The script runs a single printer, but the intended use is to share the vending machine and button among multiple chips/printers. When requests collide, or the vending machine was out, the button is used compensate.

Credit: CowsAreEvil wrote the original. I refactored it to use the stack for ingots rather then hardcode them, mostly so I understood how the script/stack worked. This video explained the premise of this script: [Stationeers Printer Logistics 3 Full build](https://www.youtube.com/watch?v=dkuO6sIlScI). The script is also published on the workshop: [Printer Logistics v4](https://steamcommunity.com/sharedfiles/filedetails/?id=2839308009)

### The Attic
[./attic/](./attic/)

Various scripts and experiments that may or may not be useful or work in the current version of the game.

Status: 2 - Pre-Alpha, 3 - Alpha, 4 - Beta, 7 - Inactive (depending on the script)
