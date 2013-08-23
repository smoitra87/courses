%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve the integer problem

%% Define the problem
P = load('P.dat');
E = load('E.dat');

n = length(P);

f=P'; %take the negative for maximization problems
A= -E' ;
b=-270;


%% Run the integer program
[X,fval] = bintprog(f,A,b);

fprintf('The percentatge of pop is %f\n',fval/sum(P)/2);

%% Now solve the LP

A = [-E' ; 
      -eye(n) ;
       eye(n)];
b = [-270;zeros(n,1);ones(n,1)];
   
[X,fval] = linprog(f,A,b);
fprintf('The percentatge of pop is %f\n',fval/sum(P));