use <platform.scad>
use <hall.scad>
use <finial.scad>
use <minaret.scad>
use <minor_dome.scad>
use <major_dome.scad>


module taj_mahal(
    platform_thickness,
    platform_bounds_length,
    platform_bounds_width,
    platform_corner_octagon_outer_radius,
    platform_corner_octagon_inner_radius,
    hall_height,
    hall_bounds_length,
    hall_bounds_width,
    hall_pillar_excess_height,
    minaret_radius,
    minaret_height,
    major_dome_radius,
    major_dome_height,
    minor_dome_radius,
    minor_dome_height
)
{
    minaret_offset_x = platform_bounds_width/2 - minaret_radius;
    minaret_offset_y = platform_bounds_length/2 - minaret_radius;
    major_dome_offset_z = platform_thickness + hall_height;

    union()
    {
        /*
        *   The Platform
        */
        platform(
            thickness=platform_thickness,
            bounds_length=platform_bounds_length,
            bounds_width=platform_bounds_width,
            corner_octagon_outer_radius=platform_corner_octagon_outer_radius,
            corner_octagon_inner_radius=platform_corner_octagon_inner_radius
        );

        /*
        *   The Hall
        */
        translate([0, 0, platform_thickness])
            hall(
                height=hall_height,
                bounds_length=hall_bounds_length,
                bounds_width=hall_bounds_width,
                pillar_excess_height=hall_pillar_excess_height
            );

        /*
        *   The 4 Minarets
        */
        union()
        {
            translate([minaret_offset_x, minaret_offset_y, platform_thickness])
                minaret(radius=minaret_radius, height=minaret_height);
            translate([-minaret_offset_x, minaret_offset_y, platform_thickness])
                minaret(radius=minaret_radius, height=minaret_height);
            translate([-minaret_offset_x, -minaret_offset_y, platform_thickness])
                minaret(radius=minaret_radius, height=minaret_height);
            translate([minaret_offset_x, -minaret_offset_y, platform_thickness])
                minaret(radius=minaret_radius, height=minaret_height);
        }

        /*
        *   The Major Dome
        */
        translate([0, 0, major_dome_offset_z])
            major_dome(radius=major_dome_radius, height=major_dome_height);

        /*
        *   The 4 Minor Domes
        */
        union()
        {
            translate([0, 0, major_dome_offset_z])
                minor_dome(radius=minor_dome_radius, height=minor_dome_height);
            translate([0, 0, major_dome_offset_z])
                minor_dome(radius=minor_dome_radius, height=minor_dome_height);
            translate([0, 0, major_dome_offset_z])
                minor_dome(radius=minor_dome_radius, height=minor_dome_height);
        }
    }
}


// taj_mahal(
//     platform_thickness=100,
//     platform_bounds_length=1000,
//     platform_bounds_width=1000,
//     platform_corner_octagon_outer_radius=80,
//     platform_corner_octagon_inner_radius=80,

//     hall_height=400,
//     hall_bounds_length=600,
//     hall_bounds_width=600,
//     hall_pillar_excess_height=120,

//     minaret_radius=80,
//     minaret_height=700,

//     major_dome_radius=280,
//     major_dome_height=280,

//     minor_dome_radius=150,
//     minor_dome_height=150
// );
