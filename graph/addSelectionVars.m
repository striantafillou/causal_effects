function seldag = addSelectionVars(dag, isSelected, nVars)
% function seldag = addSelectionVars(dag, isSelected, nVars);
% for each selection variable, adds a dummy Xs->S
nSelected = sum(isSelected);
seldag = zeros(nVars+nSelected+1);
seldag(1:nVars, 1:nVars)=dag;
selVar = nVars;
for iVar=1:nVars
    if isSelected(iVar)
        selVar = selVar+1;
        seldag(iVar, selVar)=1;
    end
end
seldag(nVars+1:nVars+nSelected, nVars+nSelected+1)=1;
end