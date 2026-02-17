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

## Design Guidelines

- Design with print orientation in mind - minimize supports where possible
- Use parametric dimensions for customizable parts
- Include tolerance variables for press-fit and clearance fits (typically 0.2mm for FDM)
- Keep wall thickness above 1.2mm for structural parts
