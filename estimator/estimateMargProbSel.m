function pY = estimateMargProbSel(y,s, joint, nVars)
% pY = estimateMargProbSel(y,s, joint, nVars)
% estimates probability y|S=1 from jpd joint
nY = length(y);
condProb = estimateCondProbJoint(y, s, joint, nVars);
v = repmat({':'},ndims(condProb),1); v(nY+1:end) = {2};
pY = condProb(v{:});
end