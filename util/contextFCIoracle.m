% fci parameters
function [imb, sameasCMB]= contextFCIoracle(dag, isLatent)
    sameasCMB=false;

    smmr= dag2smm_rem(dag, isLatent);
    nV = sum(~isLatent);
    smmn= zeros(nV+1); smmn(1:nV, 1:nV) = smmr; smmn(nV+1, 1) = 2; smmn(1, nV+1)=3;
    dataset.isLatent = false(1, nV+1);
    dataset.isAncestor = definiteDescendantsPag(smmn);
    dataset.isManipulated = [false(1, nV) true] ;

    dataset.type = 'oracle';
    dataset.data = smmn;
    pag = FCI(dataset, 'test', 'msep', 'alpha', 0.1, 'maxK', nV-2, 'pdsep', true, ...
    'cons',  false, 'verbose', false);
    asmm = pag2mag(pag.graph);
    man_smm = manipulatesmm(asmm, 1);
    smm_under = asmm; smm_under(1, 2)=0;smm_under(2, 1)=0;

    imb = findMBsmm(man_smm, 2);
    imb_nox = setdiff(imb, 1);
    if  ismseparated(2, smm_under, 1, imb_nox)
        sameasCMB=true;
    end
end
    