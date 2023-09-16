
module hall (hallSize)

{
    hallSize = hallSize;        //Dimension of the side of the square hall.
    cf = 0.75;                  //chamfer factor for the corner of the square hall.
    hf = 1;                     //Ratio of the height of the wall to the hallSize.
    hhf = 1.25*hf;              // Ratio of the height of the 4 rectangular block to the height of the square hall. 
    lbf = 0.80;                 //Ratio of the length of the 4 rectangular block to the hallSize.
    tf = 0.10;                  //Ratio of the thickness the 4 rectangular block to the hallSize.
    dg = 0.05;                  //Ratio of the depth of gutter and hallSize found on the top of the hall. 

        module hallShape (hallSize, cf)
            {
                coords = [[hallSize, cf*hallSize],
                        [hallSize,-cf*hallSize],
                        [cf*hallSize,-hallSize],
                        [-cf*hallSize,-hallSize],
                        [-hallSize,-cf*hallSize],
                        [-hallSize,cf*hallSize],
                        [-cf*hallSize,hallSize],
                        [cf*hallSize,hallSize]];
                polygon(coords);
            }


        difference() 
        {
            union() 
            {
                    linear_extrude(height = hf*hallSize) 
                {
                    hallShape (hallSize, cf);
                }

                linear_extrude(height = hhf*hallSize)
                    {
                        translate ([(1-tf/2)*hallSize, 0])
                        square(size = [tf*hallSize, lbf*hallSize], center = true);

                        translate ([-(1-tf/2)*hallSize, 0])
                        square(size = [tf*hallSize, lbf*hallSize], center = true);

                        translate ([0, (1-tf/2)*hallSize])
                        square(size = [lbf*hallSize, tf*hallSize], center = true);

                        translate ([0, -(1-tf/2)*hallSize])
                        square(size = [lbf*hallSize, tf*hallSize], center = true);
                    }
            }

            translate([0, 0, (1-dg)*hallSize]) 
            {
                linear_extrude(height = dg*hallSize, center = false)
                    {
                        offset(delta = -tf*hallSize) hallShape(hallSize, cf);
                    }
            }
        }
}
