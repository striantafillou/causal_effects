function colliders = findCollidersmcg(smm)
% finds all colliders in mcg smm

nVars = size(smm,1);
colliders=[];
for iVar=1:nVars
    intoV = find(smm(:, iVar)==2|smm(:, iVar)==4);
    colliderEnds = nchoosek(intoV, 2);
    nCols= size(colliderEnds,1);
    colliders = [colliders; [colliderEnds(:, 1) iVar*ones(nCols, 1) colliderEnds(:, 2)]];
end