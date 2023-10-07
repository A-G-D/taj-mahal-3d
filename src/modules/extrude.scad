function zip(list_a, list_b) =
    [for (i=[0:len(list_a) - 1]) each [list_a[i], list_b[i]]];

function rotate_axes(xy, theta) =
    [xy[0]*cos(theta) + xy[1]*sin(theta), -xy[0]*sin(theta) + xy[1]*cos(theta)];

/**
    @param points - cross section points
    @param path - extrusion path points (NYI)
    @param limits - extrusion length limits
    @param scaler_fn - scaler function that returns the cross-sectional scaling factor based on the current extrusion length
    @param twister_fn - scaler function that returns the cross-sectional rotation angle based on the current extrusion length
*/
module extrude(
    points,
    path=[],
    limits,
    scaler_fn=function (z) 1,
    twister_fn=function (z) 0
)
{
    cs_points_count = len(points);
    cs_layers = is_list(limits) ? len(limits) : (limits[2] - limits[0])/limits[1] + 1;

    cs_points =
        [for (i=limits)
            each [for (j=[0:cs_points_count - 1])
                [
                    rotate_axes(points[j], twister_fn(i))[0]*scaler_fn(i),
                    rotate_axes(points[j], twister_fn(i))[1]*scaler_fn(i),
                    i
                ]
            ]
        ];

    faces =
        concat(
            [for (i=[0:cs_layers - 2])
                each concat(
                    [for (j=[0:cs_points_count - 2])
                        [
                            (i + 1)*cs_points_count + (j + 0),
                            (i + 1)*cs_points_count + (j + 1),
                            (i + 0)*cs_points_count + (j + 1),
                            (i + 0)*cs_points_count + (j + 0)
                        ]
                    ],
                    [[
                        (i + 1)*cs_points_count + (cs_points_count - 1),
                        (i + 1)*cs_points_count + 0,
                        (i + 0)*cs_points_count + 0,
                        (i + 0)*cs_points_count + (cs_points_count - 1)
                    ]]
                )
            ],
            [[for (i=[0:cs_points_count - 1])
                cs_points_count*0 + i
            ]],
            [[for (i=[cs_points_count - 1:-1:0])
                cs_points_count*(cs_layers - 1) + i
            ]]
        );

    polyhedron(
        points=cs_points,
        faces=faces
    );
}


// Examples

function regular_polygon_points(r, s, a_offset = 0) =
    [for (i=[0:1:s - 1]) [r*cos(a_offset + i*(360/s)), r*sin(a_offset + i*(360/s))]];

limits=[0:1:500];
a_count = 720;
radius = 100;

star_points = 3;
outer_star_polygon_points = regular_polygon_points(
    r=radius,
    s=star_points
);
inner_star_polygon_points = regular_polygon_points(
    r=0.75*radius,
    s=star_points,
    a_offset=(360/star_points)/2
);
star_polygon_points = zip(outer_star_polygon_points, inner_star_polygon_points);

cs_points = [for (i=[0:1:360]) [(100 + 2*sin(i*36))*cos(i), (100 + 2*sin(i*36))*sin(i)]];

scaler_fn = function (z) 1 + 500/(0.8*(z + 100));
twister_fn = function (z) (1 - z/limits[2])*180;
path = [];

translate([1000, 0, 0])
extrude(
    // path=[],
    points=star_polygon_points,
    limits=limits,
    scaler_fn=scaler_fn,
    twister_fn=twister_fn
);

translate([-1000, 0, 0])
extrude(
    // path=[],
    points=cs_points,
    limits=limits,
    scaler_fn=scaler_fn,
    twister_fn=twister_fn
);