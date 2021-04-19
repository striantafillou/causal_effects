function p_y_giv_x = cond_prob(y, x, xvals, dataset)
% FUNCTION  p_y_giv_x = cond_prob(y, x, xval, dataset)
% Conditional probability of Y given X=x in data set
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
% p                       = P(Y|X=x)
% =======================================================================
data = dataset.data;
domainCounts = dataset.domainCounts;
for iXval = 1:length(xvals)
    xval = xvals(iXval);
    xData = data(ismember(data(:, x),xval, 'rows'), :);
    if isempty(xData)
        fprintf('No data with x = %s\n', num2str(xval))
        p_y_giv_x =zeros(domainCounts(y), 1);
        return
    end
    prior_y = domainCounts(y);
    p_y_giv_x(:, iXval) = histc(xData(:, y), [1:prior_y]-1)./size(xData,1);                     

end


