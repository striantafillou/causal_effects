function [] = rMatrix(graph, N, type)

sprintf('dag<-matrix(0, %d, %d)\n', N, N)

if isequal(type, 'dag')
    graph =graph';
end
[x, y] = find(graph);
for i=1:length(x)
    fprintf('graph[%d, %d]<-%d\n;', x(i), y(i),  graph(x(i), y(i)));
end

