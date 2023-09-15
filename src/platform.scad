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

union ()

{
    difference ()
    {
        linear_extrude (height = 150) 
            {
                platformShape (1000);
            }

        translate([0,0,125]) 
        linear_extrude (height = 26) 
                { 
                    offset (delta=-15) platformShape (1000);
                }

        linear_extrude (height = 160, center = true) square (850, center =true);

        linear_extrude (height = 800) circle (80, center = true);


    }

    translate([0,0,115]) 
    linear_extrude (height = 18, center =true) 
           { 
                    offset (delta= 5) platformShape (1000);
           }
}



