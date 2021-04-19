function [joint, vals]= estimateJoint(nodes, domainCounts)
% [joint, vals]= estimateJoint(nodes, domainCounts);
% estimates joint probability distribution (bruteforce) for exact
% inference.
nVars = length(nodes);
% estimate joint
joint = nan(domainCounts(1:nVars));
vals = cell(1, nVars);
for i=1:nVars
    vals{i} = 1:domainCounts(i);
end
jointInstances = combvec(vals{:})';
nJointInstances = size(jointInstances,1);


for i =1:nJointInstances
    curInstance = jointInstances(i, :);
    indsCell = num2cell(curInstance);
    joint(indsCell{:}) = estimateInstanceProb(curInstance, nodes);
end

end