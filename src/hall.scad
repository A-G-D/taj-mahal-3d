use <modules/gothic_door.scad>

module hall (hall_height, hall_bounds_x, hall_bounds_y, hall_pillar_excess_height)

{
    chamfer_factor = 0.75; 
    block_width = 75 ;
    block_length = 460;
    hall_depression_height = 50;
    hall_boundary_x = hall_bounds_x/2;
    hall_boundary_y = hall_bounds_y/2;

        module hall_shape (hall_bounds_x, hall_bounds_y, chamfer_factor)
            {
                coords = [[hall_boundary_x, chamfer_factor*hall_boundary_y],
                        [hall_boundary_x, -chamfer_factor*hall_boundary_y],
                        [chamfer_factor*hall_boundary_x, -hall_boundary_y],
                        [-chamfer_factor*hall_boundary_x, -hall_boundary_y],
                        [-hall_boundary_x, -chamfer_factor*hall_boundary_y],
                        [-hall_boundary_x, chamfer_factor*hall_boundary_y],
                        [-chamfer_factor*hall_boundary_x, hall_boundary_y],
                        [chamfer_factor*hall_boundary_x, hall_boundary_y]];
                polygon(coords);
            }

        module doors (width, height)
            {
                intersection() 
                { 
                    rotate ([90,0,0])
                    linear_extrude(height = height, center= true) 
                    gothic_door(width = width, height = height);

                    
                    rotate ([90,0,90])
                    linear_extrude(height = height, center =true) 
                    gothic_door(width = width, height = height);
                }
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
                        translate ([hall_boundary_x-block_width/2, 0])
                        square(size = [block_width, block_length], center = true);

                        translate ([-hall_boundary_x+block_width/2, 0])
                        square(size = [block_width, block_length], center = true);

                        translate ([0, hall_boundary_y-block_width/2])
                        square(size = [block_length, block_width], center = true);

                        translate ([0, -hall_boundary_y+block_width/2])
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

            for (i = [0:90:360])
            {rotate([0,0,i]) 
            {   
                
                translate([hall_boundary_x,0,-0.01])
                scale ([1.5,1.6,1])
                doors(190,430);

                translate([hall_boundary_x, 0.72*block_length,240])
                scale ([1.5,1.6,1])
                doors(85,190);

                translate([hall_boundary_x, 0.72*block_length, -0.01])
                scale ([1.5,1.6,1])
                doors(85,190);

                translate([0.72*block_length,hall_boundary_y, 240])
                scale ([1.5,1.6,1])
                doors(85,190);

                translate([0.72*block_length,hall_boundary_y, -0.01])
                scale ([1.5,1.6,1])
                doors(85,190);

                translate([hall_boundary_x*(1+chamfer_factor)/2,hall_boundary_y*(1+chamfer_factor)/2, 240])
                rotate ([0,0,45])
                scale ([1.5,1.6,1])
                doors(85,190);

                translate([hall_boundary_x*(1+chamfer_factor)/2,hall_boundary_y*(1+chamfer_factor)/2, -0.01])
                rotate ([0,0,45])
                scale ([1.5,1.6,1])
                doors(85,190);
            }}

            
        }
        
}
hall (hall_height= 450, hall_bounds_x= 1200, hall_bounds_y=1200, hall_pillar_excess_height=175);
