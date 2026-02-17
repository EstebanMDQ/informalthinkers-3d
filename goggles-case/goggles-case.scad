// Swimming Goggles Case v4
// Fishing net structure - entire case (bottom + walls) is net pattern
// Only the opening rim is solid, for rigidity and magnet mounting
// Hinge at rim level - bridges between rims so case folds closed naturally
// Fits Artillery Genius Pro bed (220x220mm)

/* [Main Dimensions] */
inner_length = 160;      // mm - goggles length + clearance
inner_width = 70;        // mm - goggles width + clearance
inner_depth = 25;        // mm - depth per half (50mm total closed)
wall = 1.2;              // mm - shell thickness / net string depth
corner_radius = 10;      // mm - rounded corners

/* [Living Hinge] */
hinge_cuts = 4;
hinge_thickness = 0.5;   // mm - flex line thickness
hinge_spacing = 2;       // mm - space between flex lines
hinge_gap = 0.4;         // mm - cut width

/* [Magnets] */
mag_d = 5.2;             // mm - 5mm magnet + tolerance
mag_h = 2.1;             // mm - 2mm magnet + tolerance
mag_inset = 35;          // mm - distance from short edges

/* [Net Pattern] */
net_hole = 5;            // mm - diamond diagonal size
net_gap = 1.2;           // mm - string width
net_ring_sp = 5;         // mm - horizontal ring spacing on walls

/* [Solid Rim] */
rim_h = 4;               // mm - solid band height at opening edge
rim_w = 7;               // mm - solid rim width (enough for magnets)

/* [FSM Icon] */
fsm_size = 30;           // mm - icon diameter
fsm_depth = 0.8;         // mm - relief depth

/* [Rendering] */
$fn = 12;  // Increase to 32+ for final render

// Derived dimensions
ol = inner_length + 2*wall;
ow = inner_width + 2*wall;
od = inner_depth + wall;
hw = (hinge_cuts - 1)*hinge_spacing + hinge_cuts*hinge_thickness;

echo(str("Layout: ", ol, " x ", 2*ow + hw, " mm (bed: 220x220)"));
assert(ol <= 220, "X exceeds bed!");
assert(2*ow + hw <= 220, "Y exceeds bed!");

// --- Main Assembly ---
goggles_case();

module goggles_case() {
    half(false);
    // Gap between halves; hinge bridges at the rim level
    translate([0, ow + hw, 0]) half(true);
    // Hinge at rim height, connecting the two rims
    translate([0, ow, od - wall]) living_hinge();
}

// Each half: net structure + solid rim + magnet pockets
module half(is_top) {
    difference() {
        union() {
            // Net: 3D string geometry intersected with shell volume
            render() intersection() {
                shell_volume();
                net_3d();
            }
            // Solid rim at opening edge
            opening_rim();
            // Solid patch for FSM icon on top half bottom face
            if (is_top) fsm_patch();
        }
        magnet_pockets(is_top);
        if (is_top) fsm_icon();
    }
}

// Shell volume: space where material can exist (outer - inner)
module shell_volume() {
    difference() {
        rbox(ol, ow, od, corner_radius);
        translate([wall, wall, wall])
            rbox(ol - 2*wall, ow - 2*wall, od + 1, max(corner_radius - wall, 1));
    }
}

// 3D net strings: diagonal walls (bottom + wall posts) + horizontal rings (wall cross-strings)
// When intersected with shell_volume, this creates:
//   - Bottom face: crossing diamond net pattern
//   - Side walls: grid of rectangular openings (posts + rings)
module net_3d() {
    sp = net_hole / sqrt(2) + net_gap;  // perpendicular strip spacing
    diag = sqrt(ol*ol + ow*ow);
    n = ceil(diag / sp);

    // Diagonal walls at +45 degrees, full height
    for (i = [-n : n])
        translate([ol/2, ow/2, 0])
        rotate([0, 0, 45])
        translate([i*sp - net_gap/2, -diag, 0])
            cube([net_gap, 2*diag, od]);

    // Diagonal walls at -45 degrees, full height
    for (i = [-n : n])
        translate([ol/2, ow/2, 0])
        rotate([0, 0, -45])
        translate([i*sp - net_gap/2, -diag, 0])
            cube([net_gap, 2*diag, od]);

