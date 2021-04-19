function [selDag, selNodes, selDomainCounts]= BN2BNsel(dag, nodes,domainCounts, isSelected, marg_probs_obs, marg_probs_sel)
% function [selNodes, selDomainCounts, selDag]=  BN2BNsel(dag, nodes,domainCounts, isSelected, marg_probs_obs, marg_probs_sel)
% returns BN with some of the root nodes selected upon, to create
% distribution shifts.

nVars = size(dag,1);
nSelVars = sum(isSelected);
selDag = zeros(nVars+nSelVars);
selDag(1:nVars, 1:nVars)=dag;
selDomainCounts = [domainCounts 2*ones(1, nSelVars)];
i=nVars;
selnodes = cell(nVars+nSelVars,1);
selnodes(1:nVars)= nodes;
for iVar =1:nVars
    if isSelected(iVar)
        if ~isempty(nodes{iVar}.parents)
            fprintf('Only root nodes can be selected upon\n');return;
        end
        i = i+1;
        selDag(iVar, i)=1;
        selnode.name = ' ';
        selnode.parents = iVar;
        selnode.cpt = nan(2, domainCounts(iVar));
        numStates =2;
        domainCounts(i) = numStates;
        % random shift to the distibution  

        [theta, ~, priors] = dirichletsample1(ones(1,numStates),1);
        selnode.cpt(2, :) = estimateSelectionProbsMarg(marg_probs_sel{iVar}, marg_probs_obs{iVar});
        selnode.cpt(1, :)=1-selnode.cpt(2, :);
        %P(S=1|W)
        selnodes{iVar}.cpt = theta;
        selnodes{iVar}.priors = priors;
        nodes{i} = selnode;
    end
end
selNodes = nodes;
end
function [theta, theta2,alphas] = dirichletsample1(alpha, dims)
% SAMPLE_DIRICHLET Sample N vectors from Dir(alpha(1), ..., alpha(k))
% theta = sample_dirichlet(alpha, N)
% theta(i,j) = i'th sample of theta_j, where theta ~ Dir

% We use the method from p. 482 of "Bayesian Data Analysis", Gelman et al.

k = length(alpha);
N = prod(dims);
theta = zeros(N, k);
scale = 1; % arbitrary
%alphas = [0.1 5; 5 0.1];%nan(N, k);
alphas = nan(N, k);
for j=1:N
    for i=1:k
        alphas(j,i) = rand();%rand();%rand()
        theta(1,i) = gamrnd(alphas(1, i), scale, 1, 1);
    end
end
S = sum(theta,2);
theta2 = theta ./ repmat(S, 1, k);
%let's reshape theta following dims...
theta = reshape(theta2', numel(theta), 1);
theta = reshape(theta, [k dims]);
end