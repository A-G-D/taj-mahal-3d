function merge_ranges(ranges) =
    [for (range=ranges) each [for (i=range) i]];