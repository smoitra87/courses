%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RegPath


function [] = RegPath(A,b,lmin,lmax,rho,eps)

[m,n] = size(A);
N=21;

lambdas = logspace(log10(lmin),log10(lmax),N);
zopt = zeros(n,N);
x0 = zeros(n,1);

zopt(:,1) = ADMMLasso2(A,b,x0,lambdas(1),rho,eps);


for i = 2:N
     zopt(:,i) = ADMMLasso2(A,b,zopt(:,i-1),lambdas(i),rho,eps);
end


%% Plot the non-zero values


%% Plot the path
figure;
plot(repmat(log10(lambdas)',1,n),zopt');
xlabel('log10(Lambda)');
ylabel('x* values');
title('Regularization path');
saveas(gcf,'regpath.png','png')

%% Plot the non-zero values


nz = zeros(1,N);
for i = 1:N
    nz(i) = nnz(zopt(:,i));
end

figure;
plot(log10(lambdas),nz);
xlabel('log10(Lambdas)');
ylabel('Num non zeros');
title('Num Non Zeros');
saveas(gcf,'nnz.png','png');

end
