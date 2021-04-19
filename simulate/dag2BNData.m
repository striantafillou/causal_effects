function [nodes, rnodes, order] = dag2BNData(graph, data, domainCounts)
% function [nodes, rnodes, order] = dag2BNData(graph, data, domainCounts)
% Converts a DAG into a BN with  parameters estimated from dataset. Author:
% sot16@pitt.edu
% =======================================================================

numNodes = size(graph,1);
[nodes, rnodes] = deal(cell(numNodes,1));

%topologically ordering the graph
% levels = toposort(graph);
% [~, order] = sortrows([(1:numNodes)' levels'], 2);
% 

%headers = dataset.headers;
order = graphtopoorder(sparse(graph));
for i = order

    %info
    %fprintf('Node %d of %d\n', i, length(order))

    %name, parents, number of states and domain counts of the node
    %node.name = headers{i};
    node.parents = find(graph(:,i));
    rnode=node;
    %let's create the cpt...
    if isempty(node.parents)

        %firstly, let's sample...
        node.parents = [];
       [node.cpt, rnode.cpt] = cond_prob_mult(i, node.parents', data, domainCounts);
    else
       [node.cpt, rnode.cpt] = cond_prob_mult(i, node.parents', data, domainCounts);
    end

    nodes{i} = node;
    rnodes{i}= rnode;

end
end
