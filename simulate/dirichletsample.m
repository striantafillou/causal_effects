function theta = dirichletsample(alpha, nInst)
% SAMPLE_DIRICHLET Sample N vectors from Dir(alpha(1), ..., alpha(k))
% theta = sample_dirichlet(alpha, N)
% theta(i,j) = i'th sample of theta_j, where theta ~ Dir

% We use the method from p. 482 of "Bayesian Data Analysis", Gelman et al.

k = length(alpha); % numValues
theta = zeros(nInst, k);
scale = 1; % arbitrary
for i=1:k
    theta(:,i) = gamrnd(alpha(:, i), scale, nInst, 1);
end
S = sum(theta,2);
theta = theta ./ repmat(S, 1, k);
%let's reshape theta following dims...
% theta = reshape(theta', numel(theta), 1);
% theta = reshape(theta, [k dims]);
end
