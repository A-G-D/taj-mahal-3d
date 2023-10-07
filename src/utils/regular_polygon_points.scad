function regular_polygon_points(r, n, a_offset = 0) =
    [for (i=[0:1:n - 1]) let (a = a_offset + i*(360/n)) [r*cos(a), r*sin(a)]];