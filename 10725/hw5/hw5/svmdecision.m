%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% svmdecision

function [ylabel,yval] = svmdecision(x,alpha,X,Y,C,sigma,b)

[d,n] = size(X);

yval = 0;
for i  = 1:n
    yval = yval + alpha(i)*Y(i)*kernel(X(:,i),x,sigma);
end
yval = yval  +b;

ylabel = sign(yval);
