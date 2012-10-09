function [ ll ] = ll(S,theta)
% log-likelihood
%   Calculates log likelihood

ll = log(det(theta)) - trace(S*theta);
end

