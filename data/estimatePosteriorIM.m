function [eIMpost, domainCounts]= estimatePosteriorIM(obsDataset)
% [eIMpost, domainCounts]= estimatePosteriorIM(obsDataset)
% estimates tetrad posterior instantiated model from observational data
% set.

nVars = size(obsDataset.data, 2);
domainCounts = obsDataset.domainCounts;

list= tetradList(nVars, domainCounts);
% make tetrad data set
ds2 = javaObject('edu.cmu.tetrad.data.VerticalIntDataBox',obsDataset.data');
dsj = javaObject('edu.cmu.tetrad.data.BoxDataSet',ds2, list);

% make knowledge
knowledge = tetradKnowledgeAddTiers([1 2 zeros(1, nVars-2)]);
knowledge.setRequired('X1', 'X2')

% run fges
bd = javaObject('edu.cmu.tetrad.search.BDeuScore', dsj);%bd.setStructurePrior(10);
ges= javaObject('edu.cmu.tetrad.search.Fges',bd);
ges.setKnowledge(knowledge);
pdagt = ges.search;
pdag = tetradGraphtoAdjMat(pdagt, nVars);
% get dag and make sure it is connected
adag = pdag_to_dag(pdag);
adag = makeConnected(adag);


% dirichlet posterior instantiated model
aGraph=dag2tetrad(adag,list, nVars); % graph
tBM= javaObject('edu.cmu.tetrad.bayes.BayesPm', aGraph);
eIMprior = edu.cmu.tetrad.bayes.DirichletBayesIm.symmetricDirichletIm(tBM, 1);
eIMpost= edu.cmu.tetrad.bayes.DirichletEstimator.estimate(eIMprior, dsj);% 
end