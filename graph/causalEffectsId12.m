function [id, tline] = causalEffectsId12(smm)
    %  runs Shpitser;s ID algoritm in R package causalpath and returns
    %  P(X2|do(X1)).
    id=true;
    fid = fopen([pwd '\rCode.R'], 'wt');
    fprintf(fid, 'library("causaleffect")\n');
    fprintf(fid, 'library("igraph")\n');
    fprintf(fid, 'fig1 <- graph.formula(');
    [dirX, dirY] = find(smm==2&(smm'==3|smm'==4));
    nDir = size(dirX, 1);
    for iX=1:size(dirX, 1)
        fprintf(fid, 'X%d-+X%d,', dirX(iX), dirY(iX));
    end
    [bdirX, bdirY] = find((smm==2|smm==4)&(smm'==2|smm'==4));
    nBDir = size(bdirX, 1);
    for iX=1:size(bdirX, 1)
        fprintf(fid, 'X%d-+X%d,', bdirX(iX), bdirY(iX));
    end
    fprintf(fid, 'simplify =FALSE)\n');
    %= find(smm==2W1 -+ X, W1 -+ Z, X -+ Z, Z -+ Y, X -+ Y, Y -+ X, + simplify = FALSE)
    fprintf(fid, 'ce1 <- causal.effect(y = "X2", x = "X1", z = "NULL", G = fig1, expr = TRUE)\n');
    fprintf(fid, 'ce1\n');
    fclose(fid);
    system('"C:\Program Files\R\R-3.5.2\bin\Rscript.exe" rCode.R > rOut.txt');

    fout = fopen('rOut.txt', 'r');
    tline = fgetl(fout);
    if tline==-1
        id=false;
    end
    fclose(fout);
end


function str = writeRvarmat(x)
if length(x)==1
    str =sprintf('"X%d"', x);
else
    str = sprintf('c("X%d", "X%d")', x(1:end-1), x(end));
end

end