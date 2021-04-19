function [snodes, sdomainCounts] = estimateSelNodes(selvars, psels, jtalg, nVars, domainCounts)
%[snodes, sdomainCounts] = estimateSelNodes(selvars, psels, jtalg, nVars, domainCounts)
% estimates P(S|Xs) for every Xs in selvars, using the constraints in lines 3-5 in Alg. 3 of 
%"Learning adjustment sets using observational and limited experimental
%data".
    nSelVars = length(selvars);
    sdomainCounts = 2*ones(1, nSelVars);
    snodes = cell(nSelVars,1);
    maxDc = max(domainCounts(selvars));
    x0 = rand(nSelVars, maxDc);
    
    pv =reshape(estimateJointProbJT(selvars,  jtalg, nVars,domainCounts),  1, []);
    %distFromZero(true_x, pv, selvars, domainCounts, psels)
    options = optimoptions('fmincon','Display','off');
    x = fmincon(@(x) distFromZero(x, pv, selvars, domainCounts, psels), rand(size(x0)),[],[], [], [], zeros(size(x0)), ones(size(x0)),[], options);
    for iV=1:nSelVars
        curV = selvars(iV); snodes{iV}.cpt(2, :) = x(iV, 1:domainCounts(curV));
        snodes{iV}.cpt(1, :)=1-snodes{iV}.cpt(2, :);
        snodes{iV}.parents = curV;
    end
end
