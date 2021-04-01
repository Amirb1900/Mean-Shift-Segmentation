image_original = imread('lake.JPG'); % Must be 3 channel image
gray_rgb_luv = 2; % 0 for gray, 1 for rgb or 2 for luv
sigmaS = 10; % Normalization constant for spatial dimension
sigmaR = 7; % Normalization constant for colour dimension
M = 20; % Threshold for ignoring a cluster
segmentedImage = MeanShiftSegmentation(image_original,gray_rgb_luv,sigmaS,sigmaR,M);
figure()
imshow(image_original)
figure()
imshow(segmentedImage)