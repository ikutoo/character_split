smat = load('save/softmaxModel-digit.mat');
softmaxModel = smat.softmaxModel;

%[testData, testLabels] = loadMyData('digit');

testLabels = 2;
path = 'data/1.png';
colorImg = imread(path);
grayImg = rgb2gray(colorImg);
image = imresize(grayImg, [28 28]);
image = reshape(image, 28*28, 1);
image = 255 - image;
image = double(image) / 255;
testData = image;

[pred] = softmaxPredict(softmaxModel, testData);

acc = mean(testLabels(:) == pred(:));
fprintf('Accuracy: %0.3f%%\n', acc * 100);