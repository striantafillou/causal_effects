function marginal =sumOverDimsLog(joint,vars)
% marginal =sumOverDimsLog(joint,vars)
% sums over variables vars in log jpd joint.

vars = sort(vars, 'descend');
marginal = joint;
for iVar = vars
    marginal = logsumexp(marginal,iVar);
end
marginal = squeeze(marginal);

%test
% if length(vars)>1
%     marginal = permute(marginal, order);
% end
end