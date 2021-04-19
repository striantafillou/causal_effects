function pydox = estimateDoProbJT(y, x, dag, nodes, domainCounts)
% pydox = estimateDoProbJT(y, x, dag, nodes, domainCounts)
% estimates pydox using junction tree inference in the manipulated graph.

doNodes = nodes; 
doNodes{x}.parents=[];doNodes{x}.cpt = ones(domainCounts(x), 1);
doDag = dag;doDag(:, x)=0;
[tIMdo] = tetradEIM(doDag, doNodes, domainCounts);
jtalg =javaObject('edu.pitt.dbmi.custom.tetrad.lib.bayes.JunctionTree', tIMdo); % selection posterior
pydox = estimateCondProbJT(y, x, jtalg, size(domainCounts,1), domainCounts);%(y,[x nVars+1:nVars+nSelected(iRCT)],[iX ones(1, nSelected(iRCT))], jttruedo);
end

% evidence = cell(1,nVars);
% eng = enter_evidence(engine, evidence);
% pydox = nan(domainCounts(y), domainCounts(x));
% if isempty(z)
%    for iX = 1:domainCounts(x)
%         pygivxz=nan(domainCounts(y), nConfigs);
%         configs =  [iX*ones(nConfigs, 1) variableInstances(domainCounts(z), false)];
%         for iConfig =1:nConfigs
%             curConfig = configs(iConfig, :);
%             z_c = mat2cell(curConfig', ones(nCond,1));
%             evidence([x z]) = deal(z_c);
%             eng = enter_evidence(engine, evidence);
%             mnodes = marginal_nodes(eng, y);
%             pygivxz(:, iConfig) = mnodes.T;
% 
%         end
%         pydox(:, iX) =sum(pz.*pygivxz,2);
%     end
% else
%     nConfigs = prod(domainCounts(z));    
%     nCond = length(z)+1;
%     mnodesz = marginal_nodes(eng,z);
%     pz = reshape(mnodesz.T, 1, [])
%     for iX = 1:domainCounts(x)
%         pygivxz=nan(domainCounts(y), nConfigs);
%         configs =  [iX*ones(nConfigs, 1) variableInstances(domainCounts(z), false)];
%         for iConfig =1:nConfigs
%             curConfig = configs(iConfig, :);
%             z_c = mat2cell(curConfig', ones(nCond,1));
%             evidence([x z]) = deal(z_c);
%             eng = enter_evidence(engine, evidence);
%             mnodes = marginal_nodes(eng, y);
%             pygivxz(:, iConfig) = mnodes.T;
% 
%         end
%         pydox(:, iX) =sum(pz.*pygivxz,2);
%     end
% end