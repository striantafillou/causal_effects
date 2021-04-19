function [adag, rnodespost, orderpost]= estimatePosteriorNodes(obsDataset, dag)

nVars = size(obsDataset.data, 2);
domainCounts = obsDataset.domainCounts;

if nargin==1

list= tetradList(nVars, domainCounts);
% make tetrad data set
ds2 = javaObject('edu.cmu.tetrad.data.VerticalIntDataBox',obsDataset.data');
dsj = javaObject('edu.cmu.tetrad.data.BoxDataSet',ds2, list);

% make knowledge
knowledge = tetradKnowledgeAddTiers([1 2 zeros(1, nVars-2)]);
knowledge.setRequired('X1', 'X2')

% run fges
bd = javaObject('edu.cmu.tetrad.search.BDeuScore', dsj);bd.setStructurePrior(1);
ges= javaObject('edu.cmu.tetrad.search.Fges',bd);
ges.setKnowledge(knowledge);
pdagt = ges.search;
pdag = tetradGraphtoAdjMat(pdagt, nVars);
% get dag and make sure it is connected
adag = pdag_to_dag(pdag);
adag = makeConnected(adag);
else
    adag=dag;
end
% learn posterior DAG
[~, rnodespost, orderpost] = dag2BNPost(adag, obsDataset.data(:, 1:nVars), domainCounts);
end