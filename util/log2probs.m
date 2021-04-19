function probs =log2probs(log_vector)
% coverts vector of logs to probabilities
probs = exp(log_vector-logsumexp(log_vector));
end