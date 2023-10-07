module show_points(points, size=1)
{
    union()
    {
        for (p=points) translate(p) sphere(size);
    }
}