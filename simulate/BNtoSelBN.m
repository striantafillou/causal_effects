function [selDag, selNodes, selDomainCounts, sampleNodes]= BNtoSelBN(dag, nodes, domainCounts, isSelected)
% function [selDag, selNodes, selDomainCounts, sampleNodes]= BNtoSelBN(nodes, isSelected,domainCounts, dag);
% returns BN with some of the nodes selected upon: adds selection nodes S_x and assings random P(S_x|X) to create
% distribution shifts.

nVars = size(dag,1);
nSelVars = sum(isSelected);
selDag = zeros(nVars+nSelVars);
selDag(1:nVars, 1:nVars)=dag;
selDomainCounts = [domainCounts 2*ones(1, nSelVars)];
i=nVars;
sampleNodes=nodes;
for iVar =1:nVars
    if isSelected(iVar)
%         if ~isempty(nodes{iVar}.parents)
%             fprintf('Only root nodes can be selected upon\n');return;
%         end
        i = i+1;
        selDag(iVar, i)=1;
        selnode.name = sprintf('S%d', iVar);
        selnode.parents = iVar;
        selnode.cpt = nan(2, domainCounts(iVar));
        numStates =2;
        domainCounts(i) = numStates;
        
        % add selection cpt to the distibution  
        [theta] =dirichletsample3(ones(1,numStates), domainCounts(selnode.parents));
        selnode.cpt = theta;

         % estimate P(X|Pa(X), S_X=1);
         p_s_x = selnode.cpt(2, :)';
         p_x_par = nodes{iVar}.cpt;
         cpt_cond = p_s_x.*p_x_par./sum(p_s_x.*p_x_par);
         sampleNodes{iVar}.cpt = cpt_cond;
         nodes{i} = selnode;
    end
end
selNodes = nodes;
end