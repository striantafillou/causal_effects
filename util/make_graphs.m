clear;clc;
nVarsOr =7;
dag = zeros(nVarsOr);
dag(1, 2)=1;
dag(3, [1 2]) =1;
dag(4, 2)=1;
dag(6, [1, 5]) =1;
dag(7, [2, 5]) =1;
printedgesdag(dag)
isLatent = false(1, nVarsOr);isLatent([6 7])=true;
save('mbiasplusgraph.mat');

%%
clear;clc;
nVarsOr =5;
dag = zeros(nVarsOr);
dag(1, 2)=1;
dag(4, [1, 3]) =1;
dag(5, [2, 3]) =1;
printedgesdag(dag)
isLatent = false(1, nVarsOr);isLatent([4 5])=true;
save('mbiasgraph.mat');

%% hidden conf
clear;clc;
nVarsOr =4;
dag = zeros(nVarsOr);
dag(1, 2)=1;
dag(3, [1 2]) =1;
dag(4, [1 2]) =1;
isLatent = false(1, nVarsOr);isLatent([4])=true;

save('hiddenconf.mat');

%%

clear;clc;
nVarsOr =4;
dag = zeros(nVarsOr);
dag(1, 2)=1;
dag(3, [1 2]) =1;
dag(4, 2)=1;
printedgesdag(dag)
isLatent = false(1, nVarsOr);
save('confandemgraph.mat');

%%


clear;clc;
nVarsOr =4;
dag = zeros(nVarsOr);
dag(1, 2)=1;
dag(3, [1 4]) =1;
dag(4, [2]) =1;
isLatent = false(1, nVarsOr);%isLatent([4])=true;

save('pathgraph.mat');

%% twoconfs
clear;clc;
nVarsOr =4;
dag = zeros(nVarsOr);
dag(1, 2)=1;
dag(3, [1 2]) =1;
dag(4, [1 2]) =1;
isLatent = false(1, nVarsOr);
save('twoconfs.mat');

%%
clear;clc;
nVarsOr =7;
dag = zeros(nVarsOr);
dag(1, 2)=1;
dag(4, [1, 3]) =1;
dag(5, [2, 3]) =1;
dag(6, [1, 3]) =1;
dag(7, [2, 3]) =1;
printedgesdag(dag)
isLatent = false(1, nVarsOr);isLatent([4 5 6 7])=true;
save('m2biasgraph.mat');
%%


clear; clc;
nVarsOr =5;
dag = zeros(nVarsOr);
dag(1, 2)=1;
dag(4, [1, 3]) =1;
dag(5, [2, 3]) =1;
[nodesOr, domainCountsOr] = dag2randBN(dag, 'discrete', 'maxNumStates', [2 2 2 2 2], 'minNumStates',[2 2 2 2 2]);
% p(y|do(x))
% 4:age
nodesOr{4}.cpt = [.8 .2]';
% 5: Gender F/M
nodesOr{5}.cpt = [0.5 0.5]';
% 3. Menopause (no/yes)
nodesOr{3}.cpt(:, 1,1) =[.9 .1];
nodesOr{3}.cpt(:, 2,1) =[.2 .8];

nodesOr{3}.cpt(:, 1,2) =[.2 .8];
nodesOr{3}.cpt(:, 2,2) =[.9 .1];


% Outcome (no, yes) treatment (no/yes), gender(F/M)
nodesOr{2}.cpt(:, 1,1) =[.89, 0.11];
nodesOr{2}.cpt(:, 1,2) =[.7, 0.3];
nodesOr{2}.cpt(:, 2,1) =[0.25, 0.75];
nodesOr{2}.cpt(:, 2,2) =[0.99, 0.01];

% treatment no/yes giv age
nodesOr{1}.cpt(:, 1) =[.9  .1];
nodesOr{1}.cpt(:, 2) =[0.1 .9];
isLatent  = [false false false true true];
%save mbias_bn.mat


joint = estimateJoint(nodesOr, domainCountsOr);
pm = estimateCondProbJoint(3,[], joint,5);
pmt = estimateCondProbJoint(3,1, joint,5);
fprintf('P(M|T): %.3f,   P(M): %.3f\n', pm(1), pmt(1));

pot = estimateCondProbJoint(2,1, joint,5);
potm = estimateCondProbJoint(2,[1 3], joint,5);

fprintf('P(O|T): %.3f, P(O|T, not M): %.3f  , P(O|T, M): %.3f\n', pot(2,2), potm(2,2, 1), potm(2,2,2));

doNodes = nodesOr;
doNodes{1}.parents=[];
doNodes{1}.cpt = ones(domainCountsOr(1), 1);
doJoint = estimateJoint(doNodes, domainCountsOr);
pydox =  estimateCondProbJoint(2,1, doJoint, nVarsOr);
% p(y|x)
joint = estimateJoint(nodesOr, domainCountsOr);
pot = estimateCondProbJoint(2,1, doJoint,5);
potm = estimateCondProbJoint(2,[1 3], doJoint,5);

fprintf('P(O|do(T)): %.3f, P(?|do(?), not M): %.3f  , P(?|do(?), M): %.3f\n', pot(2,2), potm(2,2, 1), potm(2,2,2));
% 
% clear;clc;
% nVarsOr =8;
% dag = zeros(nVarsOr);
% dag(1, 2)=1;
% dag(5, [1, 3]) =1;
% dag(6, [2, 3]) =1;
% dag(7, [1, 4]) =1;
% dag(8, [2, 4]) =1;
% printedgesdag(dag)
% isLatent = false(1, nVarsOr);isLatent([5 6 7 8])=true;
% smm = dag2smm(dag, isLatent);
% printedgesmcg(smm)
% save('m2biasgraph.mat');