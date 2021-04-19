function doProb= estimateDoProb(y, x, z, nodes, domainCounts)
% Estimates interventional probability P(y|do(x)) for adjustment set z.
% only tested with z=1;
if isempty(z)
    doProb=estimateCondProb(y, x, nodes, domainCounts);
else

    nVars =  size(nodes,1);
    joint= estimateJoint(nodes, domainCounts(1:nVars));
    % find indices for matrix reshapes
    %[~, inds] = sort([y x z]); 
    %indY = inds(1); indX = inds(2); if ~isempty(z);indZ=inds(3:end);else; indZ =[];end
    remInds = setdiff(1:nVars, [y x z]);
    %nRem = length(remInds);

    % reshape joint so that you have p(y, x, z, remInds)
    joint  = permute(joint, [y x z remInds]);

    remInds = length([x y z])+1:nVars;

    % estimate condprob x given z
    p_xz = sumOverDims(joint, [1 remInds]); % setdiff(1:nVars, [x z])
    p_z = sumOverDims(joint, [1 2 remInds]);
    p_yxz = sumOverDims(joint, remInds);

    %pygivxz = permute(rdivide(permute(p_yxz, [indY  indX indZ]), p_xz'),  [indY indX indZ]);
    pygivxz = permute(p_yxz, [2:length([x y z]), 1])./p_xz;

    pygivxz2 = permute(pygivxz, [2:length([x y z]),1]); % send x to back 

    doProb = pygivxz2.*p_z;
    for i=1:length(z)
        doProb = sum(doProb);
    end
    doProb = squeeze(doProb);
end
% for iX = 1:domainCounts(x)
%     pygivxvalz = pygivxz(:, iX, :);
%     doProb(:,iX) = sum(squeeze(pygivxvalz).*p_z',2);
% end
