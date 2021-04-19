function [allsets, nAllSets] = allSubsets(nVars, keepVars)
% returns all sets for nVars-2 (1 is treatment, 2 is outcome).
nObs = length(keepVars);
nAllSets =2^(nObs);    
setmembers = false(2^(nObs), nObs);
for iSet=0:2^(nObs)-1
    setmembers(iSet+1, :)= bitand(iSet,2.^(0:nObs-1));
end
allsets = false(nAllSets, nVars);
allsets(:, keepVars) = setmembers;
end
%setmembers = [zeros(nAllSets, 2) setmembers];


% 
% nAllSets =2^(nVars-2);    
% setmembers = false(2^(nVars-2), nVars-2);
% for iSet=0:2^(nVars-2)-1
%     setmembers(iSet+1, :)= bitand(iSet,2.^(0:nVars-2-1));
% end
% setmembers = [zeros(nAllSets, 2) setmembers];