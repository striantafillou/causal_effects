function [discovered, distfromy, discoveredy, discoveredx] = bfsFromYtoX(smm, y,x)
% function [varorder, distfromy] = bfsFromYtoX(smm, y)
% runs bfs from y and reports min distance from y, keeps only nodes on a
% path to x

nVars = length(smm);
smmx  = smm; smmx(x,:)=0; smmx(:, x)=0;
smmy = smm; smmy(y, :) = 0; smmy(:, y)=0;

[discoveredy, distfromy] =bfs(smmx, y, nVars);
[discoveredx] =bfs(smmy, x, nVars);

discovered = discoveredx&discoveredy;discovered([x y])=true;
distfromy(~discovered)=-1;
end



function  [discovered, distfromy] =bfs(smm, y, nVars)
discovered = false(nVars,1);
distfromy = -1*ones(nVars,1);
dists = zeros(nVars,1);
q =[];
discovered(y)=true;
q(1) = y; distfromy(y)=0;
while ~isempty(q)
    curvar = q(1); q = q(2:end);
    curneigh = find(smm(curvar,:));
    dists(curneigh) = distfromy(curvar)+1;
    %fprintf('Var %d, curneigh [%s]\n', curvar, num2str(curneigh));
    for iNeigh=1:length(curneigh)
        if ~discovered(curneigh(iNeigh))
            discovered(curneigh(iNeigh))=true;
            distfromy(curneigh(iNeigh))= dists(curneigh(iNeigh));
            q = [q curneigh(iNeigh)];
            %fprintf('discovered %d through %d, dist [%d]\n', curneigh(iNeigh), curvar, dists(curneigh(iNeigh)));

        end
    end
end 
end

