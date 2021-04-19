function [id, p] = causalEffectsId12Aspout(directed, bidirected)
    %  runs Shpitser;s ID algoritm in R package causalpath for the smm
    %  read from 
    id=true;
    p=nan;
    fid = fopen([pwd '\rCode.R'], 'wt');
    fprintf(fid, 'library("causaleffect")\n');
    fprintf(fid, 'library("igraph")\n');
    fprintf(fid, 'fig1 <- graph.formula(');
    
    nDir = size(directed, 1);
    for iX=1:nDir
        fprintf(fid, 'X%d-+X%d,', directed(iX,1), directed(iX,2));
    end
    nBDir = size(bidirected, 1);
    for iX=1:nBDir
        fprintf(fid, 'X%d-+X%d,', bidirected(iX,1), bidirected(iX,2));
        fprintf(fid, 'X%d-+X%d,', bidirected(iX,2), bidirected(iX,1));

    end
    fprintf(fid, 'simplify =FALSE)\n');
    %= find(smm==2W1 -+ X, W1 -+ Z, X -+ Z, Z -+ Y, X -+ Y, Y -+ X, + simplify = FALSE)
    fprintf(fid, 'fig1 <- set.edge.attribute(graph = fig1, name = "description", index = %d:%d, value = "U")\n', nDir+1,nDir+2*nBDir);
    fprintf(fid, 'ce1 <- causal.effect(y = "X2", x = "X1", z = NULL, G = fig1, expr = TRUE)\n');
    fprintf(fid, 'ce1\n');
    fclose(fid);
    system('"C:\Program Files\R\R-3.5.2\bin\Rscript.exe" rCode.R > rOut.txt');

    fout = fopen('rOut.txt', 'r');
    tline = fgetl(fout);
    if tline==-1
        id=false;
    else
        p=tline;
    end
    fclose(fout);
end
