%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate L1 norm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [l1_norm_list]  = calc_l1_norm(theta_list)

[nlambda,p,bla] = size(theta_list);
l1_norm_list = zeros(nlambda,1);

for  i = 1:nlambda
    theta = squeeze(theta_list(i,:,:));
    l1_norm_list(i) = sum(sum(abs(theta-diag(diag(theta)))));
end