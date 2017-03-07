function [data, label, classnum, size] = loadMyData(mode)
    if strcmp(mode, 'all')
        data = load('data/chars74k/myData.mat');
        data = data.myData;
        label = load('data/chars74k/myLabel.mat');
        label = label.myLabels;
        classnum = 62;
        size = 32*32;
    elseif strcmp(mode, 'digit')
        data   = loadMNISTImages('data/mnist/train-images.idx3-ubyte');
        label = loadMNISTLabels('data/mnist/train-labels.idx1-ubyte');
        classnum = 10;
        label = label + 1;
        size = 28*28;
    elseif strcmp(mode, 'digit2')
        data   = loadMNISTImages('data/mnist/t10k-images.idx3-ubyte');
        label = loadMNISTLabels('data/mnist/t10k-labels.idx1-ubyte');
        classnum = 10;
        label = label + 1;
        size = 28*28;
    elseif strcmp(mode, 'digit3')
        data = load('data/chars74k/digitData28.mat');
        data = data.digitData28;
        label = load('data/chars74k/digitLabel.mat');
        label = label.digitLabel;
        classnum = 10;
        size = 28*28;
    elseif strcmp(mode, 'uppercase')
        data = load('data/chars74k/upperCaseData.mat');
        data = data.upperCaseData;
        label = load('data/chars74k/upperCaseLabel.mat');
        label = label.upperCaseLabel;
        label = label - 10;
        classnum = 26;
        size = 32*32;
    elseif strcmp(mode, 'lowercase')
        data = load('data/chars74k/lowerCaseData.mat');
        data = data.lowerCaseData;
        label = load('data/chars74k/lowerCaseLabel.mat');
        label = label.lowerCaseLabel;
        label = label - 36;
        classnum = 26;
        size = 32*32;
    end
end
