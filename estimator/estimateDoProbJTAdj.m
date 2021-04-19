function [pydox, pz, pygivxz] = estimateDoProbJTAdj(y, x, z, jtalg, nVars, domainCounts)
% [pydox, pz, pygivxz] = estimateDoProbJT(y, x, z, jtalg, nVars, domainCounts)
% estimates pydox according by on adjusting for z using junction tree inference
% to estimate for P(Y|X, Z) and P(Z).

pydox = nan(domainCounts(y), domainCounts(x));
if isempty(z)
    for iX = 1:domainCounts(x)   
        pydox(:, iX) = jtalg.getConditionalProbabilities(y-1, x-1, iX-1);
    end
   pz =[]; pygivxz =[]; pydox(isnan(pydox))=1./domainCounts(y);return;
end
nConfigs = prod(domainCounts(z));    
pz = nan(1, nConfigs);

for iX = 1:domainCounts(x)
    pygivxz=nan(domainCounts(y), nConfigs);
    configs =  [iX*ones(nConfigs, 1) variableInstances(domainCounts(z), false)]-1;
    for iConfig =1:nConfigs
        if iX ==1
        pz(iConfig) = jtalg.getJointProbability(z-1, configs(iConfig,2:end));
        %getConditionalProbabilities(int iNode, int[] parents, int[] parentValues)
        end
        if pz(iConfig)==0; pygivxz(:, iConfig) =1./domainCounts(y);else
        pygivxz(:, iConfig) = jtalg.getConditionalProbabilities(y-1, [x z]-1, configs(iConfig,:));
        end
    end
    pydox(:, iX) = sum( pygivxz.*pz, 2);
end
pydox(isnan(pydox))=1./domainCounts(y);

end

