function [pydoxz,configs] = estimateDoProbCondJT(y, x, z, dag, nodes, domainCounts)
% pydoxz = estimateDoProbCondJT(y, x, z, dag, nodes, domainCounts)
% estimates P(Y|do(x), z) using junction tree inference in the manipulated graph.

doNodes = nodes; 
doNodes{x}.parents=[];doNodes{x}.cpt = ones(domainCounts(x), 1);
doDag = dag;doDag(:, x)=0;
[tIMdo] = tetradEIM(doDag, doNodes, domainCounts);
jtalg =javaObject('edu.pitt.dbmi.custom.tetrad.lib.bayes.JunctionTree', tIMdo); 
[pydoxz,configs] = estimateCondProbJT(y, [x z], jtalg, size(domainCounts,1), domainCounts);%(y,[x nVars+1:nVars+nSelected(iRCT)],[iX ones(1, nSelected(iRCT))], jttruedo);
end
