%finds all possible Ancstors of a node x in a graph
%that are on a proper path relative to nodeset Y (that is, that don't go through Y)
%m is the adjacency matrix
function pdp  =  possibleAncProper(m,x,y,possible)

% INPUT: adj.mat. m in MAG/PAG or DAG/CPDAG coding; node pos x;
% set of node pos y;
% If possible == TRUE, possible Anc. are found; o/w descendents are found
% OUTPUT: Node positions of (possible) descendents (ignoring path trough y); sorted
%q denotes unvisited nodes/ nodes in queue
%v denotes visited nodes
[q, v] = deal(zeros(length(m),1));
i=1;k=1;
q(i) = x;

while k<=i && q(k)~=0

t = q(k);
%mark t as visited
v(k) = t;
k = k+1;
%in this for cycle
%add all nodes that have a possibly directed
%edge with node t and all parents of node t to queue
for j=1:length(m) 
  if (possible) 
    % find possible ancestors
    collect = (m(j,t)==2| m(j, t)==1) & m(t, j)~=2;
  else
    % find ancestors
    collect = m(j,t)==2 & m(t,j)==3;
  end
  if (collect) 
    %only add nodes that haven't been added
    %and that are on a proper path
    if ~ismember(j, q) && ~ismember(j, y)%(j %in% q) & !(j %in% y))
      i = i+1;
      q(i) = j;
    end
   end
end

pdp = sort(setdiff(v,0));
end