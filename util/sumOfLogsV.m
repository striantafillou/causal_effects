function sLogs =sumOfLogsV(lns)

% This function takes ln(v1), .., ln(vn) as input, and returns ln(v1+ v2+...+vn) as output.
nVals = length(lns);
maxExp = log(realmin); %the smallest exponent that can be represented in the current computer
sorted= sort(lns, 'descend');
ln_x = sorted(1); ln_y=sorted(2);
sLogs = sumLogs(ln_x, ln_y, maxExp);
for i =3:nVals
  sLogs= sumLogs(sLogs, lns(i), maxExp);
end
end


function lnXpluslnY = sumLogs(ln_x, ln_y, maxExp)
% This function takes SORTED ln(x) and ln(y) as input, and returns ln(x + y) as output.
ln_yMINUSln_x = ln_y - ln_x;
if ln_yMINUSln_x < maxExp 
    lnXpluslnY = ln_x;
else
    lnXpluslnY = log(1 + exp(ln_yMINUSln_x)) + ln_x;    
end
end
