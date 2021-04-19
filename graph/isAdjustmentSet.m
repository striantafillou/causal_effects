function bool  = isAdjustmentSet(x, y, z, dag)
allDesc_G = transitiveClosureSparse_mex(sparse(dag));
% nVars = size(dag, 1);
% allDesc_G(1:nVars:nVars^2) =true;
if allDesc_G(x, y)==0
    bool=false;
    return;
end
[pcp, pbdg] = getProperBackDoorGraph(dag, x, y);
[~, dpcp] = find(allDesc_G(pcp,:));
if any(ismember(z, union(dpcp, pcp)))
    bool = false;
    return
end
isAnc = transitiveClosureSparse_mex(sparse(pbdg));
sepnodes= finddseparations(pbdg, x, z, isAnc);
bool=ismember(y, sepnodes);
end