%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADMM master script 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('data/A.txt')
load('data/b.txt')

[m,n] = size(A);

lambda = 0.1*max(abs(A'*b));

x0 = zeros(n,1);

%% Run ADMMLasso

% rho = 1;
% ADMMLasso(A,b,x0,lambda,rho);
% 
% rho = 10;
% ADMMLasso(A,b,x0,lambda,rho);
% 
% rho = 0.1;
% ADMMLasso(A,b,x0,lambda,rho);

%% Run regpath

lmin = 0.001;
lmax = 0.99*max(abs(A'*b));
eps =0.001;
rho=1;

RegPath(A,b,lmin,lmax,rho,eps);



