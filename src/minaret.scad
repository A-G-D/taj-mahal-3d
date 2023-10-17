use <modules/extrude.scad>
use <modules/polar_array.scad>
use <minor_dome.scad>

$fn =20;

module minaret (minaret_radius, minaret_height)
{
    
    mini_dome_radius = 1.5*minaret_radius;
    mini_dome_height = 4.3*minaret_radius;
    cylinder_height = 0.75*minaret_height;

    module minaret_core (minaret_radius)    
    {
        {
            quad_func = function (x) 2*pow(x-5, 2)+1;
            horizontal_func_2 = function (x) 1.5;
            horizontal_func_1 = function (x) 1;
            a_count = 30;
            cs_points = [for (i=[0:360/a_count:360])[cos(i), sin(i)]];

            scale([minaret_radius,minaret_radius, 0.93*minaret_radius])
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
            minaret_core(minaret_radius);}

            translate([0,0, 0.76*minaret_height]) 
            minor_dome(mini_dome_radius, mini_dome_height);
        }
    }
    
}


minaret(minaret_radius = 80, minaret_height = 1600);




