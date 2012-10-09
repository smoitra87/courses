%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs soft thresholding or acts as the prox function on theta

function[theta2]  = softthresholder(lambda,theta)

[m,n] = size(theta);
theta_diag = diag(theta);
theta_diag2 = theta-diag(diag(theta));
case1 = lambda*(theta_diag2 > lambda*ones(m));
case2 = lambda*(theta_diag2 < -lambda*ones(m));
case3 = ones(m)-(theta_diag2>=-lambda*ones(m) & theta_diag2<=lambda*ones(m));
theta2 = theta_diag2.*case3 - case1 + case2 + diag(theta_diag);

end

