// https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Taj_Mahal_finial-1.jpg/200px-Taj_Mahal_finial-1.jpg
use <modules/extrude.scad>
use <utils/regular_polygon_points.scad>

module finial(base_radius, rod_radius, height, a_count = 90, node_cs_count = 50, n = 12)
{
    r_amplitude = 0.05*base_radius;

    node_1_height = 0.12*height;

    node_2_offset = 0.135*height;
    node_2_height = 0.1*height;

    node_3_offset = 0.25*height;
    node_3_height = 0.25*height;

    node_4_offset = 0.53*height;
    node_4_height = 0.01*height;

    node_5_offset = 0.54*height;
    node_5_height = 0.06*height;

    node_6_offset = 0.60*height;
    node_6_height = 0.015*height;

    node_7_offset = 0.635*height;
    node_7_height = 0.075*height;

    node_8_offset = 0.73*height;
    node_8_height = 0.02*height;

    node_9_offset = 0.75*height;
    node_9_height = 0.05*height;

    node_10_offset = 0.85*height;
    node_10_height = 0.15*height;

    rod_height = height - node_10_height;

    cs_points = [for (i=[0:360/a_count:360])
        let
        (
            min_r = base_radius - r_amplitude,
            r = min_r + r_amplitude*sin(i*n)
        )
            [r*cos(i), r*sin(i)]
    ];

    circle_cs_points = regular_polygon_points(1, 360);

    function smoothclamp(lo, hi, x) =
        x*(hi - lo) + lo;

    function reverse_smoothclamp(lo, hi, x) =
        (x - lo) / (hi - lo);


    module node_1(height)
    {
        extrude(
            points=cs_points,
            limits=[0:height/node_cs_count:height],
            scaler_fn=function (z) sqrt(height*height - z*z)/base_radius
        );
    }

    module node_2(height)
    {
        extrude(
            points=cs_points,
            limits=[0:height/node_cs_count:height],
            scaler_fn=function (z)
                let
                (
                    radius = height/2,
                    dz = radius - z
                )
                    sqrt(radius*radius - dz*dz)/base_radius
        );
    }

    module node_3(height, pipe_radius)
    {
        extrude(
            points=cs_points,
            limits=[0:height/node_cs_count:height],
            scaler_fn=function (z)
                let
                (
                    dia = (3/4)*height,
                    radius = dia/2,
                    dz = radius - z,
                    z_factor = smoothclamp(0.5, 1, reverse_smoothclamp(radius/height, 1, z/height))
                )
                    z < radius
                        ? sqrt(radius*radius - dz*dz)/base_radius
                        : smoothclamp(pipe_radius/radius, 1, 0.5 + 0.5*cos(2*(z_factor*180 - 90)))*radius/base_radius
        );
    }

    module node_4(height, pipe_radius)
    {
        radius = height/2;
        scaler_fn = function (z)
            let
            (
                dz = radius - z
            )
                pipe_radius + 1.25*sqrt(radius*radius - dz*dz);

        extrude(
            points=circle_cs_points,
            limits=[0:height/node_cs_count:height],
            scaler_fn=scaler_fn
        );
    }

    module node_5(height, pipe_radius)
    {
        radius = height/2;
        scaler_fn = function (z)
            let
            (
                dz = radius - z,
                z_factor = z/height,
                zz_factor = (z_factor - 0.7)/0.3
            )
                pipe_radius + (
                    z_factor < 0.7
                    ? radius*z_factor*z_factor
                    : radius*(0.7*0.7 - zz_factor*zz_factor)
                );

        extrude(
            points=circle_cs_points,
            limits=[0:height/node_cs_count:height],
            scaler_fn=scaler_fn
        );
    }

    module node_6(height, pipe_radius)
    {
        node_4(height, pipe_radius);
    }

    module node_7(height)
    {
        node_2(height);
    }

    module node_8(height, pipe_radius)
    {
        node_5(height, pipe_radius);
    }

    module node_9(height, pipe_radius)
    {
        node_3(height, pipe_radius);
    }

    module node_10(height, pipe_radius)
    {
        cresent_radius = 0.5*height;

        module cresent(radius)
        {
            translate([0, 0, radius])
            rotate([90, 0, 0])
            linear_extrude(radius*0.1)
                difference()
                { 
                    circle(radius, $fn=180);
                    translate([0, 0.2*radius])
                        circle(radius, $fn=180); 
                };
        }

        union()
        {
            linear_extrude(height - 0.5*0.35*cresent_radius)
                circle(pipe_radius, $fn=180);

            cresent(cresent_radius);

            translate([0, 0, 0.2*cresent_radius])
            scale([1.5, 1.5, 1])
                node_4(0.2*cresent_radius, pipe_radius);

            translate([0, 0, 0.5*cresent_radius])
                node_3(0.8*cresent_radius, pipe_radius);

            translate([0, 0, 1.65*cresent_radius]) 
            rotate([0, 180, 0])
                cresent(0.4*cresent_radius);

            translate([0, 0, 1.65*cresent_radius])
                node_3(0.35*cresent_radius, 0.2*pipe_radius);
        }
    }

    union()
    {
        linear_extrude(node_6_offset + node_6_height)
            circle(rod_radius);

        translate([0, 0, node_6_offset + node_6_height])
        linear_extrude(rod_height - (node_6_offset + node_6_height) - (rod_height - node_9_offset))
            circle(0.5*rod_radius);

        translate([0, 0, node_9_offset])
        linear_extrude(rod_height - node_9_offset)
            circle(0.5*rod_radius);

        node_1(node_1_height);

        translate([0, 0, node_2_offset])
            node_2(node_2_height);

        translate([0, 0, node_3_offset])
            node_3(node_3_height, rod_radius);

        translate([0, 0, node_4_offset])
            node_4(node_4_height, rod_radius);

        translate([0, 0, node_5_offset])
            node_5(node_5_height, rod_radius);

        translate([0, 0, node_6_offset])
            node_6(node_6_height, rod_radius);

        translate([0, 0, node_7_offset])
            node_7(node_7_height);

        translate([0, 0, node_8_offset])
            node_8(node_8_height, 0.5*rod_radius);

        translate([0, 0, node_9_offset])
            node_9(node_9_height, 0.5*rod_radius);

        translate([0, 0, node_10_offset])
            node_10(node_10_height, 0.15*rod_radius);
    }
}


finial(
    base_radius=10,
    rod_radius=2,
    height=100,
    a_count=90,
    node_cs_count=30,
    $fn=45
);