
hiddenSize = 200;
sparsityParam = 0.1;
                  
lambda = 3e-3;       % weight decay parameter       
beta = 3;            % weight of sparsity penalty term   
maxIter = 400;


%myData   = loadMYImages('hnd/all.data');
%myLabels = loadMYLabels('hnd/all.data');
[myData, myLabels, numLabels, inputSize] = loadMyData('uppercase');

% Simulate a Labeled and Unlabeled set
numLabel = numel(myLabels);
labeledSet   = 1:2:numLabel;
unlabeledSet = 2:2:numLabel;

numTrain = numel(labeledSet);
trainSet = labeledSet(1:2:numTrain);
testSet  = labeledSet(2:2:numTrain);

unlabeledData = myData(:, unlabeledSet);

trainData   = myData(:, trainSet);
trainLabels = myLabels(trainSet)'; 

testData   = myData(:, testSet);
testLabels = myLabels(testSet)';  

% Output Some Statistics
fprintf('# examples in unlabeled set: %d\n', size(unlabeledData, 2));
fprintf('# examples in supervised training set: %d\n\n', size(trainData, 2));
fprintf('# examples in supervised testing set: %d\n\n', size(testData, 2));


%  Randomly initialize the parameters
theta = initializeParameters(hiddenSize, inputSize);
 
%  Use minFunc to minimize the function  
addpath minFunc/  
options.Method = 'lbfgs'; % Here, we use L-BFGS to optimize our cost  
                          % function. Generally, for minFunc to work, you  
                          % need a function pointer with two outputs: the  
                          % function value and the gradient. In our problem,  
                          % sparseAutoencoderCost.m satisfies this.  
options.maxIter = 400;    % Maximum number of iterations of L-BFGS to run   
options.display = 'on';  
  
  
[opttheta, cost] = minFunc( @(p) sparseAutoencoderCost(p, ...  
                                   inputSize, hiddenSize, ...  
                                   lambda, sparsityParam, ...  
                                   beta, unlabeledData), ...  
                              theta, options);  


%% -----------------------------------------------------
                          
% Visualize weights
W1 = reshape(opttheta(1:hiddenSize * inputSize), hiddenSize, inputSize);
display_network(W1');


trainFeatures = feedForwardAutoencoder(opttheta, hiddenSize, inputSize, ...
                                       trainData);

testFeatures = feedForwardAutoencoder(opttheta, hiddenSize, inputSize, ...
                                       testData);

lambda = 1e-4;  
options.maxIter = 400;  
softmaxModel = softmaxTrain(hiddenSize, numLabels, lambda, ...  
                            trainFeatures, trainLabels, options);  


[pred] = softmaxPredict(softmaxModel, testFeatures);  


%% -----------------------------------------------------

% Classification Score
fprintf('Test Accuracy: %f%%\n', 100*mean(pred(:) == testLabels(:)));

