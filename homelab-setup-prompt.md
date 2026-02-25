# Homelab Setup Prompt

Prompt for Claude Code to configure a headless Linux server for 3D printing pipeline.

---

Configura este servidor Linux headless para un pipeline de diseño 3D con OpenSCAD y PrusaSlicer CLI. Modo autonomous.

## Que instalar

- OpenSCAD (CLI)
- xvfb (para renderizado sin display)
- PrusaSlicer (CLI)

Usa el package manager del sistema (apt, dnf, etc). Verifica cual distro es antes de instalar.

## Perfil PrusaSlicer para Artillery Genius Pro

Crea un perfil .ini para PrusaSlicer con estos parametros:

- Impresora: Artillery Genius Pro
- Volumen: 220 x 220 x 250 mm
- Extrusor: direct drive, nozzle 0.4mm
- Filamento: PLA generico (200C extrusor, 60C cama)
- Layer height: 0.2mm
- Infill: 20% gyroid
- Soportes: desactivados por defecto
- Velocidad: 60mm/s paredes, 80mm/s infill
- Retraccion: 1mm a 40mm/s (direct drive)
- G-code flavor: Marlin
- Start/end G-code estandar para Marlin (home, heat, purge line, etc)

Guarda el perfil en ~/3d-printing/profiles/artillery-genius-pro.ini

## Script de pipeline

Crea un script ~/3d-printing/render.sh que reciba un .scad y:

1. Renderice el STL con openscad (via xvfb-run)
2. Renderice un PNG preview (1920x1080, projection perspectiva, colorscheme DeepOcean, autocenter, viewall, camera 0,0,0,55,0,25,0)
3. Slicee el STL con PrusaSlicer usando el perfil de Artillery
4. Outputs en el mismo directorio que el .scad

Uso: ./render.sh path/to/model.scad

## Validacion

Despues de instalar todo, crea un cubo de prueba en /tmp/test-cube.scad (20x20x20mm) y ejecuta el pipeline completo para verificar que funciona. Muestra los archivos generados.
