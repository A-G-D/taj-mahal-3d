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

    cs_points_matrix =
        [for (i=limits)
            let
            (
                twist = twister_fn(i),
                scale_f = scaler_fn(i),
                scale_v = is_list(scale_f) ? scale_f : scale_f == 0 ? scale_f : [scale_f, scale_f]
            )
                scale_v == 0
                    ? [[0, 0, i]]
                    : [for (j=[0:cs_points_count - 1])
                        let
                        (
                            uv = rotate_axes(points[j], twist)
                        )
                        [uv[0]*scale_v[0], uv[1]*scale_v[1], i]
                    ]
        ];
    cs_points_array = [for (points_array=cs_points_matrix) each points_array];

    cs_points_indices =
        [for (i = 0, i_offset = 0; i < len(cs_points_matrix); i_offset = i_offset + len(cs_points_matrix[i]), i = i + 1)
            [for (j = 0; j < len(cs_points_matrix[i]); j = j + 1) i_offset + j]
        ];

    pointed_bot = len(cs_points_matrix[0]) == 1;
    pointed_top = len(cs_points_matrix[len(cs_points_matrix) - 1]) == 1;

    function reversed(list) =
        [for (i=[len(list) - 1:-1:0]) list[i]];

    function fill_and_zip(list, new_length) =
        let
        (
            length = len(list),
            fill_n = new_length - length,
            filler = [for (i=[0:1:length]) list[i]]
        )
            zip(list, filler);

    function cyclic(list) =
        concat(list, [list[0]]);

    function get_faces(points_bot, points_top) =
        let
        (
            bot_n = len(points_bot),
            top_n = len(points_top),
            cyclic_points_bot = cyclic(points_bot),
            cyclic_points_top = cyclic(points_top),
            normalized_points_bot = bot_n < top_n
                ? cyclic(fill_and_zip(points_bot, top_n))
                : cyclic_points_bot,
            normalized_points_top = top_n < bot_n
                ? cyclic(fill_and_zip(points_top, bot_n))
                : cyclic_points_top
        )
            bot_n == 1
            ? [for (i=[0:len(normalized_points_top) - 2])
                [
                    normalized_points_top[i],
                    normalized_points_top[i + 1],
                    points_bot[0]
                ]
            ]
            : top_n == 1
            ? [for (i=[0:len(normalized_points_bot) - 2])
                [
                    points_top[0],
                    normalized_points_bot[i + 1],
                    normalized_points_bot[i]
                ]
            ]
            : [for (i=[0:len(normalized_points_top) - 2])
                [
                    normalized_points_top[i],
                    normalized_points_top[i + 1],
                    normalized_points_bot[i + 1],
                    normalized_points_bot[i],
                ]
            ];

    lateral_faces = [for (i=[0:len(cs_points_indices) - 2])
        each get_faces(
            cs_points_indices[i],
            cs_points_indices[i + 1]
        )
    ];
    faces_with_bottom = pointed_bot
        ? lateral_faces
        : concat(
            lateral_faces,
            [cs_points_indices[0]]
        );
    faces = pointed_top
        ? faces_with_bottom
        : concat(
            faces_with_bottom,
            [reversed(cs_points_indices[len(cs_points_indices) - 1])]
        );

    polyhedron(
        points=cs_points_array,
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

cs_points = [for (i=[0:360/a_count:360]) [(100 + 2*sin(i*36))*cos(i), (100 + 2*sin(i*36))*sin(i)]];

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