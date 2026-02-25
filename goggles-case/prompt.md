# Swimming Goggles Case

## Summary
Two-piece friction-fit case for compact swimming goggles with magnetic closure, net texture, and decorative exterior.

## Requirements
- Fits goggles approximately 15x6x4 cm
- Must fit on printer bed (220x220mm max)
- Two separate halves placed side by side on print bed
- Friction-fit lip on bottom half, clearance groove on top half
- Magnets on both long edges hold halves together when closed
- Material: Flex PLA (requires thin walls ~1.5mm)
- Drainage holes for water via net pattern
- Magnetic snap closure

## Design Features

### Structure
- Two separate halves (no hinge) - top half flips over and seats onto bottom half
- Friction-fit lip on bottom half's inner rim perimeter, matching groove on top half
- Fishing net texture covers the entire surface: bottom face AND side walls
- 1.5mm wall thickness for improved durability
- Interior hull-based 45-degree chamfer at bottom-to-wall transition (eliminates sharp corner)
- Solid rim (8mm wide) at the opening edge for rigidity, magnet mounting, and lip support
- 8 magnet pockets total (4 per half, 2 on each long edge) for 5x2mm neodymium discs

### Exterior Texture
- Fishing net pattern: crossing diagonal strips forming diamond-shaped holes
- Covers bottom and all side walls for maximum flexibility and drainage
- Holes go fully through for water drainage
- Pattern provides grip and visual interest

### Logo
- Flat solid circle (30mm) on top half bottom face
- Fills net holes in that area to create a smooth surface
- Intended for adding a custom logo (engraving, sticker, etc.)

## Key Parameters
| Parameter | Value | Notes |
|-----------|-------|-------|
| inner_length | 160mm | Goggles ~150mm + clearance |
| inner_width | 70mm | |
| inner_depth | 25mm | Per half, 50mm total closed |
| wall | 1.5mm | Shell thickness / net string depth |
| corner_radius | 10mm | |
| lip_h | 2mm | Lip height above rim (shorter for flex PLA) |
| lip_wall | 2mm | Lip wall thickness (thicker for flex PLA adhesion) |
| lip_tol | 0.3mm | FDM clearance tolerance (compensate thicker lip) |
| fillet_r | 5mm | Interior bottom-to-wall chamfer (gradual for flex PLA) |
| rim_w | 8mm | Wide enough for magnets + lip |
| logo_d | 30mm | Flat circle for custom logo |
| magnet_diameter | 5mm | Standard neodymium disc |
| half_gap | 5mm | Gap between halves on bed |

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
- v5: Replaced living hinge with two separate halves. Friction-fit lip + magnets on both long edges for closure. Wall 1.2->1.5mm, rim 7->8mm. Added interior hull-based chamfer at bottom-to-wall transition. 8 magnets total (4 per half). Replaced FSM icon with flat logo pad.
- v6: Flex PLA print fixes. Solid chamfer zone (no net in bottom-to-wall transition) to prevent delamination. Thicker lip (1.2->2mm) and shorter (3->2mm) for better layer adhesion. Wider tolerance (0.2->0.3mm) to compensate. Taller rim (4->6mm) to reduce stringing. Larger fillet radius (3->5mm) for gradual transition.
