use <vec3.scad>

function fillet_edge(p_prev, p_curr, p_next, radius) =
    let
    (
        e1 = vec3_difference(p_curr, p_prev),
        e2 = vec3_difference(p_next, p_curr),
        e1_dir = vec3_normalized(e1),
        e2_dir = vec3_normalized(e2),
        half_comp_angle = (180 - vec3_angle_between(e1, e2))/2,
        curr_offset = radius/tan(half_comp_angle),
        v1 = vec3_difference(p_curr, vec3_scaled(e1_dir, curr_offset)),
        v2 = vec3_sum([p_curr, vec3_scaled(e2_dir, curr_offset)]),
        ortho = vec3_normalized(vec3_vector_product(e1, e2)),
        v1_rc_dir = vec3_normalized(vec3_vector_product(ortho, e1_dir)),
        v2_rc_dir = vec3_normalized(vec3_vector_product(ortho, e2_dir)),
        v1_rc = vec3_scaled(v1_rc_dir, radius),
        o = vec3_sum([v2, vec3_scaled(v2_rc_dir, radius)]),
        angle = vec3_angle_between(v1_rc_dir, v2_rc_dir)
    )
        [for (i=[0:1:angle]) vec3_difference(o, vec3_rotated(v=v1_rc, axis=ortho, deg=i))];

function fillet_points(points, fillet_radius) =
    let
    (
        points_3d = [for (p=points) [p.x, p.y, is_undef(p.z) ? 0 : p.z]],
        cyclic_points = concat([points_3d[len(points_3d) - 1]], points_3d, [points_3d[0]])
    )
        [for (i=[1:1:len(cyclic_points) - 2])
            each fillet_edge(
                cyclic_points[i - 1],
                cyclic_points[i],
                cyclic_points[i + 1],
                fillet_radius
            )
        ];


use <../modules/show_points.scad>
use <regular_polygon_points.scad>

function zip(list_a, list_b) =
    [for (i=[0:len(list_a) - 1]) each [list_a[i], list_b[i]]];

polygon_vertices = 7;
outer_polygon_radius = 20;
inner_polygon_radius = 10;
fillet_radius = 2;

outer_polygon_points = regular_polygon_points(outer_polygon_radius, polygon_vertices);
inner_polygon_points = regular_polygon_points(inner_polygon_radius, polygon_vertices, a_offset=360/(polygon_vertices*2));
star_points = zip(outer_polygon_points, inner_polygon_points);
filleted_star_points = fillet_points(star_points, fillet_radius);
polygon(points=[for (p=filleted_star_points) [p.x, p.y]]);