use <../utils/regular_polygon_points.scad>

module frustum(n, radius_bottom, radius_top, height)
{
    linear_extrude(height=height, scale=radius_top/radius_bottom)
        polygon(regular_polygon_points(r=radius_bottom, n=n));
}


if ($preview)
{
    frustum(
        n=4,
        radius_bottom=1,
        radius_top=0.8,
        height=0.5
    );
}