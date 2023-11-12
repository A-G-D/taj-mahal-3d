use <finial.scad>
use <modules/extrude.scad>
use <utils/regular_polygon_points.scad>


module major_dome(radius, height, dome_radius, cap_a_count = 360)
{
    assert(dome_radius > radius, "[module major_dome()]: <dome_radius> must be greater than <radius>");

    dome_height = 0.6*height;
    finial_height = 0.25*height;
    wall_height = height - (dome_height + finial_height);

    finial_base_radius = 0.1*radius;
    finial_rod_radius = 0.2*finial_base_radius;

    module dome()
    {
        circle_points = regular_polygon_points(r=1, n=72);

        dome_bottom_height = sqrt(dome_radius*dome_radius - radius*radius);
        d_offset = dome_radius - dome_bottom_height;
        cone_angle = acos(dome_radius/(dome_height - dome_bottom_height));
        cone_offset = dome_radius*cos(cone_angle);
        cone_base_radius = dome_radius*sin(cone_angle);
        cone_height = dome_height - cone_offset - (dome_radius - d_offset);
        scaler_fn = function (d)
            let
            (
                cone_d = d - (dome_radius - d_offset + cone_offset),
                h = dome_radius - (d_offset + d)
            )
                cone_d < 0 ? sqrt(dome_radius*dome_radius - h*h) : cone_base_radius*(1 - cone_d/cone_height);

        cap_top_radius = 1.2*finial_base_radius;
        cap_h = 0.3*dome_radius;
        cap_m = 0.02;
        cap_n = 36;
        cap_cs_points = [for (i=[0:360/cap_a_count:360]) [(1 + cap_m*sin(cap_n*i))*cos(i), (1 + cap_m*sin(cap_n*i))*sin(i)]];
        cap_scaler_fn = function (d)
            cap_top_radius + (cone_base_radius - cap_top_radius)*(1 - (d + cone_height - cap_h)/cone_height);

        union()
        {
            extrude(
                points=circle_points,
                limits=[0:dome_height/50:dome_height],
                scaler_fn=scaler_fn
            );
            translate([0, 0, dome_height - cap_h])
                extrude(
                    points=cap_cs_points,
                    limits=[0:cap_h/50:cap_h],
                    scaler_fn=cap_scaler_fn
                );
        }
    }

    union()
    {
        cylinder(h=wall_height, r=radius, $fn=72);

        translate([0, 0, wall_height])
            dome();

        translate([0, 0, wall_height + dome_height])
            finial(
                base_radius=finial_base_radius,
                rod_radius=finial_rod_radius,
                height=finial_height,
                a_count=cap_a_count,
                node_cs_count=25,
                n=36,
                $fn=45
            );
    }
}


major_dome(
    radius=10,
    height=40,
    dome_radius=12,
    cap_a_count=270
);