function result = stackedAERecognition(file, mode)
    smat = load('save/stackedAEOptTheta-all.mat');
    nmat = load('save/netconfig-all.mat');
    stackedAEOptTheta = smat.stackedAEOptTheta;
    netconfig = nmat.netconfig;
    
    hiddenSizeL2 = 200;
    % [myData, myLabels, numClasses, inputSize] = loadMyData('all');
    % numClasses = 62;
    % myLabels = myLabels + 36;

    numClasses = 62;
    inputSize = 32*32;
    
    image = [];
    if mode == 1
        path = file;
        colorImg = imread(path);
        grayImg = rgb2gray(colorImg);
        image = imresize(grayImg, [32 32]);
    elseif mode == 2
        image = imresize(file, [32 32]);
    end
    
    image = reshape(image, inputSize, 1);   
    %image = im2bw(image,0.8);   
    %image = 255 - image;
    image = double(image) / 255;
    myData = image;
    
%     figure;
%     imshow(reshape(myData, 32, 32, 1));
  
    [pred] = stackedAEPredict(stackedAEOptTheta, inputSize, hiddenSizeL2, ...
                          numClasses, netconfig, myData);
    result = pred;
    if result>=1 && result<=10
        result = '0'+result-1;
    elseif result>10 && result<=36
        result = 'A'+result-11;
    else
        result = 'a'+result-37;
    end
end


