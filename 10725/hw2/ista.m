%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iterative soft thresholding algorithm
function [ll_list,theta_final] = ista(S,lambda,K,t)

[p,bla] = size(S);
theta_old = eye(p,p);
theta_new = theta_old;
ll_list = zeros(K,1);

for k = 1:K

    theta_old = theta_new;
    ll_list(k) = ll_l1(S,theta_old,lambda);
    grad_diff = S - inv(theta_old)'; % find grad of differentiable part
    theta_new1 = theta_old - t*grad_diff ;% Take a step in grad_diff dir
    theta_new  = softthresholder(lambda*t,theta_new1); % Apply prox function
end 

theta_final = theta_new;


end
