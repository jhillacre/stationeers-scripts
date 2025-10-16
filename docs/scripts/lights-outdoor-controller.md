# Lights Outdoor Controller

[lights-outdoor-controller.ic10](../../lights-outdoor-controller.ic10)

## Purpose
Toggles exterior lighting based on day/night and storm status provided by upstream memories (e.g., the day-weather-state mirror).

## Devices
| Device Name | Count | Required? | Purpose |
|-------------|------:|-----------|---------|
| Logic Memory (is day) | 1 | Yes | Provides day/night flag. |
| Logic Memory (is storm) | 1 | Yes | Provides storm/imminent flag. |
| Outdoor Lights (various) | N | Yes | Any supported light device hashes to drive. |

## Device Registers
| Register | Device | Purpose |
|---------:|--------|---------|
| `d0` | Day memory | Day/night flag (`Setting`). |
| `d1` | Storm memory | Storm state (`Setting`; 2 = storm, 1 = imminent, 0 = clear). |

## Stack
Stores the list of light device hashes that should be toggled together.

## Batch
- Preloads a stack of supported light device hashes (diodes, glow lights, flashing lights, wall lights, etc.).
- Iterates through the list and writes the computed on/off state to each device via `sb`.

## Usage
1. Feed day/night and storm flags into logic memories (for example, from `day-weather-state-mirror.ic10`).
2. Wire those memories to `d0` and `d1` on the controller housing.
3. Place exterior lights on the same network; supported device hashes include diodes, glow lights, long lights, and wall lights.
4. Run the script. Lights turn on whenever it is night or an active storm is detected.

## Notes
- Storm state overrides day/night, ensuring warnings during daylight storms.
- Add new light hashes to the stack if you introduce unsupported fixtures.
- Keep the memory signals updated at a reasonable cadence (the script reads them each loop).

## Status
Functional
