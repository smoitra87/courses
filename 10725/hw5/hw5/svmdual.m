%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates svm dual

function [alpha] = svmdual(X,Y,C,sigma)

[d,n] = size(X);
H = zeros(n,n);
for i  =1:n
    for j = 1:n
        H(i,j) = Y(i)*kernel(X(:,i),X(:,j),sigma)*Y(j);
    end
end
%imagesc(H)
f = -ones(1,n);
A = []; b = [];
Aeq = Y;
beq = 0;
% A = [-eye(n) ; eye(n)];
% b = [zeros(1,n); repmat(C,1,n)];
%[alpha,fval,exitflag] = quadprog(H,f,A,b,Aeq,beq);
options = optimset('quadprog');
options = optimset(options,'MaxIter',10000);

[alpha,fval,exitflag] = quadprog(H,f,[],[],Aeq,beq,zeros(1,n),repmat(C,1,n),zeros(1,n),options);
end


