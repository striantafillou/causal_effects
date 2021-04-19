function [PCP, Gpbd] = getProperBackDoorGraph(G, X, Y)

% van der Zander, 2014
% you need to remove all edges that lie in proper causal paths from X to Y,
% all nodes from X to PCP(X, Y) = Desc_X\X in \overbar G \intersection Anc
% X in underbar G

N= size(G,1);nX = length(X);
XPa = G(:,X)==1;
XChild =G(X, :)'==1;
[G_over, G_under, Gpbd] = deal(G);

for iX = 1:nX

G_over(XPa(:, iX), X(iX)) =0; G_over(X(iX), XPa(:, iX)) =0; % remove all edges into X

G_under(X(iX), XChild(:, iX)) =0; G_under(XChild(:, iX), X(iX)) =0; % remove all edges out of X
end

allDesc_G_over = transitiveClosureSparse_mex(sparse(G_over')); % get all descendants in G_over
allDesc_G_over(1:N+1:N^2)=true;% include X is descendant of X
Desc_X_G_over = ~~(sum(allDesc_G_over(:, X),2));

allAnc_G_under =  transitiveClosureSparse_mex(sparse(G_under));% get all ancestors  in G_under
allAnc_G_under(1:N+1:N^2)=true;% include X is ancestor of X
Anc_Y_G_under = ~~(sum(allAnc_G_under(:, Y),2));

PCP =  find(Anc_Y_G_under & Desc_X_G_over); %van der Zander, $4.1: PCP(X, Y) = De_\overbar{X}(X)\setminus X \intersect An_\underbar{X}(Y)

% Remove all edges from X to PCP
Gpbd(X, PCP) = 0;
Gpbd(PCP, X) = 0;


end
