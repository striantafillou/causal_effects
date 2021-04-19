function doInds = getExperimentalInds(maxDoN, doNs, nDoNs, dc)

doInds = false(maxDoN*dc, nDoNs);
for iDoN=1:nDoNs
    doN = doNs(iDoN);
    for iDc=1:dc
        doInds((iDc-1)*maxDoN+1:(iDc-1)*maxDoN+doN, iDoN)= true;
    end
end
end