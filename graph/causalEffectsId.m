function [id, tline] = causalEffectsId(smm, x, y, z)
    %  runs Shpitser;s ID algoritm in R package causalpath.
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
    fprintf(fid, 'simplify =TRUE)\n');
    %= find(smm==2W1 -+ X, W1 -+ Z, X -+ Z, Z -+ Y, X -+ Y, Y -+ X, + simplify = FALSE)
    fprintf(fid, 'fig1 <- set.edge.attribute(graph = fig1, name = "description", index = %d:%d, value = "U")\n', nDir+1,nDir+nBDir);
    
    fprintf(fid, 'ce1 <- causal.effect(y = ');
    fprintf(fid, writeRvarmat(y));
    fprintf(fid, ', x = ');
    fprintf(fid , writeRvarmat(x));
    fprintf(fid, ', z = ');
    if isempty(z)
        fprintf(fid, "NULL");
    else
        fprintf(fid, writeRvarmat(z));
    end
    fprintf(fid, ', G = fig1, expr = TRUE, simp=TRUE)\n');
    %fprintf(fid, 'ce1 <- causal.effect(y = "X2", x = "X1", z = "X4", G = fig1, expr = TRUE, steps =)\n');
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
    str = ['c(' sprintf('"X%d", ', x(1:end-1)), sprintf('"X%d"', x(end)) ')'];
end

end