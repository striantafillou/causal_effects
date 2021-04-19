function pydox = estimateDoProbJTSel(y, x, dag, nodes, isSelected, domainCounts)
% pydox = estimateDoProbJTSel(y, x, dag, nodes, isSelected, domainCounts)
% estimates pydox using junction tree inference in the manipulated graph given S=1.

doNodes = nodes; 
doNodes{x}.parents=[];doNodes{x}.cpt = ones(domainCounts(x), 1);
doDag = dag;doDag(:, x)=0;
[tIMdo] = tetradEIM(doDag, doNodes, domainCounts);
jtalg =javaObject('edu.pitt.dbmi.custom.tetrad.lib.bayes.JunctionTree', tIMdo); % selection posterior

nSel = sum(isSelected);nVars = size(dag,1)-nSel-1;
pydox = nan(domainCounts(y), domainCounts(x));
for iX =0:domainCounts(x)-1
    pydox(:, iX+1) = estimateCondProbJTvals(y,[x nVars+1:nVars+nSel+1],[iX ones(1, nSel+1)], jtalg, 'domainCounts', domainCounts);
end
end
