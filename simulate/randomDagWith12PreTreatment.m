function [dag, isRoot] = randomDagWith12PreTreatment(nVars, maxParents)
% function DAG = randomDagWith12PreTreatment(NVARS, MAXPARENTS) Generates a random dag over nVars
% variables where each variable has at most maxParents parents. (the number
% of parents for each node is drawn from uniformly from 1 to maxParents.
% The dag has an edge 1->2, and all other covariates are pretreatment.
%
% Author: striant@csd.uoc.gr
% =======================================================================
% Inputs
% =======================================================================
% nVars                    = number of variables 
% maxParents               = nVars x 1 matrix with maximum number of
%                               parents per variable
% =======================================================================
% Outputs
% =======================================================================
% dag                      = adjacency matrix
% =======================================================================
dag = zeros(nVars);
ordering = randperm(nVars-2);
ordering = [ordering+2 1 2];
isRoot = false(1, nVars);
for iVar = 1:length(ordering)
    curVar = ordering(nVars+1-iVar);
    nParents = randsample(min([maxParents+1, nVars-iVar+1]), 1)-1;
    if nParents ==0
        isRoot(curVar) = true;
        continue;
    end
    parents = randsample(nVars-iVar, nParents)';
    dag(ordering(parents), curVar) =1;
end

dag(1, 2)= 1;
% 
% % remove instrumental variables
% isAnc = transitiveClosureSparse_mex(sparse(dag));
% isAnc =  ~~isAnc;
% dsepy =finddseparations(dag, 2, 1, isAnc);
% ivs = intersect(find(dag(:, 1)), dsepy);
% dag(ivs, 2)=1;
end