function gback = backDoorGraph( g, X, Y )
    nVars = length(g);
    gback = g;
    dpcp = properPossilbeCausalPaths(gback, X, Y);
    lininds = sub2ind([nVars nVars], dpcp(:, 1), dpcp(:, 2));
    gback(lininds)=0;
end
  