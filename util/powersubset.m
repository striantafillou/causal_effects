function [P, nSets] = powersubset(S, n)
% returns 2^nSxn boolean matrix, each row corresponds to a set in the
% powerset of S, S is a subset of 1:n
    nSets = 2^numel(S);
    P = false(nSets, n);
    count =2;
    for nn = 1:n
        a = combnk(S,nn);
        for j=1:size(a,1)
            P(count, a(j,:)) =true;
            count = count+1;
        end
    end
end
