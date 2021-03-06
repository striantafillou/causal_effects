function dag = randomdagWith12(nVars, maxParents)
% function DAG = randomdag(NVARS, MAXPARENTS) Generates a random dag over nVars
% variables where each variable has at most maxParents parents. (the number
% of parents for each node is drawn from uniformly from 1 to maxParents.
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
ordering = randperm(nVars);

for iVar = 1:length(ordering)
    curVar = ordering(nVars+1-iVar);
    nParents = randsample(min([maxParents+1, nVars-iVar+1]), 1)-1;
    if nParents ==0
        
        continue;
    end
    parents = randsample(nVars-iVar, nParents)';
    dag(ordering(parents), curVar) =1;
end

% add confounder 
x = randi(nVars-1);
y= randi([x+1 nVars]);
%dag(ordering(x), ordering(y)) = 1;
dag(ordering(x), [ordering(y)])=true;

% reorder
newOrder = ordering([x, y, setdiff(1:nVars,[x y])]);
dag = dag(newOrder, newOrder);

end