function [auc, Xs, Ys, sample_probs] =estimateAUCfs(bestSet, bestprobs, configs, testData)
% assumes y is in col number 2 
[Xs, Ys] = deal(0:0.05:1);
auc=nan;

sample_probs = nan(size(testData, 1), 1);
for iConf =1:size(configs,1)
    inds = ismember(testData(:, bestSet),configs(iConf, :), 'rows');
    sample_probs(inds) = bestprobs(1, iConf);
end
try
[Xs,Ys,~,auc] = perfcurve(1-testData(:, 2), sample_probs, 1, 'XVals', 0:0.05:1, 'UseNearest', 'off');
catch
end