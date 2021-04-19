function set = findMinAdjSet(dag, x, y, nVars)
% set = findMinAdjSet(dag, x, y, nVars) 
% finds the constructive adjustment set for x adn y in DAG dag

% make gpbg
allDesc_G = transitiveClosureSparse_mex(sparse(dag));
allDesc_G(1:nVars+1:nVars^2)=1;
if allDesc_G(x, y)==0
    bool=false;
    return;
end
[pcp, pbdg] = getProperBackDoorGraph(dag, x, y);
[~, dpcp] = find(allDesc_G(pcp,:));
isAnc = transitiveClosureSparse_mex(sparse(pbdg));

% construct Z=R\[X. Y]
%isAnc = transitiveClosureSparse_mex(sparse(dag)); should be the
anXY = find(isAnc(:, x)|isAnc(:, y));
% one adjustment set is An_xy\{x, y, DPCP}
forb = union([x y], dpcp);
z = setdiff(anXY, forb)';
if ~isadjset(x, y, z, pbdg,dpcp, isAnc)
    set=-1;
else, set=z;
end

for U = z
    z = setdiff(z, U)';
    if isadjset(x, y, z, pbdg, dpcp, isAnc)
        set=z;
    end
end

end

