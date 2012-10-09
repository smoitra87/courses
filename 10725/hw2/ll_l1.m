%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the L1 normed log likelihood

function [ ll ] = ll_l1(S,theta,lambda)
% log-likelihood
%   Calculates l1 normed log likelihood

ll = -log(det(theta)) + trace(S*theta) + ...
        lambda*sum(sum(abs(theta-diag(diag(theta)))));
end

