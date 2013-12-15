%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
addpath(genpath('DeepLearnToolbox'));

load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

% normalize
[train_x, mu, sigma] = zscore(train_x);
test_x = normalize(test_x, mu, sigma);



%% ex1 neural net with Tanh function and plotting
% split training data into training and test

% fprintf('\n###### Experiment 1 #######\n');
% for nHid = [1,2,4,8]
% 
%     startTime = tic;
%     fprintf('\nUsing %d hidden layers\n',nHid);
%     rand('state',0)
%     nn                      = nnsetup([784 392*ones(1,nHid) 10]);     
%     nn.activation_function  = 'tanh_opt';
%     nn.output               = 'softmax';                   %  use softmax output
%     nn.learningRate         = 0.05;
%     nn.momentum             = 0;
%     opts.numepochs          = 10;                           %  Number of full sweeps through data
%     opts.batchsize          = 10;                        %  Take a mean gradient step over this many samples
%     opts.plot               = 1;%  enable plotting
%     nn = nntrain(nn, train_x, train_y, opts, test_x, test_y);                %  nntrain takes validation set as last two arguments (optionally)
% 
%     totalTime = toc(startTime);
%     fprintf('Total Time elapsed %f\n',totalTime);
%     
%     saveas(gcf,sprintf('errorCurves_batch10_%d.png',nHid),'png');
%     close all;
%     
%end


%% ex2 neural net with Tanh function and 100 minibatch size
% split training data into training and test
fprintf('\n###### Experiment 2 #######\n');
for nHid = [1,2,4,8]

    startTime = tic;
    fprintf('\nUsing %d hidden layers\n',nHid);
    rand('state',0)
    nn                      = nnsetup([784 392*ones(1,nHid) 10]);     
    nn.activation_function  = 'tanh_opt';
    nn.output               = 'softmax';                   %  use softmax output
    nn.learningRate         = 0.05;
    nn.momentum             = 0;
    opts.numepochs          = 10;                           %  Number of full sweeps through data
    opts.batchsize          = 100;                        %  Take a mean gradient step over this many samples
    opts.plot               = 1;%  enable plotting
    nn = nntrain(nn, train_x, train_y, opts, test_x, test_y);                %  nntrain takes validation set as last two arguments (optionally)

    totalTime = toc(startTime);
    fprintf('Total Time elapsed %f\n',totalTime);

    saveas(gcf,sprintf('errorCurves_batch100_%d.png',nHid),'png');
    close all;
    
end

%% ex3 Different hidden dims
% split training data into training and test
fprintf('\n###### Experiment 3 #######\n');

startTime = tic;
fprintf('\nUsing 392 50 hidden layers\n');
rand('state',0)
nn                      = nnsetup([784 92 150 10]);     
nn.activation_function  = 'tanh_opt';
nn.output               = 'softmax';                   %  use softmax output
nn.learningRate         = 0.05;
nn.momentum             = 0;
opts.numepochs          = 10;                           %  Number of full sweeps through data
opts.batchsize          = 100;                        %  Take a mean gradient step over this many samples
opts.plot               = 1;%  enable plotting
nn = nntrain(nn, train_x, train_y, opts, test_x, test_y);                %  nntrain takes validation set as last two arguments (optionally)


totalTime = toc(startTime);
fprintf('Total Time elapsed %f\n',totalTime);

saveas(gcf,sprintf('errorCurves_diff_%d.png',nHid),'png');
close all;
   

