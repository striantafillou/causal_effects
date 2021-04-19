function marginal =sumOverDims(joint,vars)
% marginal =sumOverDims(joint,vars)
% sums over variables vars in jpd joint.

vars = sort(vars, 'descend');
marginal = joint;
for iVar = vars
    marginal = sum(marginal,iVar);
end
marginal = squeeze(marginal);

%test
% if length(vars)>1
%     marginal = permute(marginal, order);
% end
end