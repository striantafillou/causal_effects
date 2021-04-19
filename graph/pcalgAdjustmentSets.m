function adjSets = pcalgAdjustmentSets(graph, x, y, type, setType)

fid = fopen([pwd '\rCode.R'], 'wt');
N = size(graph, 1);

fprintf(fid, 'library("pcalg")\n');
fprintf(fid, 'graph<-matrix(0, %d, %d)\n', N, N);
if isequal(type, 'dag')
    graph =graph';
end
[from, to] = find(graph);
for i=1:length(from)
    fprintf(fid, 'graph[%d, %d]<-%d;\n', from(i), to(i),  graph(from(i), to(i)));
end

fprintf(fid, 'adjustment(amat = graph, x = %d, y = %d, amat.type = \"%s\", set.type = \"%s\")\n', x, y, type, setType);

fclose(fid);
system('"C:\Program Files\R\R-3.5.2\bin\Rscript.exe" rCode.R > rOut.txt');

fout = fopen('rOut.txt', 'r');

adjSets =false(N^2, N);
tline = fgetl(fout);
    if isequal(tline, 'list()')||isequal(tline, 'named list()')
        adjSets =[];
        return;
    elseif isequal(tline, '[[1]]')|| isequal(tline, '$`1`')
        count =1;
        tline2 = fgetl(fout);
        adjSets(count, str2num(tline2(4:end)))= true;
        fgetl(fout); % skip the empty line
        while ~feof(fout)
            count=count+1;
            tline1 = fgetl(fout);
            tline2 = fgetl(fout);
            adjSets(count, str2num(tline2(4:end)))= true;
            fgetl(fout); % skip the empty line
        end
        if count>1 && (count ~= str2double(tline1(3:end-2))&& count~= str2double(tline1(3:end-1)))
            error('wrong count in adjustment sets');
        end
    else
        error('Unexpected r output');
    end
    adjSets = adjSets(1:count,:); 
fclose(fout);
end
