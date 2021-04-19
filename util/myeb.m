clear; 
nVars=20; 
nIters=20;
N=10000;
x=1;y=2;
doNs  = [50 100 500];nDoNs = length(doNs);
nSamplIters =1000;
[ygivdoxEstx0, ygivdoxEstx1, ygivdoxEstx2,...
    ygivdoxPredx0, ygivdoxPredx1, ygivdoxPredx2, ygivdoPredx2B,ygivdoPredx2Do,...
    ygivdoPredx2None, ygivdoPredx2All] = deal(nan(3, nIters, nDoNs));
Xvals=0:0.05:1;
meanEdge =nan(nIters,1);
iter=1;
allcount =0;
while iter<nIters+1
    allcount=allcount+1;
    tic;
    % pick a dag at random and find pdag
    dag = randomdagWith12(nVars,4);
    printedgesdag(dag)
    pdag = dag_to_cpdag(dag);
    meanEdge(iter) = nnz(dag);
    [nGdagsT, gdagsT] = Markov_equivalent_dags(dag);    
    posParX = find(pdag(:, 1))';nPosParX = length(posParX);
    nSets = 2^nPosParX;
    % initialize  matrices
    [logprobDegivDoHw0, logprobDegivUni0, logprobDegivDoHw1, ...
        logprobDegivUni1,logprobDegivDoHw2,logprobDegivUni2, probHwGes, probDoNHwGes, ...
            preddist0, preddist1, preddist2, probHwGes0, probHwGes1,...
            nwGes, nwGes2, nwGesB, nuGes0, nuGes1, nuGes2, nuGesB] = deal(nan(1, nSets));
    [ygivdoxASx0_i, ygivdoxASx1_i, ygivdoxASx2_i] = deal(nan(3, nSets));
    isAST = false(nGdagsT, nSets);isAncIndsT=false(nGdagsT,1);trueAs = false(1, nSets);
    allSubsets = false(nSets, nVars);
    count=2;
    for iSetN =1:nPosParX
        combos = nchoosek(posParX, iSetN); nCombos = size(combos,1);
        for iC =1:nCombos
            allSubsets(count, combos(iC, :))=true;
            count=count+1;
        end
    end
    for iSet =1:nSets
        curSet = find(allSubsets(iSet, :));  
        trueAs(iSet) = isAdjustmentSet(1, 2, curSet, dag);

        for iDag =1:nGdagsT
            curDag = gdagsT{iDag};
            % look among possible parents of x
            allAnc = transitiveClosureSparse_mex(sparse(curDag));
            isAncIndsT(iDag)=allAnc(1,2);
            if isAncIndsT(iDag)
                isAST(iDag, iSet) = isAdjustmentSet(1,2,curSet, curDag);
            end  
        end
    end
    if sum(isAncIndsT)==1;continue;end
    probDoHwTrue= sum(isAST(isAncIndsT, :))./sum(isAncIndsT);
    
    if any(probDoHwTrue==1)
        continue;
    end

    [nodes, domainCounts] = dag2randBN(dag, 'discrete', 'maxNumStates', 3*ones(nVars, 1), 'minNumStates', 3*ones(nVars, 1));
    obsDataset = simulatedata(nodes, N, 'discrete', 'domainCounts', domainCounts);
    
    expDs0 = simulateDoData(nodes, 1, 0, 10000, 'discrete', 'domainCounts', domainCounts); 
    pTrue0(:, iter) =  histc(expDs0.data(:,y) , 0:domainCounts(y)-1)./10000;
    expDs1 = simulateDoData(nodes, 1, 1, 10000, 'discrete', 'domainCounts', domainCounts); 
    pTrue1(:, iter) =  histc(expDs1.data(:,y) , 0:domainCounts(y)-1)./10000;
    expDs2 = simulateDoData(nodes, 1, 2, 10000, 'discrete', 'domainCounts', domainCounts); 
    pTrue2(:, iter) =  histc(expDs2.data(:,y) , 0:domainCounts(y)-1)./10000;
    
    for iDoN=1:nDoNs
        doN = doNs(iDoN);
        % Estimate \hat p(y|do(x))
        ygivdoxEstx0(:, iter, iDoN) = histc(expDs0.data(1:doN,y) , 0:domainCounts(y)-1)./doN;
        ygivdoxEstx1(:, iter, iDoN)  = histc(expDs1.data(1:doN,y) , 0:domainCounts(y)-1)./doN;
        ygivdoxEstx2(:, iter, iDoN)  = histc(expDs2.data(1:doN,y) , 0:domainCounts(y)-1)./doN;

        for iSet = 1:nSets
            curSet = find(allSubsets(iSet, :));
            if probDoHwTrue(iSet)==0
                [nwGes(iSet),  nwGesB(iSet)]=deal(-inf);
                continue;
            end
            [logprobDegivDoHw0(iSet), logprobDegivUni0(iSet)] = ...
                scoreExperimental(x, 0,  y, curSet, expDs0.data(1:doN,:), obsDataset.data, domainCounts, nSamplIters);
            [logprobDegivDoHw1(iSet), logprobDegivUni1(iSet)] = ...
                scoreExperimental(x, 1,  y, curSet, expDs1.data(1:doN,:), obsDataset.data, domainCounts, nSamplIters);
            [logprobDegivDoHw2(iSet), logprobDegivUni2(iSet)] = ...
                scoreExperimental(x, 2,  y, curSet, expDs2.data(1:doN,:), obsDataset.data, domainCounts, nSamplIters);

            nwGesB(iSet) = logprobDegivDoHw0(iSet)+logprobDegivDoHw1(iSet)+log(probDoHwTrue(iSet));
            nwGes(iSet) = logprobDegivDoHw0(iSet)+logprobDegivDoHw1(iSet)+logprobDegivDoHw2(iSet)+log(probDoHwTrue(iSet));
            %probHwGes(iter,iSet) = exp(nwGesB(iter,iSet)-sumOfLogs(nwGesB(iter,iSet), nuGesB(iter,iSet))); 

            ygivdoxASx0_i(:, iSet)= backdoor_adjustment(y, x, curSet, 0, obsDataset);
            ygivdoxASx1_i(:, iSet) = backdoor_adjustment(y, x, curSet, 1, obsDataset);
            ygivdoxASx2_i(:, iSet) = backdoor_adjustment(y, x, curSet, 2, obsDataset);

            preddist0(iSet) = sum(abs(ygivdoxASx0_i(:, iSet)-pTrue0(:, iter)));
            preddist1(iSet) = sum(abs(ygivdoxASx1_i(:, iSet)-pTrue1(:, iter)));
            preddist2(iSet) = sum(abs(ygivdoxASx2_i(:, iSet)-pTrue2(:, iter)));
            
        end % end for iSet
        % select best adjustment sets
        [~, bestInd(iter)] = nanmax(nwGes);
        [~, bestIndB(iter)] = nanmax(nwGesB);
        [~, bestIndDo(iter)] = nanmax(probDoHwTrue);
        
        hat_preddist0(iter, iDoN) = sum(abs(ygivdoxEstx0(:, iter, iDoN)-pTrue0(:, iter)));
        hat_preddist1(iter, iDoN) = sum(abs(ygivdoxEstx1(:, iter, iDoN)-pTrue1(:, iter)));
        hat_preddist2(iter, iDoN) = sum(abs(ygivdoxEstx2(:, iter, iDoN)-pTrue2(:, iter)));

        pdists = preddist1+ preddist2+preddist0;
        pdistshat(iter,iDoN) = hat_preddist0(iter, iDoN)+hat_preddist1(iter, iDoN)+hat_preddist2(iter, iDoN);
