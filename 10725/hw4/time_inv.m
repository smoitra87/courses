%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time the inversion methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('data/A.txt')
load('data/y.txt')
rho=1;
[m,n] = size(A);

fprintf('**********Beginning Timing**********\n');

%% Time the naive inversion method

tic;
X1 = inv(rho*eye(n)+A'*A)*y;
elapsed = toc;
fprintf('Time taken Naive %f\n',elapsed);


%% Time the Woodbury matrix identity

tic;
X2 = (1/rho*eye(n)-1/rho^2*A'*inv(eye(m)+1/rho*A*A')*A)*y;
elapsed = toc;
fprintf('Time taken Woodbury %f\n',elapsed);


%% Time the Cholesky decomposition

tic;
L = chol(eye(m)+1/rho*A*A');
elapsed = toc;
fprintf('Time taken Cholesky %f\n',elapsed);

tic;
y1 = A*y;
z1 = L'\y1;
Z = L\z1;
X3 = 1/rho*y-1/rho^2*A'*Z;
elapsed = toc;
fprintf('Time taken Woodbury-chol %f\n',elapsed);


%% Make sure they are correct

sum(sum((X1-X2).^2))
sum(sum((X2-X3).^2))