<<<<<<< HEAD
module platform (platformSize)
{
    platformSize = platformSize;
    platformHeight = 0.15*platformSize;             // Height of the platform with respect to the platformSize.
    polySize = 0.075*platformSize;                  // Size of the polygon (octagon) on the four corners of the platform
    pillarPosition = (platformSize-polySize)/2;     // Position of the center of the polygon and the pillars on each corner.
    elf = 0.35*platformSize;                        // Defines the length of the rectangular extension on the platform.
    ewf = 0.10*platformSize;                        // Defines the width of the rectangular extension on the platform
    bh = .115*platformSize;                         // Defines the height of the 'brace' around the platform.
    bt = .018*platformSize;                         // Defines the thickness of the 'brace' around the platform.
    bo = 0.005*platformSize;                        // Defines the offset of the 'brace' around the platform.
    tp = 0.015*platformSize;                        // Defines the thickness of the wall at the top of the platform.
    dh = 0.025*platformSize;                        // Defines the height of the depression on the top of the platform.
    
    
    
    
    
    module regular_polygon (order, r)
    {
        angles=[ for (i = [0:order-1]) i*(360/order)+360/(2*order) ];
        coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
        color ("gray") polygon(coords);
    }

    module platformShape (platformSize)
    {
        square(platformSize,true);
        translate ([pillarPosition,pillarPosition]) regular_polygon(8, polySize);
        translate ([pillarPosition,-pillarPosition]) regular_polygon(8, polySize);
        translate ([-pillarPosition,pillarPosition]) regular_polygon(8, polySize);
        translate ([-pillarPosition,-pillarPosition]) regular_polygon(8, polySize);

        translate ([platformSize/2,0,0]) square ([ewf, elf], center =true);

    }


    difference ()
        {
            union ()
            {
                linear_extrude (height = platformHeight) 
                    {
                        platformShape (platformSize);
                    }
                translate([0,0,bh]) 
                linear_extrude (height = bt, center =true) 
                { 
                            offset (delta= bo) platformShape (platformSize);
                }
            }

            translate([0,0,platformHeight-dh]) 
            linear_extrude (height = dh) 
                    { 
                        offset (delta=-tp) platformShape (platformSize);
                    }

            linear_extrude (height = 0.5*platformHeight, center = false) square (0.85*platformSize, center =true);
        }
}
=======
$fa=4;
$fs=5;


module regular_polygon (order, r)
{
     angles=[ for (i = [0:order-1]) i*(360/order)+360/(2*order) ];
     coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
     color ("gray") polygon(coords);
}

module platformShape (platformSize)
{

    polySize = 0.075*platformSize;
    pillarPosition = (platformSize-polySize)/2;

    square(platformSize,true);
    translate ([pillarPosition,pillarPosition]) regular_polygon(8, polySize);
    translate ([pillarPosition,-pillarPosition]) regular_polygon(8, polySize);
    translate ([-pillarPosition,pillarPosition]) regular_polygon(8, polySize);
    translate ([-pillarPosition,-pillarPosition]) regular_polygon(8, polySize);

    translate ([platformSize/2,0,0]) square ([0.10*platformSize, .35*platformSize], center =true);

}


difference ()
    {
        union ()
        {
            linear_extrude (height = 150) 
                {
                    platformShape (1000);
                }
            translate([0,0,115]) 
            linear_extrude (height = 18, center =true) 
               { 
                        offset (delta= 5) platformShape (1000);
               }
        }

        translate([0,0,125]) 
        linear_extrude (height = 26) 
                { 
                    offset (delta=-15) platformShape (1000);
                }

        linear_extrude (height = 160, center = true) square (850, center =true);

        linear_extrude (height = 800) circle (80);
    }





>>>>>>> 0f8dc16110475602fe1fd08f2c1fe52dddc57e18
