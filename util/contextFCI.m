function [imb, sameasCMB, pag]= contextFCI(obsDataset, expData)

    nObs = size(obsDataset.data,1);
    nExp = size(expData, 1);
    data = [obsDataset.data zeros(nObs, 1) ; expData ones(nExp, 1)];
    dataset = obsDataset;
    dataset.data = data;
    dataset.isLatent = [dataset.isLatent false];
    dataset.domainCounts = [dataset.domainCounts 2];
    sameasCMB =false;

    pag = FCI(dataset);
    asmm = pag2mag(pag.graph);
    man_smm = manipulatesmm(asmm, 1);
    smm_under = asmm; smm_under(1, 2)=0;smm_under(2, 1)=0;

    imb = findMBsmm(man_smm, 2);
    imb_nox = setdiff(imb, [1 size(man_smm,1)]);
    if  ismseparated(2, smm_under, 1, imb_nox)
        sameasCMB=true;
    end
    imb=imb_nox;
end