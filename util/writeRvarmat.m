function str = writeRvarmat(x)
%  str = writeRvarmat(x)
% Returns string "c(X%d, ...,X%d)" for all members X%d of x
if length(x)==1
    str =sprintf("X%d", x);
else
    str = sprintf('c("X%d", "X%d")', x(1:end-1), x(end));
end

end