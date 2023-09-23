use <modules/gothic_door.scad>


module minor_dome (mini_dome_radius, mini_dome_height)
{
    module dome_shape_circle ()
    {
        rotate_extrude(angle=360, convexity = 30, $fn = 50)
        {
            difference ()
            {
                translate (0.75*mini_dome_radius*[-0.1, 0.3, 0])
                {circle (0.75*mini_dome_radius);}

                polygon (0.75*mini_dome_radius*[[0, 0],
                        [0, 3.1],
                        [-1.1, 3.1],
                        [-1.1, -3.11],
                        [1, -3.11],
                        [1, 0]]);
            }
        }
    }

    module top_block (mini_dome_radius)
    {
        rotate_extrude(angle=360, convexity = 30, $fn = 8)
        polygon([[0, 0.58* mini_dome_radius],
                [0.76*mini_dome_radius, 0.58*mini_dome_radius],
                [0.76*mini_dome_radius, 0.36*mini_dome_radius],
                [0.96*mini_dome_radius, 0.18*mini_dome_radius],
                [mini_dome_radius, 0],
                [0, 0]]);
    }

    module minor_dome_pillars ()
    {

        difference() 

        {       
            rotate ([0,0,30])
            cylinder(h = mini_dome_height-1.955*mini_dome_radius, r1 = 0.64*mini_dome_radius, r2 = 0.67*mini_dome_radius, $fn =100);
            
            rotate ([90,0,0])
            linear_extrude(height = 2*mini_dome_radius, center =true)
            gothic_door(0.40*mini_dome_radius, 0.9*(mini_dome_height-1.955*mini_dome_radius));

            rotate ([90,0,60])
            linear_extrude(height = 2*mini_dome_radius, center =true)
            gothic_door(0.40*mini_dome_radius, 0.9*(mini_dome_height-1.955*mini_dome_radius));

            rotate ([90,0,120])
            linear_extrude(height = 2*mini_dome_radius, center =true)
            gothic_door(0.40*mini_dome_radius, 0.9*(mini_dome_height-1.955*mini_dome_radius));
            
        }

    }

        module bottom_block ()
    {
        rotate_extrude(angle=360, convexity = 30, $fn = 8)
        polygon([[0,0],
                [0,0.4*mini_dome_radius],
                [0.75*mini_dome_radius, 0.4*mini_dome_radius],
                [0.72*mini_dome_radius,0.2*mini_dome_radius],
                [0.72*mini_dome_radius,0]]);    
    }


    union ()
    {   
        translate([0,0,mini_dome_height-0.975*mini_dome_radius])
        dome_shape_circle(); 

        translate([0,0,mini_dome_height-1.555*mini_dome_radius])
        top_block(mini_dome_radius);

        translate([0,0,0.4*mini_dome_radius])
        minor_dome_pillars();

        bottom_block();
    }
}



minor_dome(mini_dome_radius = 400, mini_dome_height = 1300);




// dome using elliptical equation.

// module dome_shape_ellipse (0.75*mini_dome_radius)  
// {
//         rotate_extrude(angle=360, convexity = 30)
//         translate([2, 0, 0])
//         {
//         coords=[ for (i = [0:0.02:11.024]) [0.75*mini_dome_radius*((75*(1-(i-4)^2/50))^0.5 -1), i*0.75*mini_dome_radius] ];
//         polygon (coords);
//         echo (coords);
//         polygon ([[0, 0],[11.024*0.75*mini_dome_radius, 0],[6.14143*0.75*mini_dome_radius, 0]]);
//         }
        
// }

