function [instProb, logProb] = estimateInstanceProb(instance, nodes)
% [instProb, logProb] = estimateInstanceProb(instance, nodes)
% estimates P(\bf V=bf V) using the BN factorization.
% nodes must be in order

instProb =1;
logProb= 0;

for i=1:length(instance)
    instval = instance(i);
    ipar = nodes{i}.parents;
    instpar = instance(ipar);
   %  fprintf('Node %d  with parents %s\n', i, num2str(instance(ipar)));
    % fprintf('Instance  %d given %s\n', instval, num2str(instpar));
%     
    cptinds = num2cell([instval, instpar]);
    curprob = nodes{i}.cpt(cptinds{:});
    % fprintf('\t and cond prob %.3f\n',curprob);

    instProb = instProb*curprob;
    logProb = logProb+log(curprob);
end