% 
%         [~, ~, ~,aucGes(iter,iDoN)] = perfcurve(trueAs(iter,:), nwGes(iter,:), 1, 'XVals', Xvals, 'UseNearest', 'off');
%         [~, ~, ~,aucGesDo(iter,iDoN)] = perfcurve(trueAs(iter,:), probDoHwTrue(iter,:), 1, 'XVals', Xvals, 'UseNearest', 'off');
%        [aucGes(iter,iDoN)'  aucGesDo(iter,iDoN)']
        % dexpdist = sum(preddist0(best
        [pdists(bestInd(iter)) min(pdists(trueAs>0)) max(pdists(probDoHwTrue>0))]
        
        diffs(iter, :, iDoN) =  [pdists(bestInd(iter)) min(pdists(trueAs>0)) max(pdists(probDoHwTrue>0))];
        timeAlg(iter, iDoN)=toc;
    end % end for iDoN
fprintf('Finished iteration %d %.3f\n', iter, toc);
iter = iter+1;

end


%%

figure;box on;hAxes =gca;

hold all;

colors = {'b', 'r', 'r'};
linestyles = {'-', ':','--', '-.'};
iN=0;
mL = squeeze(nanmean(diffs(:, 1, :)))./3;
minL = squeeze(nanmean(diffs(:, 2, :)))./3;
maxL = squeeze(nanmean(diffs(:, 3, :)))./3;
hCI    = patch([1:nDoNs,fliplr(1:nDoNs)], [minL',fliplr(maxL)'], [.8 .8 .8], 'EdgeColor', 'none');
hPl = plot(1:nDoNs, mL, 'linestyle', linestyles{2}, 'linewidth',2);
hPlhat = plot(1:nDoNs, nanmean(pdistshat./3), 'linewidth',2);
leg1 =legend(hAxes, [hPl, hPlhat, hCI], {'$Alg 2$','$\hat P(y|do(x)) \textnormal{ in }D_{exp}$','$D_{exp}+D_{obs} \textnormal{ independence constraints}$'}, 'Interpreter', 'Latex',...
     'Location', 'NorthWest');

% ax2 = copyobj(hAxes,gcf);
% delete( get(ax2,'Children') ) 
% set(ax2, 'Color', 'none', 'XTick',[],'YTick', [],'Box','off')   %# make it transparent
% leg2 =legend(ax2, h(2, :), {'$\hat P(y|do(2))$','$D_{do(x=0,1,2)},D_o$','$D_o$'}, 'Interpreter', 'Latex',...
%      'Location', 'NorthEast');
% title(leg2, 'N=10K')

hAxes.XTick =[1:nDoNs];
hAxes.XLim =[.8 nDoNs+0.2];
hAxes.YLim =[0 0.3];

set(hAxes, 'XTickLabel', doNs)
set([hAxes.YAxis, hAxes.XAxis], ...
'FontName'   , 'Helvetica', ...
'FontSize'   , 12          );
ylabel('Distribution Difference', 'Interpreter', 'latex','FontSize', 14)
xlabel('$N_{do(l)}$', 'Interpreter', 'latex','FontSize', 20)

% set([leg1, leg2], ...
% 'Color'    , 'white',...
% 'FontSize'   , 12          );
% % set([hAxes.YLabel, hAxes.XLabel], ...
% % 'FontName'   , 'Helvetica');% ...
% % 'FontSize'   , 20         );
% set(hAxes, ...
% 'Box'         , 'off'     , ...
% 'TickDir'     , 'out'     , ...
% 'TickLength'  , [.02 .02] , ...
% 'XMinorTick'  , 'on'      , ...
% 'YMinorTick'  , 'on'      , ...
% 'YGrid'       , 'on'      , ...
% 'XColor'      , [.3 .3 .3], ...
% 'YColor'      , [.3 .3 .3], ...
% 'LineWidth'   , 1         );
ax2.Position=hAxes.Position;
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

