function [selnodes, seldomainCounts]= addSelectionNodesData(nodes,  isSelected, marg_exp, marg_obs,domainCounts, nVars)
%trash
% function seldag = addSelectionVarsData(dag, isSelected, nVars);
% for each selection variable, adds a dummy Xs->S and estimates P(S|Xs) from the marginal distributions.
nSelected = sum(isSelected);
selnodes = cell(nVars+nSelected,1);
seldomainCounts = nan(1,nVars+nSelected);
seldomainCounts(1:nVars)=domainCounts;
selnodes(1:nVars) = nodes;
selVar = nVars;
for iVar=1:nVars
    if isSelected(iVar)
        selVar = selVar+1;
        node.name = sprintf('S%d', iVar);
        node.parents = iVar;
        numStates = 2;
        node.cpt = nan(2, domainCounts(iVar));
        node.cpt(2, :) = estimateSelectionProbsMarg(marg_exp{iVar}, marg_obs{iVar});
        node.cpt(1, :)=1-node.cpt(2, :);
        nodes{selVar} = node;
        seldomainCounts(selVar)= numStates;
        selnodes{selVar} = node;
    end
end
end
