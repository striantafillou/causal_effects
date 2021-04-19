function p_y = marg_prob(y, data, domainCounts)
% FUNCTION  p_y = marg_prob(y, dataset)
% Marginal probability of y in data set
%
% Author: sot16@pitt.edu
% =======================================================================
% Inputs
% =======================================================================
% y                        = indices of  y in dataset.data
% dataset                  = nSamples x nVars data set including variable y
% =======================================================================
% Outputs
% =======================================================================
% p                       = P(y)
% =======================================================================

if nargin==2
    domainCounts=data.domainCounts;
    data=data.data;
end

% if w is empty return one for computations
if isempty(y)
    p_y =1;
    return;
end
N = size(data,1);
inst_y = variableInstances(domainCounts(y), true);
p_y = nan(size(inst_y, 1),1);

for iInst = 1:size(inst_y, 1)
    p_y(iInst) = sum(ismember(data(:, y),inst_y(iInst,:), 'rows'))/N;
end
end
