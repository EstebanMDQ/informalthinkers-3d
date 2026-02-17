# Swimming Goggles Case

## Summary
Print-in-place flexible clamshell case for compact swimming goggles with living hinge, magnetic closure, and decorative exterior.

## Requirements
- Fits goggles approximately 15x6x4 cm
- Must fit on printer bed (220x220mm max)
- Prints flat with gap between halves, hinge bridges at rim height
- Folds closed via living hinge at the rim - magnets on opposite edge snap shut
- Material: Flex PLA (requires thin walls ~1.2mm)
- Drainage holes for water
- Magnetic snap closure

## Design Features

### Structure
- Clamshell design with two rounded box halves
- Living hinge at the rim level - bridges between the two rims so the case folds closed naturally
- Accordion-style flex cuts in the hinge (multiple parallel cuts)
- Fishing net texture covers the entire surface: bottom face AND side walls
- Thin, flexible walls - no solid shell, just the net pattern
- Solid rim only at the opening edge (last 3-4mm) for rigidity and magnet mounting
- 4 magnet pockets (2 per half) for 5x2mm neodymium discs, embedded in the solid rim

### Exterior Texture
- Fishing net pattern: crossing diagonal strips forming diamond-shaped holes
- Covers bottom and all side walls for maximum flexibility and drainage
- Holes go fully through for water drainage
- Pattern provides grip and visual interest

### Decoration
- Flying Spaghetti Monster (FSM) icon embossed/debossed on top half
- Simplified relief: spaghetti mound body, two meatball eyes on stalks

## Key Parameters
| Parameter | Value | Notes |
|-----------|-------|-------|
| inner_length | 160mm | Goggles ~150mm + clearance |
| inner_width | 70mm | |
| inner_depth | 25mm | Per half, 50mm total closed |
| wall | 1.2mm | Net string thickness |
| corner_radius | 10mm | |
| hinge_thickness | 0.5mm | Flex line thickness |
| magnet_diameter | 5mm | Standard neodymium disc |

## Print Settings
- Material: Flex PLA or TPU
- Layer height: 0.2mm
- Infill: 100% for walls, or use vase mode where possible
- Orientation: Flat as designed
- Supports: None needed

## Files
- `goggles-case.scad` - Main parametric OpenSCAD model

## Revision History
- v1: Initial design with basic structure
- v2: Added hexagonal texture and FSM icon
- v3: Fishing net texture, solid rim for magnets, bed size constraint (220x220mm)
- v4: Net texture on walls too, thin flexible walls, solid rim only at opening edge (3-4mm), hinge moved to rim level
