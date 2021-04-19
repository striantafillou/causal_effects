function pd = possDe(m, x, y, possible, ds)
% function pd = possDe(m, x, y, possible, ds)
% returns possible descendants on a path from x to y in the graph with
% adjacency matrix m (can be MAG/PAG)
if length(x)>1
    error('x needs to be a single variable\n');
end
if ds % only via definite status paths
    if possible
      pd = possibleDe(m, x);
    else
        error('x needs to be a single variable\n');
    end
else 
  % covers all types of graphs
  pd  = possibleDeProper(m, x, y, possible);
end

end 

