function [auc, sens, spec, sample_probs, tp, fp, tn, fn] =estimateMetrics(bestSet, bestprobs, configs, testData)
% assumes y is in col number 2 
auc=nan;

sample_probs = nan(size(testData, 1), 1);
for iConf =1:size(configs,1)
    inds = ismember(testData(:, bestSet),configs(iConf, :), 'rows');
    sample_probs(inds) = bestprobs(1, iConf);
end
[sens, spec, tp, fp, tn, fn] = confMat(1-testData(:, 2), sample_probs>=0.5);
try
[~, ~,~,auc] = perfcurve(1-testData(:, 2), sample_probs, 1, 'XVals', 0:0.05:1, 'UseNearest', 'off');
catch
end
end