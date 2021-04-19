function [pygivz, instances, configs] = estimateCondProbJTvals(y, z, zvals, jtalg, varargin)
% [pygivz, instances, configs] = estimateCondProbJTvals(y, z, zvals, jtalg, varargin)
% estimate probability y|z=zvals from log joint probability distribution
% configs: configurations of the conditioning set.
[analytic, domainCounts] = process_options(varargin, 'analytic', false, 'domainCounts', []);
if analytic 
     if length(y)==1
        pygivz = jtalg.getConditionalProbabilities(y-1, z-1, zvals);
        instances = [0:length(pygivz)-1]';
        nInst= size(instances, 1);
        configs = [instances repmat(zvals, nInst, 1)];
     else
        pygivz = nan(prod(domainCounts(y)), 1);
        instances = variableInstances(domainCounts(y), false)-1;
        nInst= size(instances, 1);
        configs = [instances repmat(zvals, nInst, 1)];
        logpz = log(jtalg.getJointProbability(z-1, zvals));
        for iInst =1:nInst
            logpyz = log(jtalg.getJointProbability([y z]-1,configs(iInst, :)));
            pygivz(iInst) = exp(logpyz-logpz);
        end
     end  
else
    if length(y)==1
        pygivz = jtalg.getConditionalProbabilities(y-1, z-1, zvals);
        instances = [0:length(pygivz)-1]';
    else
        tmp =jtalg.getConditionalProbabilities(y-1, z-1, zvals);
        pygivz = tmp.getProbabilities;
        instances = tmp.getValues;
    end
end
end
