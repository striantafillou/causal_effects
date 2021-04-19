function dist = shd(tru, est)
    dist = sum(sum(tru==0 & est==1) + sum(tru==1 & est==0));
end