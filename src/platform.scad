module platform (platform_bounds_x, platform_bounds_y, platform_thickness, octagon_size )
{   
    octagon_position_x = (platform_bounds_x - octagon_size)/2;           // Position of the center of the polygon and the pillars on each corner.
    octagon_position_y = (platform_bounds_y - octagon_size)/2;
    extension_length = 0.50*(platform_bounds_y-2*octagon_size) ;         // Defines the length of the rectangular extension on the platform.
    extension_width = 0.10 * (platform_bounds_x-2*octagon_size);         // Defines the width of the rectangular extension on the platform
    brace_position_z = 130;                                              // Defines the height of the 'brace' around the platform.
    brace_thickness = 18;                                                // Defines the thickness of the 'brace' around the platform.
    brace_offset = 5;                                                    // Defines the offset of the 'brace' around the platform.
    top_wall_thickness = 30;                                             // Defines the thickness of the wall at the top of the platform.
    depression_height = 20;                                              // Defines the height of the depression on the top of the platform.
    
    
    
    module regular_polygon (order, r)
    {
        angles=[ for (i = [0:order-1]) i*(360/order)+360/(2*order) ];
        coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
        polygon(coords);
    }

    module platform_shape (platform_bounds_x, platform_bounds_y)
    {
        square([platform_bounds_x, platform_bounds_y], center = true);
        translate ([octagon_position_x,octagon_position_y]) regular_polygon(8, octagon_size);
        translate ([octagon_position_x,-octagon_position_y]) regular_polygon(8, octagon_size);
        translate ([-octagon_position_x,octagon_position_y]) regular_polygon(8, octagon_size);
        translate ([-octagon_position_x,-octagon_position_y]) regular_polygon(8, octagon_size);

        translate ([platform_bounds_x/2, 0, 0]) square ([extension_width, extension_length], true);

    }


    difference ()
        {
            union ()
            {
                linear_extrude (height = platform_thickness+depression_height) 
                    {
                        platform_shape (platform_bounds_x, platform_bounds_y);
                    }
                translate([0,0,brace_position_z]) 
                linear_extrude (height = brace_thickness, center =true) 
                { 
                            offset (delta= brace_offset) platform_shape (platform_bounds_x, platform_bounds_y);
                }
            }

            translate([0,0,platform_thickness]) 
            linear_extrude (height = depression_height) 
                    { 
                        offset (delta=-top_wall_thickness) platform_shape (platform_bounds_x, platform_bounds_y);
                    }

            linear_extrude (height = 0.5*platform_thickness) square ([0.85*platform_bounds_x, 0.85*platform_bounds_y], true);
        }
}

platform(platform_bounds_x = 1000, platform_bounds_y = 1000, platform_thickness = 200, octagon_size = 75);