module gothic_door(width, height)
{
    rect_height = height - width*sin(60);

    translate([0, rect_height])
    union()
    {
        intersection()
        {
            translate([-width/2, 0]) circle(width);
            translate([width/2, 0]) circle(width);
        }
        translate([-width/2, -rect_height]) square([width, rect_height]);
    }
}


gothic_door(
    width=50,
    height=100
);