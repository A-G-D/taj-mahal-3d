/*
*   vec3.scad
*
*   3D vector utilities lib
*
*   API:
*
*       function vec3_create(x, y, z)
*           - creates a new vector (kinda useless, I know)
*       function vec3_copy(v)
*           - creates a copy of the input vector <v>
*       function vec3_sum(vv)
*           - creates a resultant vector from the array of vectors <vv>
*       function vec3_difference(v, w)
*           - creates a vector equal to <v> subtracted by <w>
*       function vec3_scaled(v, factor)
*           - creates a vector with the same unit vector as <v> but whose length
*             is multiplied by <factor>
*       function vec3_scaled(v, v_factor = [x_scale, y_scale, z_scale])
*           - creates a vector based on <v> whose x-y-z components are
*             multiplied by x_scale, y_scale, and z_scale, respectively
*       function vec3_rotated(v, axis = [0, 0, 1], deg)
*           - creates a vector equal to <v> rotated around the axis vector <axis>
*             by <deg> degrees
*       function vec3_normalized(v)
*           - returns the unit vector of <v> as a new vector
*       function vec3_inverted(v)
*           - creates a negative vector of <v>
*       function vec3_null()
*           - creates a zero vector [0, 0, 0] (kinda useless too)
*
*       function vec3_square(v)
*           - returns the square of the magnitude of the given vector
*       function vec3_length(v)
*           - returns the magnitude of the given vector
*       function vec3_angle_between(v, w)
*           - returns the angle between <v> and <w> in degrees
*
*       function vec3_scalar_product(v, w)
*           - returns the dot product of <v> and <w>
*       function vec3_vector_product(v, w)
*           - creates a new vector equal to the cross product of <v> and <w>
*       function vec3_scalar_triple_product(v, w, x)
*           - returns <v X w . x>
*       function vec3_vector_triple_product(v, w, x)
*           - creates a new vector equal to <v X w X x>
*
*       function vec3_vector_projection(v, axis)
*           - creates a new vector equal to the projection of vector <v> along
*             the axis vector <axis>
*       function vec3_plane_projection(v, normal)
*           - creates a new vector equal to the projection of vector <v> to
*             the plane surface represented by the normal vector <normal>
*/
function vec3_create(x, y, z) = [x, y, z];

function vec3_copy(v) = [v.x, v.y, v.z];

function vec3_sum(vv) =
    (is_undef(vv) || len(vv) == 0)? [0, 0, 0] :
    (len(vv) == 1)? vv[0] :
        let (ps = vec3_sum([for (n = [1:1:len(vv) - 1]) vv[n]]))
            [
                vv[0].x + ps.x,
                vv[0].y + ps.y,
                vv[0].z + ps.z
            ];

function vec3_difference(v, w) =
    [
        v.x - w.x,
        v.y - w.y,
        v.z - w.z
    ];

function vec3_scaled(v, factor = undef, v_factor = undef) =
    [
        (is_undef(factor)? v_factor.x : factor)*v.x,
        (is_undef(factor)? v_factor.y : factor)*v.y,
        (is_undef(factor)? v_factor.z : factor)*v.z
    ];

function vec3_rotated(v, axis = [0, 0, 1], deg) =
    let(
        proj = vec3_vector_projection(v, axis),
        x = vec3_difference(v, proj)
    )
        vec3_sum([
            vec3_scaled(x, cos(deg)),
            vec3_scaled(
                vec3_vector_product(axis, x),
                sin(deg)/vec3_length(axis)
            ),
            proj
        ]);

function vec3_normalized(v) = vec3_scaled(v, 1/vec3_length(v));

function vec3_inverted(v) = vec3_scaled(v, -1);

function vec3_null() = [0, 0, 0];

function vec3_square(v) = v.x*v.x + v.y*v.y + v.z*v.z;

function vec3_length(v) = sqrt(vec3_square(v));

function vec3_angle_between(v, w) =
    acos(vec3_scalar_product(v, w)/(vec3_length(v)*vec3_length(w)));

function vec3_scalar_product(v, w) = v.x*w.x + v.y*w.y + v.z*w.z;

function vec3_vector_product(v, w) =
    [
        v.y*w.z - v.z*w.y,
        v.z*w.x - v.x*w.z,
        v.x*w.y - v.y*w.x
    ];

function vec3_scalar_triple_product(v, w, x) =
    vec3_scalar_product(vec3_vector_product(v, w), x);

function vec3_vector_triple_product(v, w, x) =
    vec3_difference(
        vec3_scaled(w, vec3_scalar_product(v, x)),
        vec3_scaled(x, vec3_scalar_product(v, w))
    );

function vec3_vector_projection(v, axis) =
    vec3_scaled(axis, vec3_scalar_product(v, axis)/vec3_square(axis));

function vec3_plane_projection(v, normal) =
    vec3_difference(
        vec3_scalar_product(v, axis)/vec3_square(axis),
        vec3_scaled(normal, sq)
    );

/*
*   Unit tests
*/
// Sum
s = vec3_sum([
    [0, 1, 0],
    [0, 0, 1],
    [2, 3, 4],
    [1, 3, 5]
]);

echo(s.x);
echo(s.y);
echo(s.z);