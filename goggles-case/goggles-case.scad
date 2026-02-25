// Swimming Goggles Case v6
// Two separate halves with friction-fit lip and magnets
// v6: Flex PLA fixes - solid chamfer zone, thicker lip, taller rim
// Fishing net structure covers bottom + walls
// Solid rim at opening edge for rigidity and magnet mounting
// Fits Artillery Genius Pro bed (220x220mm)

/* [Main Dimensions] */
inner_length = 160;      // mm - goggles length + clearance
inner_width = 70;        // mm - goggles width + clearance
inner_depth = 25;        // mm - depth per half (50mm total closed)
wall = 1.5;              // mm - shell thickness / net string depth
corner_radius = 10;      // mm - rounded corners

/* [Friction-Fit Lip] */
lip_h = 2;               // mm - height lip extends above rim (shorter = less leverage)
lip_wall = 2;            // mm - lip wall thickness (thicker for flex PLA adhesion)
lip_tol = 0.3;           // mm - FDM clearance tolerance (compensate thicker lip)

/* [Interior Fillet] */
fillet_r = 5;            // mm - bottom-to-wall chamfer radius (gradual transition for flex PLA)

/* [Magnets] */
mag_d = 5.2;             // mm - 5mm magnet + tolerance
mag_h = 2.1;             // mm - 2mm magnet + tolerance
mag_inset = 35;          // mm - distance from short edges

/* [Net Pattern] */
net_hole = 5;            // mm - diamond diagonal size
net_gap = 1.2;           // mm - string width
net_ring_sp = 5;         // mm - horizontal ring spacing on walls

/* [Solid Rim] */
rim_h = 6;               // mm - solid band height at opening edge (taller = less stringing)
rim_w = 8;               // mm - solid rim width (enough for magnets + lip)

/* [Logo Pad] */
logo_d = 30;             // mm - flat circle diameter for custom logo

/* [Layout] */
half_gap = 5;            // mm - gap between halves on print bed

/* [Rendering] */
$fn = 12;  // Increase to 32+ for final render

// Derived dimensions
ol = inner_length + 2*wall;
ow = inner_width + 2*wall;
od = inner_depth + wall;

echo(str("Layout: ", ol, " x ", 2*ow + half_gap, " mm (bed: 220x220)"));
assert(ol <= 220, "X exceeds bed!");
assert(2*ow + half_gap <= 220, "Y exceeds bed!");

// --- Main Assembly ---
goggles_case();

module goggles_case() {
    half(false);
    translate([0, ow + half_gap, 0]) half(true);
}

// Each half: net structure + solid rim + friction lip + magnet pockets
module half(is_top) {
    difference() {
        union() {
            // Net: 3D string geometry intersected with shell volume
            render() intersection() {
                shell_volume();
                net_3d();
            }
            // Solid chamfer zone: fill net holes in the bottom-to-wall transition
            // Prevents delamination with flex PLA
            render() intersection() {
                shell_volume();
                cube([ol, ow, fillet_r + wall]);
            }
            // Solid rim at opening edge
            opening_rim();
            // Flat solid circle on top half bottom face for custom logo
            if (is_top) logo_pad();
            // Friction lip on bottom half
            if (!is_top) friction_lip();
        }
        magnet_pockets();
        // Groove in top half for friction lip clearance
        if (is_top) lip_clearance();
    }
}

// Shell volume: space where material can exist (outer - inner)
// Both outer and inner shapes have hull-based chamfers at the bottom edge
module shell_volume() {
    difference() {
        outer_shell();
        interior_cavity();
    }
}

// Outer shell with rounded bottom edge
module outer_shell() {
    hull() {
        // Floor level: inset by fillet_r
        translate([fillet_r, fillet_r, 0])
            rbox(ol - 2*fillet_r, ow - 2*fillet_r, 0.01,
                 max(corner_radius - fillet_r, 0.5));
        // At fillet_r height: full outer footprint
        translate([0, 0, fillet_r])
            rbox(ol, ow, 0.01, corner_radius);
    }
    // Straight extrusion above the chamfer
    translate([0, 0, fillet_r])
        rbox(ol, ow, od - fillet_r, corner_radius);
}

