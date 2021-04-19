function condProb = estimateCondProbJointLog(y, cond, joint, nVars)
% condProb = estimateCondProbJoint(y, cond, joint, nVars)
% estimate probability y|x from log joint probability distribution
nY = length(y);
% find indices for matrix reshapes
%[~, inds] = sort([cond y]); 
%indY = inds(end); indC = inds(1:end-1);
%[~, condOrder] = sort(cond);
remInds = setdiff(1:nVars, [y cond]); nCond = size(cond,2);
% reshape joint so that you have p(cond, x, remInds)
joint  = permute(joint, [cond y remInds]);
%margInds = 1+nCond:nVars;

%p_cond = sumOverDims(joint, [1 remInds]);
p_cond = sumOverDimsLog(joint, nCond+1:nVars)+eps;% setdiff(1:nVars, [x z]) % put y last so you can divide
%p_ycond = sumOverDims(joint, margInds(2:end));
p_ycond = sumOverDimsLog(joint, nY+nCond+1:nVars);


if isempty(cond)
    condProb = p_ycond;
else
    condProb2 = p_ycond-p_cond;
    condProb = permute(condProb2, [nCond+1:nCond+nY, 1:nCond]); % permute conditioning set in original order.
end
condProb = exp(condProb);

    
    
    % estimate condprob x given y
    % condProb = permute(rdivide(permute(p_ycond, [indY  indC]), p_cond'),  [indY indC]);
%     if nCond ==1
%         condProb = permute(rdivide(permute(p_ycond, [indY  indC]), p_cond'),  [indY indC]);
%     else
%         condProb = permute(rdivide(permute(p_ycond, [indY  indC]),  permute(p_cond, indC)),  [indY indC]);
%     end
%end
end