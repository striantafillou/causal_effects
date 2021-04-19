function [selnodes_hat, seldag_hat, seldomainCounts_hat, adag] = selectionBNhat(obsDataset, marg_dist, isSelected, varargin)
% function [selnodes_hat, seldag_hat, dag_hat] = selectionBNhat(obsDataset, psels, nVars)
% takes as input the observational data, and the marginal distributions, and returns the selection BN 

[adag, mnodes] = process_options(varargin, 'dag', [], 'nodes', {}); % dag and nodes can be given as input, to not learn them again.
nVars = size(obsDataset.data, 2);
domainCounts = obsDataset.domainCounts;

if isempty(adag)
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
end    
if isempty(mnodes)
    mnodes = dag2BNData(adag, obsDataset.data, domainCounts);
end
eIM = tetradEIM(adag, mnodes, domainCounts);
jtalg  = javaObject('edu.pitt.dbmi.custom.tetrad.lib.bayes.JunctionTree', eIM);

nSelected = sum(isSelected);
if nSelected==0
    [selnodes_hat, seldag_hat, seldomainCounts_hat] = deal(mnodes, adag, domainCounts);
else
seldomainCounts_hat = 2*ones(1, nVars+nSelected+1);
seldomainCounts_hat(1:nVars)= domainCounts;
seldag_hat = addSelectionVars(adag, isSelected, nVars);
selnodes_hat = mnodes;
if sum(isSelected)>0
    selnodes_hat(nVars+1:nVars+nSelected) = estimateSelNodes(find(isSelected), marg_dist(1, isSelected), jtalg, nVars, domainCounts);
    % last node
    node.name = 'S';
    node.parents = nVars+1:nVars+nSelected;
    node.cpt = zeros(2*ones(1, nSelected+1));%
    node.cpt(2,end)=1;
    node.cpt(1, :) =1 -node.cpt(2, :); 
    selnodes_hat{nVars+nSelected+1} = node;
end
end