// Interior cavity with hull-based 45-degree chamfer at bottom-to-wall transition
module interior_cavity() {
    ir = max(corner_radius - wall, 1);
    ix = ol - 2*wall;
    iy = ow - 2*wall;

    translate([wall, wall, wall]) {
        // Chamfer zone: hull from smaller footprint at floor to full footprint at fillet_r
        hull() {
            // Floor level: inset by fillet_r on each side
            rbox(ix - 2*fillet_r, iy - 2*fillet_r, 0.01,
                 max(ir - fillet_r, 0.5));
            // At fillet_r height: full inner footprint, thin slice
            translate([0, 0, fillet_r])
                rbox(ix, iy, 0.01, ir);
        }
        // Straight extrusion above the chamfer to top (with overshoot for clean cut)
        translate([0, 0, fillet_r])
            rbox(ix, iy, od - wall - fillet_r + 1, ir);
    }
}

// 3D net strings: diagonal walls (bottom + wall posts) + horizontal rings
module net_3d() {
    sp = net_hole / sqrt(2) + net_gap;
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

// Solid frame at the opening edge
module opening_rim() {
    difference() {
        translate([0, 0, od - rim_h])
            rbox(ol, ow, rim_h, corner_radius);
        translate([rim_w, rim_w, od - rim_h - 0.1])
            rbox(ol - 2*rim_w, ow - 2*rim_w, rim_h + 0.2,
                 max(corner_radius - rim_w, 1));
    }
}

// Friction lip: thin wall rising above the rim on the bottom half
// Outer face aligns with the inner edge of the solid rim
module friction_lip() {
    ir = max(corner_radius - rim_w, 1);
    difference() {
        // Outer boundary: matches inner edge of rim
        translate([rim_w, rim_w, od])
            rbox(ol - 2*rim_w, ow - 2*rim_w, lip_h, ir);
        // Inner boundary: inset by lip_wall
        translate([rim_w + lip_wall, rim_w + lip_wall, od - 0.1])
            rbox(ol - 2*rim_w - 2*lip_wall, ow - 2*rim_w - 2*lip_wall,
                 lip_h + 0.2, max(ir - lip_wall, 0.5));
    }
}

// Groove in top half's inner rim face for lip clearance
module lip_clearance() {
    ir = max(corner_radius - rim_w, 1);
    groove_depth = lip_wall + lip_tol;
    groove_h = lip_h + lip_tol;
    difference() {
        // Outer cut: slightly larger than lip
        translate([rim_w - lip_tol, rim_w - lip_tol, od - groove_h])
            rbox(ol - 2*rim_w + 2*lip_tol, ow - 2*rim_w + 2*lip_tol,
                 groove_h + 0.1, max(ir, 0.5));
        // Inner: leave material inside the groove
        translate([rim_w + groove_depth, rim_w + groove_depth, od - groove_h - 0.1])
            rbox(ol - 2*rim_w - 2*groove_depth, ow - 2*rim_w - 2*groove_depth,
                 groove_h + 0.3, max(ir - groove_depth, 0.5));
    }
}

// Magnet pockets on both long edges of each half
// When top is flipped, y-positions swap so all 4 pairs align
module magnet_pockets() {
    for (py = [rim_w/2, ow - rim_w/2])
        for (px = [mag_inset, ol - mag_inset])
            translate([px, py, od - mag_h])
                cylinder(d = mag_d, h = mag_h + 0.1);
}

// Rounded box primitive
module rbox(l, w, h, r) {
    r2 = min(r, min(l, w) / 2 - 0.01);
    hull()
        for (x = [r2, l - r2], y = [r2, w - r2])
            translate([x, y, 0]) cylinder(h = h, r = r2);
}

// Flat solid circle on top half bottom face for custom logo
// Fills net holes in this area, creating a smooth surface to engrave/attach a logo
module logo_pad() {
    intersection() {
        // Bottom face of shell only
        difference() {
            rbox(ol, ow, wall + 0.01, corner_radius);
            translate([wall, wall, -0.1])
                rbox(ol - 2*wall, ow - 2*wall, wall + 0.2,
                     max(corner_radius - wall, 1));
        }
        translate([ol/2, ow/2, 0])
            cylinder(d = logo_d, h = wall + 0.01);
    }
}
