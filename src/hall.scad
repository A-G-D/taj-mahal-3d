
module hallShape (hallSize, cF)
{
    coords = [[hallSize, cF*hallSize],
            [hallSize,-cF*hallSize],
            [cF*hallSize,-hallSize],
            [-cF*hallSize,-hallSize],
            [-hallSize,-cF*hallSize],
            [-hallSize,cF*hallSize],
            [-cF*hallSize,hallSize],
            [cF*hallSize,hallSize]];
    polygon(coords);
}


hallSize = 500;
cF = 0.68506;

difference() 
{
    union() 
    {
            linear_extrude(height = 0.8*hallSize) 
        {
            hallShape (hallSize, cF);
        }

        linear_extrude(height = 0.97*hallSize)
            {
                translate ([0.9375*hallSize, 0])
                square(size = [0.125*hallSize,cF*hallSize], center = true);

                translate ([-0.9375*hallSize, 0])
                square(size = [0.125*hallSize, cF*hallSize], center = true);

                translate ([0, 0.9375*hallSize])
                square(size = [cF*hallSize, 0.125*hallSize], center = true);

                translate ([0, -0.9375*hallSize])
                square(size = [cF*hallSize, 0.125*hallSize], center = true);
            }
    }

    translate([0, 0, 0.8*hallSize]) 
    {
        linear_extrude(height = 0.15*hallSize, center = true)
            {
                offset(delta = -0.15*hallSize) hallShape(hallSize, cF);
            }
    }
}

