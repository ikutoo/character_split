%% CS294A/CS294W Softmax Exercise 

%  Instructions
%  ------------
% 
%  This file contains code that helps you get started on the
%  softmax exercise. You will need to write the softmax cost function 
%  in softmaxCost.m and the softmax prediction function in softmaxPred.m. 
%  For this exercise, you will not need to change any code in this file,
%  or any other files other than those mentioned above.
%  (However, you may be required to do so in later exercises)

%%======================================================================
%% STEP 0: Initialise constants and parameters
%
%  Here we define and initialise some constants which allow your code
%  to be used more generally on any arbitrary input. 
%  We also initialise some parameters used for tuning the model.

inputSize = 32 * 32;
numClasses = 10;    

lambda = 1e-4; % Weight decay parameter

%%======================================================================
%% STEP 1: Load data
%
%  In this section, we load the input and output data.
%  For softmax regression on MNIST pixels, 
%  the input data is the images, and 
%  the output data is the labels.
%   
[myData, myLabels, numClasses, inputSize] = loadMyData('lowercase');

numLabel = numel(myLabels);
trainSet   = [1:4:numLabel 2:4:numLabel 3:4:numLabel];
testSet = 4:4:numLabel;

trainData   = myData(:, trainSet);
trainLabels = myLabels(trainSet)'; 

testData   = myData(:, testSet);
testLabels = myLabels(testSet)';  

% Randomly initialise theta
theta = 0.005 * randn(numClasses * inputSize, 1);

%%======================================================================
%% STEP 2: Implement softmaxCost
%
%  Implement softmaxCost in softmaxCost.m. 

[cost, grad] = softmaxCost(theta, numClasses, inputSize, lambda, trainData, trainLabels);
                                    
%%======================================================================
%% STEP 4: Learning parameters
%
%  Once you have verified that your gradients are correct, 
%  you can start training your softmax regression code using softmaxTrain
%  (which uses minFunc).

options.maxIter = 400;
softmaxModel = softmaxTrain(inputSize, numClasses, lambda, ...
                            trainData, trainLabels, options);
                          
% Although we only use 100 iterations here to train a classifier for the 
% MNIST data set, in practice, training for more iterations is usually
% beneficial.

%%======================================================================
%% STEP 5: Testing
%
%  You should now test your model against the test images.
%  To do this, you will first need to write softmaxPredict
%  (in softmaxPredict.m), which should return predictions
%  given a softmax model and the input data.

% You will have to implement softmaxPredict in softmaxPredict.m
[pred] = softmaxPredict(softmaxModel, testData);

acc = mean(testLabels(:) == pred(:));
fprintf('Accuracy: %0.3f%%\n', acc * 100);

% Accuracy is the proportion of correctly classified images
% After 100 iterations, the results for our implementation were:
%
% Accuracy: 92.200%
%
% If your values are too low (accuracy less than 0.91), you should check 
% your code for errors, and make sure you are training on the 
% entire data set of 60000 28x28 training images 
% (unless you modified the loading code, this should be the case)
