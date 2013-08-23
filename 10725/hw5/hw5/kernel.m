function val = kernel(x,y,sigma)
    val = exp(-sum((x-y).^2)/(2*sigma^2));

end