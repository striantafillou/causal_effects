function [pydoxzexp] = estimateDoProbCondJT(y, x, cmbe, cmbo, ze, jtalg, nVars, domainCounts)
% [pydox, pz, pygivxz] = estimateDoProbJTSumOverZ(y, x, z, jtalg, nVars, domainCounts)
% estimates P(Y|do(X), CMBe, Ze) = \sum_cmbo P(Y|do(X), CMBe, Ze,
% CMBo)P(CMBo|CMBe, Ze) where
% CMBe: The subset of CMB that is in Dexp
% CMBo: The subset of CMB that is only in Dobs
% Ze: VAriables in Dexp such that Ze\ind Y|CMB, so  
% P(Y|do(X), CMBe, Ze, CMBo) =  P(Y|X, CMBe, Ze, CMBo)

zexp = [cmbe ze]; ncmbe = size(cmbe,2);
cmbo_configs  = allConfigurations(size(cmbo, 2), domainCounts);ncmboconfs = size(cmbo_configs, 1);
zexp_configs  = allConfigurations(size(zexp, 2), domainCounts);nzcofs = size(zexp_configs, 1);

pydoxzexp = nan(domainCounts(y), domainCounts(x), nzexp_configs);
% estimate P(Y|X, CMBo, CMBe);
% for every configuration of zexp
pzconf = nan(nzcofs, 1);
for iX = 1:domainCounts(x)
    for izconf =1:nzcofs
        if iX ==1;curzconf = zexp_configs(izconf, :);end
        pzconf(izconf) = jtalg.getJointProbability([zexp]-1, [curzconf]-1);
        for icmboconf=1:ncmboconfs
            curcmboconf = cmbo_configs(icmboconf, :);
            pygivxcmb(:, icmboconf)= jtalg.getConditionalProbabilities(y-1, [x cmbe cmbo]-1, [iX curzconf(1:ncmbe) curcmboconf]-1);
            pcmbzexp(icmboconf) =jtalg.getJointProbability([cmbo zexp]-1, [curcmboconf curzconf]-1);            
            pcmbogivzexp(icmboconf) = exp(log(pcmbzexp(icmboconf)) - log(pzconf(izconf)));
            pydoxzexp(:, iX, izconf) = sum(pygivxcmb.*pcmbogivzexp);
        end
    end
end

