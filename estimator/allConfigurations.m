function jointInstances = allConfigurations(nVars, domainCounts)

for i=1:nVars
    vals{i} = 1:domainCounts(i);
end
jointInstances = combvec(vals{:})';
end