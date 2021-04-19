function [p_y_giv_x, pyx]= cond_prob_mult_no_zeros(y, cond, dataset, domainCounts)
% FUNCTION  p_y_giv_x = cond_prob(y, cond, dataset, domainCounts)
% Conditional probability of Y given cond in data set
%
% Author: sot16@pitt.edu
% =======================================================================
% Inputs
% =======================================================================
% x, cond                    = indices of x, y in dataset.data
% dataset                 = nSamples x nVars data set including variables
%                           x, y
% =======================================================================
% Outputs
% =======================================================================
% p                       = P(Y|X=x)
% =======================================================================

if nargin==3
data = dataset.data;
domainCounts = dataset.domainCounts;
else data=dataset;
end

if isempty(cond)
    p_y_giv_x = histc(data(:,y) , 0:domainCounts(y)-1)./size(data, 1);
    pyx =p_y_giv_x;
    return;
end
inst_cond= variableInstances(domainCounts(cond), true);
nInst= size(inst_cond, 1);
pyx =zeros(domainCounts(y) , nInst);
prior_y = domainCounts(y);


for iInst = 1:nInst
    curData = data(ismember(data(:, cond),inst_cond(iInst, :), 'rows'), :);
    if isempty(curData)
        %fprintf('No data\n')
        % make them uniform
        pyx(:, iInst) = ones(prior_y, 1)./prior_y;
    else   
    pyx(:, iInst) = histc(curData(:, y), [1:prior_y]-1)./size(curData,1);     
    end
end

[~, ismin] = min(pyx, [], 1);
[~, ismax] = max(pyx, [], 1);
mininds = sub2ind(size(pyx), ismin,  [1:nInst]);
maxinds = sub2ind(size(pyx), ismax, [1:nInst]);

pyx(mininds) = pyx(mininds)+0.05;
pyx(maxinds) = pyx(maxinds)-0.05;

p_y_giv_x = reshape(pyx, [domainCounts([y cond])]);
pyx = pyx';

end


