function [adjv, sepSet] =adjV(X, dataset, test, heuristic, alpha, maxK, verbose)

    nVars =  size(dataset.data, 2);
    % allpvalues= nan(numVars*numVars, 1);
    % allpvalueCounter =0;
    %Step 0 Initialize variables.
    adjv= true(1, nVars);    
    sepSet =  zeros(nVars, nVars);

    pvalues = -ones(1, nVars);
    unistats = -ones(1, nVars);
    % dummy variable to denote whether we have checked an edge. Initially has
    % zeros everywhere except for the main diagonal.
    flagPag =  ones(size(pag));
    flagPag =  ~(tril(flagPag,-1)+ triu(flagPag, 1));

    %Step 1. skeleton search
    %Step 1a. find unconditional independencies

    for Y =  1:nVars;
        if Y==X
            continue;
        end       
        [p, s, exitflag] = feval(test, X, Y, [], dataset); 
        if p>alpha
            adjv(Y)=false;         
            if verbose 
                fprintf('\t Independence accepted: %d _||_ %d , %s\n', X, Y, num2str(p))
            end
        end
        pvalues(Y)=p;
        unistats(Y)= s;
    end


    if maxK  == -1
        maxCondSetSize =  nVars -2;
    else
        maxCondSetSize =  maxK;
    end

    unips = pvalues;
    n=0;
    while n<maxCondSetSize 
        n = n+1;
        if verbose
            fprintf('\t-------------k=%d---------\n', n);
        end
        % find edges in lexicographic order
        [neighborsX]=find(adjv);
        % for heuristic 2/3 sort edges by increasing order of association,
        % which means: higher p-values first, lower statistics first.
        if heuristic==3||heuristic==2
            edgepvals = unips(Ys);
            [~, ord] = sort([-edgepvals]);
            neighborsX = neighborsX(ord); 
        end
        for Y = neighborsX        
            if length(neighborsX)>=n-1
                condsets = nchoosek(setdiff(neighborsX,Y) n);
            end
            for iCS = 1:size(condsets, 1)
                condset = condsets(iCS, :);
                [p, ~, exitflag] = feval(test, X, Y, condset, dataset);
                nTests =nTests+1;
                if p>alpha    
                    adjv(Y)=false;   
                    sepSet(Y, condset)=true;
                    if verbose 
                        fprintf('\t\t\t Accepted %d with %d given %s, p-value %s\n',X,Y, num2str(condset), num2str(p))
                    end
                    break;
                end % end if p
            end % end for iCS
        end % end for Y
    end % end while n<maxK
end