function entrop=entrop(p)
entrop = p.*log(p)+(1-p).*log(1-p);
end