# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This repository contains 3D models designed for 3D printing. Models may be created using parametric CAD tools (OpenSCAD, CadQuery, etc.) or procedural generation scripts.

## File Conventions

- `.scad` - OpenSCAD parametric models
- `.py` - CadQuery or other Python-based CAD scripts
- `.stl` - Exported mesh files for slicing
- `.3mf` - Print-ready files with print settings

## Printer

- Artillery Genius Pro
- Build volume: 220 x 220 x 250 mm
- FDM (fused deposition modeling)

## Homelab / Tailscale

- Tailscale hostname: `thevault`
- Gallery URL: `http://thevault/3d.html`
- OctoPrint URL: `http://thevault:5000`
- 3D files served at: `http://thevault/3d-files/`
- Render script: `./render.sh` (in repo root)
- PrusaSlicer profile: `./profiles/artillery-genius-pro.ini`

## Render output

After running a render, always include the direct URL to the relevant file:
- PNG preview: `http://thevault/3d-files/<path>/<name>.png`
- STL viewer: `http://thevault/3d.html` (gallery with interactive 3D viewer)
- The path is relative to `~/3d-design/`

Example: if the model is at `goggles-case/goggles-case.scad`, the preview is at `http://thevault/3d-files/goggles-case/goggles-case.png`

## Design Guidelines

- Design with print orientation in mind - minimize supports where possible
- Use parametric dimensions for customizable parts
- Include tolerance variables for press-fit and clearance fits (typically 0.2mm for FDM)
- Keep wall thickness above 1.2mm for structural parts

## Rendering

When rendering OpenSCAD models, save outputs in the same folder as the source `.scad` file.

- **STL**: `openscad -o <name>.stl <name>.scad` - for slicing (gitignored)
- **PNG preview**: always render a PNG so the model can be visually checked later (tracked in git)

PNG render command:
```
openscad -o <name>.png \
  --imgsize=1920,1080 \
  --autocenter --viewall \
  --camera=0,0,0,55,0,25,0 \
  --projection=p \
  --colorscheme=DeepOcean \
  <name>.scad
```

Key flags:
- `--autocenter --viewall`: always frame the entire model, never zoom into details
- `--camera=0,0,0,55,0,25,0`: 3/4 top-down view (rot_x=55, rot_z=25) - shows depth and volume
- `--projection=p`: perspective projection for natural depth
- `--colorscheme=DeepOcean`: gives good contrast and sense of volume
