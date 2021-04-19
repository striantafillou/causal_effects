function [selnodes, seldomainCounts]= addSelectionNodes(nodes, isSelected, domainCounts, nVars)
% function seldag = addSelectionVarsData(dag, isSelected, nVars);
% for each selection variable, adds a dummy Xs->S and random P(S|Xs).
nSelected = sum(isSelected);
selnodes = cell(nVars+nSelected+1,1);
seldomainCounts = 2*ones(1,nVars+nSelected+1);
seldomainCounts(1:nVars)=domainCounts;
selnodes(1:nVars) = nodes;
selVar = nVars;
for iVar=1:nVars
    if isSelected(iVar)
        selVar = selVar+1;
        node.name = sprintf('S%d', iVar);
        node.parents = iVar;
        numStates = 2;
        theta =dirichletsample(ones(1,numStates), domainCounts(node.parents));
        node.cpt = theta;
        selnodes{selVar} = node;
        seldomainCounts(selVar)= numStates;
    end
end
node.name = 'S';
node.parents = nVars+1:nVars+nSelected;
node.cpt = zeros(2*ones(1, nSelected+1));%
node.cpt(2,end)=1;
node.cpt(1, :) =1 -node.cpt(2, :); 
selnodes{nVars+nSelected+1} = node;
end
function [theta, theta2] = dirichletsample(alpha, dims)
% SAMPLE_DIRICHLET Sample N vectors from Dir(alpha(1), ..., alpha(k))
% theta = sample_dirichlet(alpha, N)
% theta(i,j) = i'th sample of theta_j, where theta ~ Dir

% We use the method from p. 482 of "Bayesian Data Analysis", Gelman et al.

k = length(alpha);
N = prod(dims);
theta = zeros(N, k);
scale = 1; % arbitrary
for i=1:k
    theta(:,i) = gamrnd(alpha(i), scale, N, 1);
end
S = sum(theta,2);
theta2 = theta ./ repmat(S, 1, k);
%let's reshape theta following dims...
theta = reshape(theta2', numel(theta), 1);
theta = reshape(theta, [k dims]);
end