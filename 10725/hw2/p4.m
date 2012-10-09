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
K=500;
t = 0.00001;
nlambda=30;
lambda_list = logspace(log10(0.1),log10(3),nlambda);
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
legend('ll ISTA','ll FISTA');
saveas(gcf,'partd.png','png');


