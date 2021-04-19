function lnXpluslnY = sumOfLogs(ln_x, ln_y)
% This function takes ln(x) and ln(y) as input, and returns ln(x + y) as output.
MAXEXP = log(realmin); %the smallest exponent that can be represented in the current computer
sorted= sort([ln_x, ln_y], 'descend');
ln_x = sorted(1); ln_y=sorted(2);

ln_yMINUSln_x = ln_y - ln_x;
if ln_yMINUSln_x < MAXEXP 
    lnXpluslnY = ln_x;
else
    lnXpluslnY = log(1 + exp(ln_yMINUSln_x)) + ln_x;    
end

