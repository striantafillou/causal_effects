function [rnds_sam] = sampleBNpost(rnds,order, domainCounts, varargin)
% Samples from the posterior BN rnds.

rnds_sam = rnds;
for i =order   
    if isempty(rnds{i}.parents)
         theta = sample_dirich(rnds{i}.cpt);
         theta = reshape(theta, numel(theta), 1);
        rnds_sam{i}.cpt = reshape(theta, [domainCounts(i) 1]);
    else
        theta = sample_dirich(rnds{i}.cpt);
        theta = reshape(theta', numel(theta), 1);
        rnds_sam{i}.cpt = reshape(theta, [domainCounts(i) domainCounts(rnds{i}.parents')]);
    end
end

% if joint
%     joint = estimateJoint(rnds_sam, domainCounts);
% end
end
function theta = sample_dirich(alphas)
% SAMPLE_DIRICHLET Sample N vectors from Dir(alpha(i,1), ..., alpha(i, k))
% theta = sample_dirichlet(alpha, N)
% theta(i,j) = i'th sample of theta_j, where theta ~ Dir

% We use the method from p. 482 of "Bayesian Data Analysis", Gelman et al.

[nInst, k] = size(alphas); % numValues
scale = 1; % 
theta = zeros(nInst, k);
for iInst=1:nInst
    theta_ = zeros(1, k);
    if sum(alphas(iInst,:)==1) == k % if no data, uniform
       theta(iInst,:) =1./k;
    else
        for i=1:k
            theta_(:,i) = gamrnd(alphas(iInst, i), scale, 1, 1);
        end
        S = sum(theta_,2);
        theta(iInst, :) = theta_ ./ repmat(S, 1, k);
    end
end

end