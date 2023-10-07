use <modules/extrude.scad>
use <modules/frustum.scad>
use <modules/polar_array.scad>
use <utils/regular_polygon_points.scad>
use <utils/fillet_points.scad>
use <utils/merge_ranges.scad>


module pillar(height, radius, sides = 16, fillet = false)
{
    crown_height = (7/80)*height;
    bell_height = (1/10)*height;
    ring_height = (1/20)*height;

    trunk_height = height - (ring_height + bell_height + crown_height);
    pillar_cs_points = fillet
        ? fillet_points(regular_polygon_points(radius, sides), 0.2*radius)
        : regular_polygon_points(radius, sides);

    function bell_top_profile(deg) =
        pow(1 + deg/5, 0.2) + 0.005*(pow(deg/20 - 9, 2));

    function bell_bottom_profile(deg) =
        pow(1 + deg/5, 0.2);

    module trunk(height)
    {
        extrude(
            points=pillar_cs_points,
            limits=[0:1:height]
        );
    }

    module ring(points, height)
    {
        ring_scaler = function (z)
            let(deg = 360*(z/height))
                1.6 - 0.3*(1 + sin(0.5*360*(1.5 + 1 - deg/180)));

        extrude(
            points=points,
            limits=[0:1:height],
            scaler_fn=ring_scaler
        );
    }

    module bell(points, height)
    {
        bell_scaler = function (z)
            let(deg = 360*(z/height))
                deg < 180 ? bell_bottom_profile(deg) : bell_top_profile(deg);

        extrude(
            points=points,
            limits=[0:1:height],
            scaler_fn=bell_scaler
        );
    }

    module crown(height)
    {
        module lamp()
        {
            lamp_scaler = function (z)
                z < 30
                    ? 2 + 0.25*z/height
                    : z < 50
                        ? 2 + 0.25*(60 - z)/height + 3.5*(30 - z)/height
                        : 2 + 0.25*(60 - z)/height + 3.5*(30 - z)/height + 2*(z - 50)/height;

            extrude(
                points=pillar_cs_points,
                limits=[0:1:height],
                scaler_fn=lamp_scaler
            );
        }

        bell_top_radius = radius*bell_top_profile(360)*cos(180/sides);

        frustum_base_side = radius*bell_top_profile(360)*sin(180/sides);
        frustum_radius_bottom = frustum_base_side*sqrt(2);
        frustum_radius_top = (3/10)*frustum_base_side*sqrt(2);

        union()
        {
            extrude(
                points=pillar_cs_points,
                limits=[0, 2*frustum_base_side],
                scaler_fn=function (z) bell_top_profile(360)
            );

            translate([0, 0, frustum_base_side])
            rotate([0, 0, 180/sides])
            polar_array(n=sides, radius=bell_top_radius)
            rotate([90, 45, 90])
                frustum(
                    n=4,
                    radius_bottom=frustum_radius_bottom,
                    radius_top=frustum_radius_top,
                    height=10
                );

            translate([0, 0, 2*frustum_base_side])
                lamp();
        }
    }

    union()
    {
        trunk(trunk_height);

        translate([0, 0, trunk_height])
            ring(
                points=pillar_cs_points,
                height=ring_height
            );

        translate([0, 0, trunk_height + ring_height])
            bell(
                points=pillar_cs_points,
                height=bell_height
            );

        translate([0, 0, trunk_height + ring_height + bell_height])
            crown(crown_height);
    }
}


pillar(
    height=800,
    radius=20
);