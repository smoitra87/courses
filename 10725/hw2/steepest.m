%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Steepest Gradient Descent


clear all;

%% Load the data and calculate stats

load('q4.mat');
[m,p] = size(Xtrain);
Xtrainmean = mean(Xtrain,1);
Xcent = Xtrain - repmat(Xtrainmean,m,1);
S = 1/(m-1)* (Xcent'*Xcent);
Xtestmean = mean(Xtest,1);
Xtestcent = Xtest - repmat(Xtestmean,m,1);
Stest = 1/(m-1) * (Xtestcent'*Xtestcent);

%%  Initialize the parms
K=5000;
theta_old = eye(p,p);
theta_new = theta_old;
t = 0.01;
ll_init = ll(S,theta_old);
ll_old = zeros(K,1);
theta_list = zeros(K,p,p);


%% Run the algo

for k = 1:K
    theta_list(k,:,:) = theta_old;
    theta_old = theta_new;
    ll_old(k) = ll(S,theta_old);
    ll_old_test(k) = ll(Stest,theta_old);
    grad = S' - inv(theta_old)';
    % find index of steepest gradient
    [idx,idy] = find(abs(grad)>=max(max(abs(grad))));
    step = zeros(p,p);
    step(idx,idy) = t*sign(grad(idx,idy));
    theta_new  = theta_old - step;
    %ll_new = ll(S,theta_new);
    %assert(ll_new >= ll_old);
    %ll_new_test = ll(S,theta_new);
%     if mod(k,100)==0 
%         figure();
%         imagesc(theta_old);
%     end
    
end 

%% Plot the results
figure();
plot(1:K,ll_old,1:K,ll_old_test);
xlabel('Num Iterations');
ylabel('Log likelihood');
legend('ll train','ll test');
saveas(gcf,'ll.png','png');
figure();
spy(theta_old);
title('Sparsity Pattern');
xlabel('Variable id');
ylabel('Variable id');
saveas(gcf,'sp.png','png');

%% Plot the coeffs

% calc l1 norm list of ISTA
l1_norm_steep = calc_l1_norm(theta_list);

% Calculate the coefficient profile

plot_steep_coeff = zeros(K,p*p);
for i = 1:K
     X = squeeze(theta_list(i,:,:));
     X = X -diag(diag(X));
     X = triu(X);
     X = reshape(X,[1,p*p]);
     plot_steep_coeff(i,:) = X;
end


figure();
plot(l1_norm_steep,plot_steep_coeff);
title('Plot Steepest descent coefficeients');
xlabel('||P*Theta_{lambda}||_1');
ylabel('Off diagonal coefficients');
saveas(gcf,'partf_steep.png','png');


