function [pydox, pz, pygivxz, configs] = estimateDoProbJTalgSel(y, x, z, jtalg, pz, zconfs, domainCounts)
%[pydox, pz, pygivxz, configs] = estimateDoProbJTalgSel(y, x, z, jtalg, pz, zconfs, domainCounts)
% estimates P(Y|do(X), S=1) using junction tree inference and and adjusting for z. 
pydox = nan(domainCounts(y), domainCounts(x));

if isempty(pz)
    for iX = 1:domainCounts(x)   
        pydox(:, iX) = jtalg.getConditionalProbabilities(y-1, x-1, iX-1);
    end
   pz =[]; pygivxz =[]; configs=[];return;
end
nConfigs = size(zconfs,1);    

for iX = 1:domainCounts(x)
    pygivxz=nan(domainCounts(y), nConfigs);
    configs =  [iX*ones(nConfigs, 1)-1 zconfs];
    for iConfig =1:nConfigs
        pygivxz(:, iConfig) = jtalg.getConditionalProbabilities(y-1, [x z]-1, configs(iConfig,:));
    end
    pygivxz(isnan(pygivxz)) = 1./domainCounts(y);
    pydox(:, iX) = sum( pygivxz.*pz, 2);
end

end