// Calibration test print for Printalot Flex PLA
// Tests retraction (stringing) and thin wall integrity

// --- Parameters ---
base_thickness = 2;
base_width = 60;       // X dimension
base_depth = 60;       // Y dimension

// Retraction towers
tower_d = 8;           // diameter
tower_h = 30;
tower_count = 4;
// Towers placed along X at: 0, 20, 40, 60mm spacing from first tower
// Gaps between adjacent towers: 20mm, 20mm, 20mm
// But we want varied gaps: 20, 40, 60 from center
// Place 4 towers at X positions so gaps are 20, 20, 20 (total span 60mm)
// Actually - plan says spaced at 20mm, 40mm, 60mm apart
// Meaning: tower 1 at origin, then gaps of 20, 40, 60 between pairs
// That would span 120mm - too wide. Re-reading: "spaced at 20mm, 40mm, 60mm apart"
// means 3 gaps between 4 towers: 20, 20, 20 = 60mm span fits the base
// To test different travel distances, let's do asymmetric: 10, 20, 30mm gaps
tower_positions = [0, 10, 30, 60]; // gaps: 10, 20, 30mm

// Thin wall strips
wall_1_thickness = 1.2;  // matches goggles net_gap
wall_2_thickness = 1.5;  // matches goggles wall thickness
wall_height = 20;
wall_length = 25;
wall_gap = 10;           // space between the two walls

// --- Base plate ---
module base_plate() {
    cube([base_width, base_depth, base_thickness]);
}

// --- Retraction towers ---
module retraction_towers() {
    y_pos = base_depth / 2;
    for (x = tower_positions) {
        translate([x, y_pos, base_thickness])
            cylinder(d = tower_d, h = tower_h, $fn = 48);
    }
}

// --- Thin wall strips ---
module thin_walls() {
    x_start = 5;
    y_start = 5;

    // 1.2mm wall
    translate([x_start, y_start, base_thickness])
        cube([wall_length, wall_1_thickness, wall_height]);

    // 1.5mm wall
    translate([x_start, y_start + wall_1_thickness + wall_gap, base_thickness])
        cube([wall_length, wall_2_thickness, wall_height]);
}

// --- Assembly ---
base_plate();
retraction_towers();
thin_walls();
