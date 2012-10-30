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
t = 0.00001;
nlambda=30;
lambda_list = logspace(log10(1),log10(30),nlambda);
ll_ista= zeros(nlambda,K);
ll_fista = zeros(nlambda,K);
theta_ista = zeros(nlambda,p,p);
theta_fista = zeros(nlambda,p,p);

%% Run the respective algorithms

for lambdaidx = 1:nlambda
    lambda = lambda_list(lambdaidx);
    [ll_ista(lambdaidx,:),theta_ista(lambdaidx,:,:)] = ista(S,lambda,K,t);    
    [ll_fista(lambdaidx,:),theta_fista(lambdaidx,:,:)] = fista(S,lambda,K,t);    
end 

% Specially calculate for 1.0826
lambda_woo =1.0826;   
[ll_ista_woo,theta_ista_woo] = ista(S,lambda_woo,K,t);    
[ll_fista_woo,theta_fista_woo] = fista(S,lambda_woo,K,t);    



%% Plot the results
figure();
lambda = 1.0826;
lambdaidx=13;
c = min(ll_ista(lambdaidx,K),ll_fista(lambdaidx,K))-1e-6;
plot(1:K,log(ll_ista(lambdaidx,:)-repmat(c,[1,K])),...
    1:K,log(ll_fista(lambdaidx,:)-repmat(c,[1,K])));
xlabel('Num Iterations');
ylabel('log(L(\Theta_\lambda^k)-c)');
xlim([1,K+100]);
legend({'ISTA','FISTA'},'Location','SouthWest');
saveas(gcf,'partd.png','png');

%% Plot Woo results
figure();
c = min(ll_ista_woo(K),ll_fista_woo(K))-1e-6;
plot(1:K,log(ll_ista_woo'-repmat(c,[1,K])),...
    1:K,log(ll_fista_woo'-repmat(c,[1,K])));
title('Plot of log(L(\Theta_\lambda^k)-c) for \lambda=1.0826 ')
xlabel('Num Iterations');
ylabel('log(L(\Theta_\lambda^k)-c)');
xlim([1,K+100]);
legend({'ISTA','FISTA'},'Location','SouthWest');
saveas(gcf,'partd_woo.png','png');
save('run_5000.mat','ll_fista','ll_ista','theta_fista','theta_ista',...
    'theta_ista_woo','theta_fista_woo','ll_ista_woo','ll_fista_woo');

%% Then plot the trace of the of the coeff

% calc l1 norm list of ISTA
l1_norm_ista = calc_l1_norm(theta_ista);
l1_norm_fista = calc_l1_norm(theta_fista);

% Calculate the coefficient profile

plot_fista_coeff = zeros(nlambda,p*p);
plot_ista_coeff = zeros(nlambda,p*p);
for i = 1:nlambda
     X = squeeze(theta_ista(i,:,:));
     X = X -diag(diag(X));
     X = triu(X);
     X = reshape(X,[1,p*p]);
     plot_ista_coeff(i,:) = X;
     % now for fista
     X = squeeze(theta_fista(i,:,:));
     X = X -diag(diag(X));
     X = triu(X);
     X = reshape(X,[1,p*p]);
     plot_fista_coeff(i,:) = X;
end


figure();
plot(l1_norm_ista,plot_ista_coeff);
title('Plot ISTA coefficeients');
xlabel('||P*Theta_{lambda}||_1');
ylabel('Off diagonal coefficients');
saveas(gcf,'parte_ista.png','png');

figure();
plot(l1_norm_fista,plot_fista_coeff);
title('Plot FISTA coefficeients');
xlabel('||P*Theta_{lambda}||_1');
ylabel('Off diagonal coefficients');
saveas(gcf,'parte_fista.png','png');

%% Now run steepest descent on the same data




