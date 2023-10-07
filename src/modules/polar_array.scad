module polar_array(n, radius = 0)
{
    union()
    {
        for (i=[0:1:n - 1]) {
            rotate(i*(360/n))
            translate([radius, 0])
                children();
        }
    }
}


if ($preview)
{
    polar_array(n = 5, radius = 20)
        square(size = 10, center=true);
}