    // Horizontal rings on walls (above bottom face, below rim)
    for (z = [wall + net_ring_sp : net_ring_sp : od - rim_h])
        translate([0, 0, z - net_gap/2])
            cube([ol, ow, net_gap]);
}

// Solid frame at the opening edge - provides rigidity and holds magnets
module opening_rim() {
    difference() {
        translate([0, 0, od - rim_h])
            rbox(ol, ow, rim_h, corner_radius);
        translate([rim_w, rim_w, od - rim_h - 0.1])
            rbox(ol - 2*rim_w, ow - 2*rim_w, rim_h + 0.2,
                 max(corner_radius - rim_w, 1));
    }
}

// Rounded box primitive
module rbox(l, w, h, r) {
    r2 = min(r, min(l, w) / 2 - 0.01);
    hull()
        for (x = [r2, l - r2], y = [r2, w - r2])
            translate([x, y, 0]) cylinder(h = h, r = r2);
}

// Solid disc on bottom face for FSM icon (fills net holes in that area)
module fsm_patch() {
    fsm_r = fsm_size/2 + net_hole;
    intersection() {
        // Bottom face of shell only
        difference() {
            rbox(ol, ow, wall + 0.01, corner_radius);
            translate([wall, wall, -0.1])
                rbox(ol - 2*wall, ow - 2*wall, wall + 0.2,
                     max(corner_radius - wall, 1));
        }
        translate([ol/2, ow/2, 0])
            cylinder(r = fsm_r, h = wall + 0.01);
    }
}

// Magnet pockets in the solid rim at the closure edge
module magnet_pockets(is_top) {
    // Closure edge: bottom half at y=0, top half at y=ow
    // Center magnet in the rim width
    py = is_top ? ow - rim_w/2 : rim_w/2;
    for (px = [mag_inset, ol - mag_inset])
        translate([px, py, od - mag_h])
            cylinder(d = mag_d, h = mag_h + 0.1);
}

// Accordion-style living hinge
module living_hinge() {
    difference() {
        cube([ol, hw, wall]);
        for (i = [0 : hinge_cuts - 1]) {
            y = i * hinge_spacing + (i + 0.5) * hinge_thickness;
            if (i % 2 == 0)
                translate([-1, y - hinge_gap/2, -0.1])
                    cube([ol - corner_radius + 1, hinge_gap, wall + 0.2]);
            else
                translate([corner_radius, y - hinge_gap/2, -0.1])
                    cube([ol - corner_radius + 1, hinge_gap, wall + 0.2]);
        }
    }
}

// --- FSM Icon ---
module fsm_icon() {
    translate([ol/2, ow/2, wall - fsm_depth]) {
        fsm_body();
        fsm_eyes();
        fsm_appendages();
    }
}

module fsm_body() {
    r = fsm_size * 0.35;
    scale([1, 1, 0.3]) sphere(r = r, $fn = 16);
    for (a = [0:60:359])
        rotate([0, 0, a])
        translate([r * 0.5, 0, 0])
        scale([1, 0.15, 0.2])
            sphere(r = r * 0.6, $fn = 12);
}

module fsm_eyes() {
    er = fsm_size * 0.08;
    sh = fsm_size * 0.25;
    for (s = [-1, 1])
        translate([fsm_size * 0.15, s * fsm_size * 0.12, 0]) {
            cylinder(r = er * 0.5, h = sh, $fn = 12);
            translate([0, 0, sh]) sphere(r = er, $fn = 16);
        }
}

module fsm_appendages() {
    al = fsm_size * 0.3;
    for (i = [0:2]) {
        translate([-fsm_size*0.25, fsm_size*0.1, 0])
        rotate([0, 0, -30 - i*25]) rotate([80, 0, 0])
            wavy_tendril(al);
        translate([-fsm_size*0.25, -fsm_size*0.1, 0])
        rotate([0, 0, 30 + i*25]) rotate([80, 0, 0])
            wavy_tendril(al);
    }
}

module wavy_tendril(length) {
    segs = 4;
    sl = length / segs;
    t = fsm_size * 0.03;
    for (i = [0:segs-1])
        translate([0, 0, i * sl])
        rotate([sin(i*60)*20, cos(i*45)*15, 0])
            cylinder(r1 = t*(1-i*0.1), r2 = t*(0.9-i*0.1), h = sl, $fn = 6);
}
