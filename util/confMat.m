function [sens, spec, tp, fp, tn, fn] = confMat(label, pred)

tp = sum(pred&label);
fp = sum(pred&~label);
tn = sum(~pred&~label);
fn = sum(~pred&label);

sens = tp./(tp+fn);
spec = tn./(tn+fp);
if isnan(sens); sens=1;end
if isnan(spec); spec=1; end
end