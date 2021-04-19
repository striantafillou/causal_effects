function mbT = pdagMB(pdag, t)
% mbT = pdagMB(pdag, t)
% returns the Markov Blanket of a pdag.

inT =  pdag(:, t)'; outT= pdag(t, :);

childT = outT&~inT;
spouseT  = any(pdag(:, childT),2)';
spouseT(t) =false;

mbT = find(inT|outT|spouseT);
    
end

