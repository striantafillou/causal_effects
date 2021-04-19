function [visible] = findVisibleEdges(M)
%author @borbudak
nnodes = size(M,1);

M_dir = M == 2 & M' == 3;
total_dir = sum(M_dir(:));

M_bidir = M == 2 & M' == 2;

M_e = M_dir | M_bidir;

visible = false(nnodes);
Q = zeros(total_dir,2);
curq = 0;

[X, Y] = find(M_dir);

for i = 1:total_dir
    for j = 1:nnodes
        if M_e(j,X(i)) && ~M_e(j,Y(i))
            visible(X(i),Y(i)) = 1;
            curq = curq + 1;
            Q(curq,1) = X(i);
            Q(curq,2) = Y(i);
            break;
        end
    end
end

while curq
   X = Q(curq,1);
   Y = Q(curq,2);
   curq = curq - 1;

   W = find(M_bidir(:,X) & M_dir(:,Y) & ~visible(:,Y));
   len = length(W);
   if(len > 0)
       visible(W,Y) = 1;
       Q(curq+1:curq+len,1) = W;
       Q(curq+1:curq+len,2) = Y;
       curq = curq + len;
   end
end

end