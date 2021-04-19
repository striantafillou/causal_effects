function [condProb, configs]= estimateCondProbJT(y, z, jtalg, nVars, domainCounts)
% [pygivz, configs]= estimateCondProbJT(y, z, jtalg, nVars, domainCounts)
% estimate probability y|z using junction tree (jtalg is a tetrad junction
% tree)
% configs: configurations of the conditioning set.

if isempty(z)
    condProb = jtalg.getMarginalProbability(y-1);
    configs=[];
    return;
end

nConfigs = prod(domainCounts(z)); 
condProb = nan(domainCounts(y), nConfigs);
  
pz = nan(1, nConfigs);
configs =  variableInstances(domainCounts(z), false)-1;
for iConfig =1:nConfigs
    pz(iConfig) = jtalg.getJointProbability(z-1, configs(iConfig,:));
    condProb(:, iConfig) = jtalg.getConditionalProbabilities(y-1, z-1, configs(iConfig,:));
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