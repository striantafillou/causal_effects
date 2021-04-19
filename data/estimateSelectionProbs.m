function pSgivW = estimateSelectionProbs(p_e, p_b)
%estimates 
p_e = reshape(p_e, [], 1);
p_b = reshape(p_b, [], 1); %make sure they are both column vectors
pSgivW = (p_e./p_b)./max(p_e./p_b);
end