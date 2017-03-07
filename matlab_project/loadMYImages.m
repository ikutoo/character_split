function images = loadMYImages(filename)

fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);


numImages = 3410;
numRows = 32;
numCols = 32;

images = zeros(numRows * numCols, numImages);
i = 1;
while ~feof(fp)                                                 
   line=fgetl(fp); 
   path = ['hnd/',line];
   colorImg = imread(path);
   grayImg = rgb2gray(colorImg);
   image = imresize(grayImg, [numRows numCols]);
   images(:,i) = reshape(image, numRows*numCols, 1);
   i = i + 1;
   disp(i);
end

fclose(fp);

images = reshape(images, numRows, numCols, numImages);

% Reshape to #pixels x #examples
images = reshape(images, size(images, 1) * size(images, 2), size(images, 3));
% Convert to double and rescale to [0,1]
images = double(images) / 255;

end
