
%myData   = loadMYImages('hnd/all.data');
%myLabels = loadMYLabels('hnd/all.data');
numImages = 550;
numRows = 28;
numCols = 28;

data = load('data/chars74k/digitData.mat');
myData = data.digitData;
myData = reshape(myData, 32, 32, numImages);
digitData28 = zeros(numRows, numCols, numImages);
for i = 1:numImages
    digitData28(:,:,i) = abs(imresize(myData(:,:,i), [numRows numCols]));
    for j = 1:numRows
        for k = 1:numCols
            if digitData28(j,k,i)>1
                digitData28(j,k,i) = 1;
            end
        end
    end
end
