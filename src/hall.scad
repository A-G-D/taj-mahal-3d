use <modules/gothic_door.scad>
use <modules/polar_array.scad>
use <pillar.scad>

module hall (hall_height, hall_bounds_x, hall_bounds_y, hall_pillar_excess_height)

{
    chamfer_factor = 0.75; 
    block_width = 75 ;
    block_length = 620;
    hall_depression_height = 50;
    hall_boundary_x = hall_bounds_x/2;
    hall_boundary_y = hall_bounds_y/2;
    pillar_height1 = 1200;
    pillar_height2 = 1000;
    pillar_radius = 12;
    main_door_width = 250;
    main_door_height = 590;
    mini_door_width = 120;
    mini_door_height = 270;

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
                scale ([1.5,1.6,1]) 
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

        module door_frame(width, height)
            {        
                    rotate([90,0,0]) 
                    linear_extrude(height = 0.2*mini_door_width, center =true) 
                {
                    difference() 
                    {
                        square([width, height], center =true);
                        offset(delta = -0.1*mini_door_width) 
                        square([width, height], center =true);
                    }                    
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
                            
                    polar_array(n = 4, radius =0) 
                            {
                                translate([hall_boundary_x, (block_length)/2]) 
                                pillar(height = pillar_height1, radius = pillar_radius);

                                translate([(block_length)/2, hall_boundary_y]) 
                                pillar(height = pillar_height1, radius = pillar_radius);

                                translate([chamfer_factor*hall_boundary_x, hall_boundary_y]) 
                                pillar(height = pillar_height2, radius = pillar_radius);

                                translate([hall_boundary_x, chamfer_factor*hall_boundary_y ]) 
                                pillar(height = pillar_height2, radius = pillar_radius);

                                translate([0, hall_boundary_y, main_door_height/2.1]) 
                                door_frame(main_door_width*2, main_door_height*1.2);

                                translate([(block_length/2 + (chamfer_factor*hall_boundary_y-block_length/2)/2), hall_boundary_y, mini_door_height/2.1]) 
                                door_frame(mini_door_width*2, mini_door_height*1.2);

                                translate([(block_length/2 + (chamfer_factor*hall_boundary_y-block_length/2)/2), hall_boundary_y, mini_door_height/2.1+340]) 
                                door_frame(mini_door_width*2, mini_door_height*1.2);

                                translate([hall_boundary_x, (block_length/2  + (chamfer_factor*hall_boundary_x-block_length/2)/2), mini_door_height/2.1]) 
                                rotate([0, 0, 90]) 
                                door_frame(mini_door_width*2, mini_door_height*1.2);

                                translate([hall_boundary_x, (block_length/2  + (chamfer_factor*hall_boundary_x-block_length/2)/2), mini_door_height/2.1+340]) 
                                rotate([0, 0, 90]) 
                                door_frame(mini_door_width*2, mini_door_height*1.2);

                                translate([hall_boundary_x*(1+chamfer_factor)/2,hall_boundary_y*(1+chamfer_factor)/2, mini_door_height/2.1])
                                rotate ([0,0,135])
                                door_frame(mini_door_width*2, mini_door_height*1.2);

                                translate([hall_boundary_x*(1+chamfer_factor)/2,hall_boundary_y*(1+chamfer_factor)/2, mini_door_height/2.1+340])
                                rotate ([0,0,135])
                                door_frame(mini_door_width*2, mini_door_height*1.2);

                                linear_extrude(height = hall_height + hall_pillar_excess_height)
                                    {
                                        translate ([hall_boundary_x-block_width/2, 0])
                                        square(size = [block_width, block_length], center = true);
                                    }
                            }
                }

            translate([0, 0, hall_height]) 
                {
                    linear_extrude(height = hall_depression_height, center = false)
                        {
                            offset(delta = -1.2*block_width) hall_shape(hall_bounds_x, hall_bounds_y, chamfer_factor);
                        }
                }
            
            polar_array(n = 4, radius =0)
                {   
                    
                    {
                        translate([hall_boundary_x,0, 1])
                        doors(main_door_width, main_door_height);

                        translate([hall_boundary_x, (block_length/2 + (chamfer_factor*hall_boundary_y-block_length/2)/2) ,340])
                        doors(mini_door_width,mini_door_height);

                        translate([hall_boundary_x, (block_length/2 + (chamfer_factor*hall_boundary_y-block_length/2)/2), -1])
                        doors(mini_door_width,mini_door_height);

                        translate([(block_length/2 + (chamfer_factor*hall_boundary_x-block_length/2)/2),hall_boundary_y, 340])
                        doors(mini_door_width,mini_door_height);

                        translate([(block_length/2 + (chamfer_factor*hall_boundary_x-block_length/2)/2),hall_boundary_y, -1])
                        doors(mini_door_width,mini_door_height);
                        
                        {
                            translate([hall_boundary_x*(1+chamfer_factor)/2,hall_boundary_y*(1+chamfer_factor)/2, 340])
                            rotate ([0,0,45])
                            doors(mini_door_width,mini_door_height);

                            translate([hall_boundary_x*(1+chamfer_factor)/2,hall_boundary_y*(1+chamfer_factor)/2, -1])
                            rotate ([0,0,45])
                            doors(mini_door_width,mini_door_height);
                        }
                    }
                }

            translate([0, 0, -0.5*main_door_height]) 
                { 
                    linear_extrude(height = 0.5*main_door_height)
                    square(3*[hall_bounds_x, hall_bounds_y], center = true);
                }

        }
        
}
render()
hall (hall_height= 700, hall_bounds_x= 1800, hall_bounds_y=1800, hall_pillar_excess_height=200);
