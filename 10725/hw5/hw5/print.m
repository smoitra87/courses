function val = kernel(x,y,sigma)
    val = exp(-sum((x-y).^2)/(2*sigma^2));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% svmdecision

function [ylabel,yval] = svmdecision(x,alpha,X,Y,C,sigma,b)

[d,n] = size(X);

yval = 0;
for i  = 1:n
    yval = yval + alpha(i)*Y(i)*kernel(X(:,i),x,sigma);
end
yval = yval  +b;

ylabel = sign(yval);

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% master_svm

%unclear all;
load('svmdata.mat')



%% Call the svm dual function

sigma=1;
C=1;
alpha = svmdual(trainX,trainY,C,sigma);
[d,n] = size(trainX);

% caculate b
validk = find(alpha > 0 & alpha < C);
b = 0;
for kid =1: length(validk)
    t = 0;
    for i = 1:n
        t = t + alpha(i)*trainY(i)*...
                kernel(trainX(:,i),trainX(:,validk(kid)),sigma);
    end
    b = b+ trainY(validk(kid)) - t;
end
b= b / length(validk);
b = 0.2946;

%% Train and Test Errors

% calc training error
trainErr = 0;
for i = 1:n
    if trainY(i) ~= svmdecision(trainX(:,i),alpha,trainX,trainY,C,sigma,b)
        trainErr  = trainErr + 1;
    end
end
trainErr = trainErr/n;

fprintf('******* Training Error %f ********\n',trainErr);

% calc test error
testErr = 0;
for i = 1:n
    if testY(i) ~= svmdecision(testX(:,i),alpha,trainX,trainY,C,sigma,b)
        testErr  = testErr + 1;
    end
end
testErr  = testErr/n;
fprintf('******* Testing Error %f ********\n',testErr);


%% Plotting stuff

X = trainX';
y = trainY;
pos = find(y == 1); neg = find(y == -1);

vec = validk;

% Plot Examples

% Make classification predictions over a grid of values
x1plot = linspace(min(X(:,1)), max(X(:,1)), 50)';
x2plot = linspace(min(X(:,2)), max(X(:,2)), 50)';
[X1, X2] = meshgrid(x1plot, x2plot);
vals = zeros(size(X1));
for i = 1:size(X1, 2)
   for j = 1:size(X2,2)
      this_X = [X1(i, j), X2(i, j)];
      [bla,vals(i, j)] = svmdecision(this_X',alpha,trainX,trainY,C,sigma,b);
   end
end

% Plot the SVM boundary
figure;
hold on
contourf(X1,X2,vals);
plot(X(pos, 1), X(pos, 2), 'k+','LineWidth', 1, 'MarkerSize', 7)
plot(X(neg, 1), X(neg, 2), 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 7)
plot(X(vec, 1), X(vec, 2), 'ko', 'MarkerFaceColor', 'magenta', 'MarkerSize', 7)
hold off

title(sprintf('Decision boundary for C=%f',C))
saveas(gcf,sprintf('C_%f.png',C),'png');



