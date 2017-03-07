function [ cost, grad ] = stackedAECost(theta, inputSize, hiddenSize, ...
                                              numClasses, netconfig, ...
                                              lambda, data, labels)
                                         
% stackedAECost: Takes a trained softmaxTheta and a training data set with labels,
% and returns cost and gradient using a stacked autoencoder model. Used for
% finetuning.
                                         
% theta: trained weights from the autoencoder
% visibleSize: the number of input units
% hiddenSize:  the number of hidden units *at the 2nd layer*
% numClasses:  the number of categories
% netconfig:   the network configuration of the stack
% lambda:      the weight regularization penalty
% data: Our matrix containing the training data as columns.  So, data(:,i) is the i-th training example. 
% labels: A vector containing labels, where labels(i) is the label for the
% i-th training example


%% Unroll softmaxTheta parameter

% We first extract the part which compute the softmax gradient
softmaxTheta = reshape(theta(1:hiddenSize*numClasses), numClasses, hiddenSize);

% Extract out the "stack"
stack = params2stack(theta(hiddenSize*numClasses+1:end), netconfig);

% You will need to compute the following gradients
softmaxThetaGrad = zeros(size(softmaxTheta));
stackgrad = cell(size(stack));
for d = 1:numel(stack)
    stackgrad{d}.w = zeros(size(stack{d}.w));
    stackgrad{d}.b = zeros(size(stack{d}.b));
end

cost = 0; % You need to compute this

% You might find these variables useful
M = size(data, 2);
groundTruth = full(sparse(labels, 1:M, 1));


%% --------------------------- YOUR CODE HERE -----------------------------
%  Instructions: Compute the cost function and gradient vector for 
%                the stacked autoencoder.
%
%                You are given a stack variable which is a cell-array of
%                the weights and biases for every layer. In particular, you
%                can refer to the weights of Layer d, using stack{d}.w and
%                the biases using stack{d}.b . To get the total number of
%                layers, you can use numel(stack).
%
%                The last layer of the network is connected to the softmax
%                classification layer, softmaxTheta.
%
%                You should compute the gradients for the softmaxTheta,
%                storing that in softmaxThetaGrad. Similarly, you should
%                compute the gradients for each layer in the stack, storing
%                the gradients in stackgrad{d}.w and stackgrad{d}.b
%                Note that the size of the matrices in stackgrad should
%                match exactly that of the size of the matrices in stack.
%

aeNumber=numel(stack);  %前向传播  
m=size(data,2);  
z = cell(aeNumber+1, 1);          
a = cell(aeNumber+1, 1);          
a{1}=data;  
for i=2:aeNumber+1  
   z{i}=stack{i-1}.w*a{i-1}+repmat(stack{i-1}.b, 1, m);  
   a{i}=sigmoid(z{i});   
end  
%---------------------------------------------------------softmax参数的梯度  
M=softmaxTheta*a{aeNumber+1};  
M = bsxfun(@minus,M,max(M,[],1));  
M=exp(M);  
H = bsxfun(@rdivide,M,sum(M));   
M=log(H);  
M=M.*groundTruth;  
cost=-1/m*sum(sum(M,1),2)+lambda/2*sum(sum(softmaxTheta.^2));    
softmaxThetaGrad=-1/m*(groundTruth-H)*a{aeNumber+1}'+lambda*softmaxTheta;   
%----------------------------------------------------------------自编码层参数梯度  
delta=cell(aeNumber+1);        
delta{aeNumber+1}=-(softmaxTheta'*(groundTruth-H)).*a{aeNumber+1}.*(1-a{aeNumber+1});   %公式（1）    
  
for l=aeNumber:-1:2  
    delta{l}=(stack{l}.w'*delta{l+1}).*a{l}.*(1-a{l});   %公式（2）     
end  
  
for l=aeNumber:-1:1                
   stackgrad{l}.w=delta{l+1}*a{l}'/m;     %公式（3）注意这里矩阵相乘隐含了m个样本求和  
    stackgrad{l}.b=sum(delta{l+1},2)/m;  
end  





% -------------------------------------------------------------------------

%% Roll gradient vector
grad = [softmaxThetaGrad(:) ; stack2params(stackgrad)];

end


% You might find this useful
function sigm = sigmoid(x)
    sigm = 1 ./ (1 + exp(-x));
end
