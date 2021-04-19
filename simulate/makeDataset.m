function dataset = makeDataset(data, varargin)
% function dataset = makeDataset(data, varargin) 
% creates structure dataset from data matrix.
[~, nVars] = size(data);
[domainCounts,  isLatent, isManipulated,  type, headers] = ...
      process_options(varargin, 'domainCounts', '1', 'isLatent', false(1, nVars), 'isManipulated', false(1, nVars), 'type', 'discrete', 'headers', {});
  dataset.data=data;
  dataset.domainCounts= domainCounts;
  dataset.isLatent=isLatent;
  dataset.isManipulated= isManipulated;
  dataset.type=type;
  dataset.headers=headers;
end