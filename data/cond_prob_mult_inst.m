function [p_y_giv_x, inst_y, inst_cond, cyx] = cond_prob_mult_inst(y, cond, dataset, domainCounts)
% FUNCTION  p_y_giv_x = cond_prob(y, x, xval, dataset)
% Conditional probability of each instance of Y (lexicographic) given X=x in data set 
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
if nargin==3;
data = dataset.data;
domainCounts = dataset.domainCounts;
else data=dataset;
end
if isempty(cond)
    p_y_giv_x = histc(data(:,y) , 0:domainCounts(y)-1)./size(data, 1);
    cyx = histc(data(:,y) , 0:domainCounts(y)-1);

    return;
end
inst_cond= variableInstances(domainCounts(cond), true);
nInst= size(inst_cond, 1);
inst_y = variableInstances(domainCounts(y), true);
pyx =zeros(prod(domainCounts(y)) , nInst);
prior_y = prod(domainCounts(y));


for iInst = 1:nInst
    curData = data(ismember(data(:, cond),inst_cond(iInst, :), 'rows'), :);
    if isempty(curData)
        %fprintf('No data\n')
        % make them uniform
        pyx(:, iInst) = ones(prior_y, 1)./prior_y;
        cyx(:, iInst) =0;
    else   
        for iInstY = 1:size(inst_y,1)
             cyx(iInstY, iInst) = sum(ismember(curData(:, y), inst_y(iInstY, :), 'rows'));
             pyx(iInstY, iInst) = sum(ismember(curData(:, y), inst_y(iInstY, :), 'rows'))./size(curData,1);
        end
          %   histc(curData(:, y), [1:prior_y]-1)./size(curData,1);     
    end
end
p_y_giv_x = pyx;%reshape(pyx, [domainCounts([y cond])]);

end
