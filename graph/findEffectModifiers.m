function [em, pvals] = findEffectModifiers(x, y, obsDataset, nVars, varargin)
% find all variables that are dependent with y but not with x.
[a] = process_options(varargin, 'alpha', 0.05);

if  isequal(obsDataset.type, 'discrete');
    test ='g2test_2';
end
covs = setdiff(1:nVars, [x, y]);
pvals = nan(2, nVars);
for iVar=covs
    [pvals(1, iVar), s, exitflag] = feval(test, iVar, y, [], obsDataset); 
    [pvals(2, iVar), s, exitflag] = feval(test, iVar, x, [], obsDataset);
end

em = find(pvals(1, :)<a & pvals(2, :)>a);

end

  