use <modules/extrude.scad>
use <modules/polar_array.scad>
use <minor_dome.scad>

$fn =20;

module minaret (radius, height)
{
    
    mini_dome_radius = 1.5*radius;
    mini_dome_height = 4.3*radius;
    cylinder_height = 0.75*height;

    module minaret_core (radius)    
    {
        {
            quad_func = function (x) 2*pow(x-5, 2)+1;
            horizontal_func_2 = function (x) 1.5;
            horizontal_func_1 = function (x) 1;
            a_count = 30;
            cs_points = [for (i=[0:360/a_count:360])[cos(i), sin(i)]];

            scale([radius,radius, 0.93*radius])
            difference ()
            {
                union ()
                {
                    extrude(points = cs_points, limits = [0: 0.05 : 5 ], scaler_fn = horizontal_func_1);
                    extrude(points = cs_points, limits = [5 : 0.05 : 5.5 ], scaler_fn = quad_func);
                    extrude(points = cs_points, limits = [5.5 : 0.05 : 6 ], scaler_fn = horizontal_func_2);
                    
                    polar_array(n = 20)
                    {
                    translate([1.425,0,5.5]) 
                    cube([0.1,0.13,0.6], center = false);
                    }
                }

                translate ([0, 0, 5.5])
                linear_extrude(height = 0.6)
               { 
                    difference ()
                    circle (r = 1); 
                    offset(delta = 0.35)
                    circle (r=1);
                } 
            }
        }
    }

    union() 
    {   
        scale([1,1, 0.93])
        {
            for (i=[0:cylinder_height/3:2*cylinder_height/3])
            {translate([0, 0, i]) 
            minaret_core(radius);}

            translate([0,0, 0.76*height]) 
            minor_dome(mini_dome_radius, mini_dome_height);
        }
    }
    
}


minaret(radius = 80, height = 1600);




