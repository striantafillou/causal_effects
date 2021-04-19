function bool =isadjset(x, y, z, pbdg, dpcp, isAnc)

if any(ismember(z, dpcp))
    bool = false;
    return
end
sepnodes= finddseparations(pbdg,x, z, isAnc);
bool=ismember(y, sepnodes);
end