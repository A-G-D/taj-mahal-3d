module hall (hall_height, hall_bounds_x, hall_bounds_y, hall_pillar_excess_height)

{
    chamfer_factor = 0.70; 
    block_width = 150 ;
    block_length = 800;
    hall_depression_height = 100;

        module hall_shape (hall_bounds_x, hall_bounds_y, chamfer_factor)
            {
                coords = [[hall_bounds_x, chamfer_factor*hall_bounds_y],
                        [hall_bounds_x, -chamfer_factor*hall_bounds_y],
                        [chamfer_factor*hall_bounds_x, -hall_bounds_y],
                        [-chamfer_factor*hall_bounds_x, -hall_bounds_y],
                        [-hall_bounds_x, -chamfer_factor*hall_bounds_y],
                        [-hall_bounds_x, chamfer_factor*hall_bounds_y],
                        [-chamfer_factor*hall_bounds_x, hall_bounds_y],
                        [chamfer_factor*hall_bounds_x, hall_bounds_y]];
                polygon(coords);
            }


        difference() 
        {
            union() 
            {
                    linear_extrude(height = hall_height + hall_depression_height) 
                {
                    hall_shape (hall_bounds_x, hall_bounds_y, chamfer_factor);
                }

                linear_extrude(height = hall_height + hall_pillar_excess_height)
                    {
                        translate ([hall_bounds_x-block_width/2, 0])
                        square(size = [block_width, block_length], center = true);

                        translate ([-hall_bounds_x+block_width/2, 0])
                        square(size = [block_width, block_length], center = true);

                        translate ([0, hall_bounds_y-block_width/2])
                        square(size = [block_length, block_width], center = true);

                        translate ([0, -hall_bounds_y+block_width/2])
                        square(size = [block_length, block_width], center = true);
                    }
            }

            translate([0, 0, hall_height]) 
            {
                linear_extrude(height = hall_depression_height, center = false)
                    {
                        offset(delta = -1.2*block_width) hall_shape(hall_bounds_x, hall_bounds_y, chamfer_factor);
                    }
            }
        }
}
