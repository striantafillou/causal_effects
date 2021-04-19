function p_y_do_xval = backdoor_adjustment(y, x, z, xval, dataset, varargin)
% FUNCTION p_y_do_xval = backdoor_adjustment(y, x, z, xval, dataset)
% Estimate causal effect P(Y|do(xval))using backdoor ajdustment on adjustment set z on
% dataset dataset
%
% Author: sot16@pitt.edu
% 
if isstruct(dataset)    
    data = dataset.data;
    domainCounts = dataset.domainCounts;
else 
    data=dataset;
    domainCounts = varargin{1};
end

if isempty(xval)
   p_y_do_xval = nan(domainCounts(y), domainCounts(x));
   for xval=0:domainCounts(x)-1
   p_y_do_xval(:, xval+1) = backdoor_adjustment(y, x, z, xval, data, domainCounts);
   end
else
    % Proceed with computation of G^2 statistic
    xData = data(data(:, x)==xval, :);

    k = size(xData,1);

    % if k < 5*prod(domainCounts([y z]))
    %    p_y_do_xval = nan;
    %    fprintf(' Not enought sample \n');
    %    return;
    % end

    y_z_indexset = [y z];
    prior_y_z = prod(domainCounts(y_z_indexset));
    prior_z = prod(domainCounts(z));
    prior_y = domainCounts(y);
    % See pages 17-50 in the Matlab manual for this calculation.
    % Try to understand first how hits_x_y_z is calculated
    % the rest are the similar.
    bases_y_z = zeros(1, 1+length(y_z_indexset));
    bases_y_z(2:end) = cumprod(domainCounts(y_z_indexset));
    bases_y_z(1) = 1;
    bases_y_z(end) = [];

    bases_z = zeros(1, 1+length(z));
    bases_z(2:end) = cumprod(domainCounts(z));
    bases_z(1) = 1;
    bases_z(end) = [];

    hits_y_z = xData(:, y_z_indexset) * bases_y_z' + 1;
    hits_zX = xData(:, z) * bases_z' + 1;
    hits_z = data(:, z)* bases_z'+1;

    y_z_counters = histc(hits_y_z, [1:prior_y_z]);
    y_z_counters = y_z_counters(:);
    zX_counters = histc(hits_zX, [1:prior_z]);
    if ~isrow(zX_counters)
        zX_counters = zX_counters';
    end
    noObsCols = zX_counters==0;%find
    % if ~isempty(noObsCols)
    %     warning('No observations with x = %d and Z config = %s,will assume uniform\n', xval, num2str(noObsCols)); 
    % end
    zX_counters = repmat(zX_counters, prod(domainCounts(y)), 1);
    zX_counters = zX_counters(:);

    z_counters = histc(hits_z, [1:prior_z]);
    z_counters = z_counters';
    z_counters = repmat(z_counters, prod(domainCounts(y)), 1);
    z_counters = z_counters(:);

    py_giv_z = reshape(y_z_counters./zX_counters, prior_y, prior_z);

    py_giv_z(:, noObsCols) = 1/(prior_y);
    p_z = reshape(z_counters./size(data,1), prior_y, prior_z);
    p_y_do_xval = nansum(py_giv_z.*p_z, 2);
end
end


