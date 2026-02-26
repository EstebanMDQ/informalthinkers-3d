# Calibration Test Print for Printalot Flex PLA

## Purpose

Quick test print to dial in settings for Printalot PLA Flex (PLA+PBAT blend) before reprinting the goggles case. The goggles case failed with stringing between features and holes in thin walls - this print directly tests both failure modes.

## What's on the plate

- **4 retraction towers** - 8mm diameter cylinders, 30mm tall, spaced at increasing distances (20mm, 40mm, 60mm apart). The nozzle travels between towers on each layer, exposing any stringing. Different gaps test short vs long travel moves.
- **Thin wall strips** - a 1.2mm wall and a 1.5mm wall, both 20mm tall. These match the goggles case dimensions (`net_gap` and `wall` thickness). Check for holes, under-extrusion, or inconsistent layers.
- **Base plate** - 2mm thick base connecting everything. Tests first layer adhesion and bed leveling.

## How to use

1. Print with `profiles/artillery-genius-pro.ini` using `[print:0.2mm Flex PLA]` + `[filament:Printalot Flex PLA]`
2. Inspect results:
   - **Stringing**: look between towers, especially the 60mm gap. Wisps = increase retraction length. Blobs at tower start = increase retraction speed or add wipe.
   - **Thin walls**: should be solid with no visible gaps. Holes = slow down perimeter speed or increase temperature. Under-extrusion = bump flow rate or increase temp.
   - **Base adhesion**: should be flat and stuck. Warping = increase bed temp or first layer temp.
3. Adjust settings and reprint until clean, then use those settings for the goggles case.

## Estimated print time

~15 minutes at the Flex PLA speeds (40mm/s perimeters, 50mm/s infill).
