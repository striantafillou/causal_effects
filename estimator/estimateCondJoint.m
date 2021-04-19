function condJoint =estimateCondJoint(nodes, cvars, cvals, domainCounts)
% estimate joint distribution of nodes for cvars=cvals;
nVars = length(nodes);
vars = setdiff(1:nVars, cvars);
nnVars = length(vars);
% estimate joint
joint = nan(domainCounts(vars));
vals = cell(1, nnVars);
for i=1:nnVars
    vals{i} = 1:domainCounts(vars(i));
end
jointInstances1= combvec(vals{:})';
nJointInstances = size(jointInstances1,1);
jointInstances = nan(nJointInstances, nVars);
jointInstances(:, vars) = jointInstances1;
for iVar=1:length(cvars)
    jointInstances(:,cvars(iVar)) = repmat(cvals(iVar), nJointInstances,1)+1;
end

for i =1:nJointInstances
    curInstance = jointInstances(i, :);
    indsCell = num2cell(curInstance(vars));
    joint(indsCell{:}) = estimateInstanceProb(curInstance, nodes);
end

condJoint= joint./sumOverDims(joint, 1:nVars);
end