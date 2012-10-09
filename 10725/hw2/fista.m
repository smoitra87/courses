%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iterative soft thresholding algorithm
function [ll_list,theta_final] = fista(S,lambda,K,t)

[p,bla] = size(S);
theta_old = eye(p,p);
theta_oldold = theta_old;
theta_new = theta_old;
ll_list = zeros(K,1);

for k = 1:K
    theta_oldold = theta_old;
    theta_old = theta_new;
    ll_list(k) = ll_l1(S,theta_old,lambda);
    % apply acceleration
    y = theta_old + (k-2)/(k+1)*(theta_old-theta_oldold);
    grad_diff = S - inv(y)'; % find grad of differentiable part
    theta_new1 = y - t*grad_diff ;% Take a step in grad_diff dir
    theta_new  = softthresholder(lambda*t,theta_new1); % Apply prox function
end 

theta_final = theta_new;


end
