function [doProb, doNodes]= estimateDoProbInf(y, x, dag, nodes, domainCounts)
% [doProb, doNodes]= estimateDoProbInf(y, x, dag, nodes, domainCounts)
% estimates P(Y|do(x)) using exact  inference in the manipulated graph.
% doNodes: the manipulated graph.
order = graphtopoorder(sparse(dag));
    for i = order
        if i==x
            doNodes{i}.parents=[];
            doNodes{i}.cpt = ones(domainCounts(i));
        else
            doNodes{i}=nodes{i};
        end
    end
    doJoint = estimateJoint(doNodes, domainCounts);
    doProb = estimateCondProbJoint(y, x, doJoint, size(dag,1));
end

