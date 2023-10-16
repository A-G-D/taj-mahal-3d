use <modules/gothic_door.scad>
use <modules/extrude.scad>
use <finial.scad>


module minor_dome (mini_dome_radius, mini_dome_height)
{
    module dome_shape_circle ()
    {
        rotate_extrude(angle=360, convexity = 30, $fn = 60)
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

    module top_pattern ()
    {
        a_count=360;
        // inversefunc = function(x) (1/(x+0.9));
        linearfunc = function (x) 1-1.2*x;
        linearfunc2 = function (x) 1+0.7*x;
        n=25;
        m=0.05;
        cs_points = [for (i=[0:360/a_count:360]) [(1 + m*sin(n*i))*cos(i), (1 + m*sin(n*i))*sin(i)]];
            scale ([1, 1, 0.7])
            // extrude(points = cs_points, limits = [0:0.05 : 0.6 ], scaler_fn = inversefunc );
            extrude(points = cs_points, limits = [0 :0.005 : 0.6 ], scaler_fn = linearfunc );
            extrude(points = cs_points, limits = [0 :-0.005 : -0.15 ], scaler_fn = linearfunc2 );
    }

    module torus()
    {   
        translate([0,0, 0.42]) 
        {
            rotate_extrude(angle=360, convexity = 30, $fn = 20)
        {
        translate( [0.3,0,0]) 
        circle(r = 0.05);
        }
        }
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

        translate([0, 0, 0.94*mini_dome_height]) 
        scale(0.57*mini_dome_radius) 
        {
            top_pattern();
            torus();
        }

        translate([0,0, mini_dome_height])
        scale(.013*mini_dome_radius)  
        finial(base_radius = 10, rod_radius = 2, height = 100);
    }
}



minor_dome(mini_dome_radius =300, mini_dome_height = 1000);


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

