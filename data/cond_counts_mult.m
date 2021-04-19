function [p_y_giv_x, pyx]= cond_counts_mult(y, cond, dataset, domainCounts)
% FUNCTION  p_y_giv_x = cond_prob(y, x, xval, dataset)
% Counts of Y given X=x in data set
%
% Author: sot16@pitt.edu
% =======================================================================
% Inputs
% =======================================================================
% x, y                     = indices of x, y in dataset.data
% dataset                  = nSamples x nVars data set including variables
%                           x, y
% =======================================================================
% Outputs
% =======================================================================
% p                       = N(Y|X=x)
% =======================================================================

if nargin==3
data = dataset.data;
domainCounts = dataset.domainCounts;
else data=dataset;
end

if isempty(cond)
    p_y_giv_x = histc(data(:,y) , 0:domainCounts(y)-1)+1;
    pyx =p_y_giv_x';
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
        % make keep a=1
        pyx(:, iInst) = ones(prior_y, 1);
    else   
    pyx(:, iInst) = histc(curData(:, y), [1:prior_y]-1)+1;     
    end
end
p_y_giv_x = reshape(pyx, [domainCounts([y cond])]);
pyx= pyx';

end


