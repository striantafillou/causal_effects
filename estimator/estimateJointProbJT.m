function [pz, pz_conf] = estimateJointProbJT(z, jtalg, nVars, domainCounts)
% pz = estimateJointProbJT(z, jtalg, nVars, domainCounts)
% Estimates joint probability distribution P(\bf z) using junction tree
% inference.
nConfigs = prod(domainCounts(z)); 
pz_conf = nan(1, nConfigs);
configs =  variableInstances(domainCounts(z), false)-1;
for iConfig =1:nConfigs
    pz_conf(iConfig) = jtalg.getJointProbability(z-1, configs(iConfig,:));
    %getConditionalProbabilities(int iNode, int[] parents, int[] parentValues)
end
if length(z)==1;pz= pz_conf';
else
    pz =reshape(pz_conf, domainCounts(z));
end


% evidence = cell(1,nVars);
% if isempty(z)
%     [eng, ll] = enter_evidence(engine, evidence);
%      mnodes = marginal_nodes(eng, y);
%      pygivz = mnodes.T;
% else
%     nConfigs = prod(domainCounts(z));
%     pygivz=nan(domainCounts(y), nConfigs);
%     nZ = length(z);
%     configs =  variableInstances(domainCounts(z), false);
%     for iConfig =1:nConfigs
%         curConfig = configs(iConfig, :);
%         z_c =mat2cell(curConfig', ones(nZ,1));
%         evidence(z) = deal(z_c);
%         [eng, ll] = enter_evidence(engine, evidence);
%         mnodes = marginal_nodes(eng, y);
%         pygivz(:, iConfig) = mnodes.T;
%     end
% end