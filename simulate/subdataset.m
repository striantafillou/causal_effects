function subdataset = subdataset(dataset, isLatent)
% returns data set without the latent variables.
subdataset= dataset;
if nargin==1
    isLatent=dataset.isLatent;
end
if any(isLatent)
    subdataset.data = dataset.data(:, ~isLatent);
    subdataset.domainCounts = dataset.domainCounts(~isLatent);
    subdataset.headers = dataset.headers(~isLatent);
    subdataset.isLatent= dataset.isLatent(~isLatent);
end
    