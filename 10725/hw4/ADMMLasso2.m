%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The ADMM Lasso2 function

function [zopt] = ADMMLasso2(A,b,x0,lambda,rho,eps)

[m,n] = size(A);
T = 500;
r = zeros(1,T-1);
s = zeros(1,T-1);

x = zeros(n,T);
z = zeros(n,T);
u = zeros(n,T);
x(:,1) = x0;
z(:,1) = x0;
u(:,1) = ones(size(x0));
%z(:,1) = rand(n,1);
%u(:,1) = rand(n,1);

c1 = (1/rho*eye(n)-1/rho^2*A'*inv(eye(m)+1/rho*(A*A'))*A);
c2 =  A'*b;

for t = 1:T
    
    
    y = c2 - rho*(u(:,t)-z(:,t));
    
    %% Update x
    x(:,t+1) = c1*y;
        
    %% Update z
    z(:,t+1) = arrayfun(@(y) softthresh(lambda/rho,y),u(:,t)+x(:,t+1));
    
    %% Update u
    u(:,t+1) = u(:,t) + (x(:,t+1)-z(:,t+1));
    
    r(t) = norm(x(:,t) - z(:,t));
    s(t) = rho*norm(z(:,t+1)-z(:,t));
    
    if (r(t) < eps) && (s(t) < eps)
        zopt = z(:,t+1);
        return;
    end
    
    
end

zopt = z(:,t);

end



function [ret]  = softthresh(lambda,y)

if y > lambda
    ret = y-lambda;
elseif y< -lambda
    ret = y+lambda;
else
    ret = 0;
end
    
end