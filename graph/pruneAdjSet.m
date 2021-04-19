function z_dot =pruneAdjSet(z, obsDataset)
% z_dot =pruneAdjSet(z, obsDataset)
% Implements the pruning rule in Henckel et al 2019 (optimal adjustment
% sets)/takes as input a valid adjustment set and returns a subset that is
% also a valid adjustment set.

z_dot = z;
if isempty(z_dot);return;end
for zi = z
    if msep(2,zi, setdiff([1 z_dot], zi), obsDataset)
        z_dot = setdiff(z_dot,zi);
    end
end
% if ~isequal(z, z_dot)
%     disp(z)
%     disp(z_dot)
% end
    