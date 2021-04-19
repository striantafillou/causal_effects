function instances = variableInstances(domainCounts, isData)
% output instances for variables with domainCounts
% if type is data, instance values are 0:domainCounts-1
% if type is inds, instance values are 1:domainCounts;
if nargin ==1
    isData=false;
end
nVars = size(domainCounts, 2);
% estimate joint
vals = cell(1, nVars);
for i=1:nVars
    vals{i} = 1:domainCounts(i);
end
instances = combvec(vals{:})';
if isData
    instances= instances-1;
end
end


