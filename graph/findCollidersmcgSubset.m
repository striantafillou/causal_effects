function [colliders, colliderNodes] = findCollidersmcgSubset(smm, vars)
% finds all colliders in mcg smm for subset of variables vars
nVars = size(smm,1);

if nargin ==1
    vars =1:nVars;
else
    vars = reshape(vars, 1, []);
end
isvar = false(nVars, 1); isvar(vars)=true;
colliders=[];
colliderNodes =[];
for iVar=vars
    intoV = smm(:, iVar)==2|smm(:, iVar)==4;
    intoV =  find(intoV&isvar);
    fprintf('V: %d, intoV:[%s]\n', iVar, num2str(intoV))
    if length(intoV)<=1
        continue;
    end
    colliderNodes =[colliderNodes iVar];
    colliderEnds = nchoosek(intoV, 2);
    nCols= size(colliderEnds,1);
    colliders = [colliders; [colliderEnds(:, 1) iVar*ones(nCols, 1) colliderEnds(:, 2)]];
end