function dataset=simulateDoDataSelinf(selNodes, seldag, doVar, doVals, nVars, isSelected, numCases,  type, varargin)
% function dataset=simulateDoData(selNodes, doVar, doVal, numCases,  type, varargin)
% simulates data from dag seldag where doVar is manipulated and set to
% doVals (numCases per value)% 
% isSelected(x) is true if variable x is selected upon 
% seldag has nVars+sum(isSelected) variables, and is the original dag plus 
% X->S_X for every selected variable.
numNodes=nVars;
nSel =sum(isSelected);
selVarNodes =nVars+1:nVars+nSel+1;
[domainCounts, isLatent, isManipulated] = process_options(varargin, 'domainCounts', [], 'isLatent',  false(1, numNodes),'isManipulated', false(1, numNodes),  'verbose', false);
dataset.isLatent = isLatent;
dataset.isManipulated = isManipulated;
headers = cell(1, numNodes);
dataset.data =[];

% doVal = doVal+1;
% if size(doVal, 1)==1
%     doVal = repmat(doVal, numCases, 1);
% end
if isequal(type, 'discrete')
    
    edges=0;
    for i=1:numNodes
        headers{i} = selNodes{i}.name;
        edges=edges+length(selNodes{i}.parents);
    end
    graph=spalloc(numNodes,numNodes,edges);
    for i=1:numNodes
        graph(selNodes{i}.parents,i) = 1;
    end
    ord=graphtopoorder(sparse(graph));
    

   
   % make the inference machine
    doNodes = selNodes; doNodes{doVar}.parents=[];doNodes{doVar}.cpt = ones(domainCounts(doVar), 1);
    doDag = seldag;doDag(:, 1)=0;
    [tIMdo] = tetradEIM(doDag, doNodes, domainCounts);
    jttruedo =javaObject('edu.pitt.dbmi.custom.tetrad.lib.bayes.JunctionTree', tIMdo);
    for iDoVal = 1:length(doVals)
    doVal = doVals(iDoVal)+1;
    doVal = repmat(doVal, numCases, 1);
    data= zeros(numCases, nVars);
    for case_cnt=1:numCases
        node_values = nan(1,numNodes);
        queue = [];    nQ=0;
        % Loop over all selNodes to be simulated
        for node=ord
            if ismember(node, doVar)
                node_values(node) = doVal(case_cnt, ismember(doVar, node));
                queue = [queue node]; % already assinged
                nQ =nQ+1;
            else
                if nQ ==0
                    pt =estimateCondProbJTvals(node,selVarNodes,[ones(1, nSel+1)], jttruedo, 'domainCounts', domainCounts);
                    cumps = cumsum(pt);
                    value = [];
                    while isempty(value)
                          value = find(cumps - rand > 0, 1 );
                    end
                    node_values(node) = value;
                else
                    pt =estimateCondProbJTvals(node,[queue selVarNodes],[node_values(queue)-1 ones(1, nSel+1)], jttruedo, 'domainCounts', 'domainCounts');
                    cumps = cumsum(pt);
                    value = [];
                    while isempty(value)
                          value = find(cumps - rand > 0, 1 );
                    end
                    node_values(node) = value;
                end
            queue = [queue node]; % already assinged
            nQ =nQ+1;
            end 
        end % end for node=ord
        %case_cnt = case_cnt+1;
        data(case_cnt,:)=node_values;  
    end
    data=data-1;
    dataset.data =[dataset.data; data];
    end
    dataset.domainCounts = domainCounts;
    dataset.type = 'discrete';

else % type is unknown
    errprintf('Unknown data type:%s\n', type);
    dataset = nan;
end
dataset.headers = headers;
end

function value = randomSampleDiscrete(cpt, instance)
% value = RANDOMSAMPLEDISCRETE(CPT, INSTANCE)
% Returns a value for a discrete variable using the conditional probability table
% cpt, for parent instanciation instance.

if(isempty(instance))
    x = 1;
else
    s = size(cpt);
    x = mdSub2Ind_mex(s(2:end), instance);
end

cumprobs = cumsum(cpt(:,x));
value = [];
while isempty(value)
      value = find(cumprobs - rand > 0, 1 );
end
end
