img = imread('Atest1.png');

% Convert the image to grayscale
grayImg = rgb2gray(img);

% Resize to 64x64
resizedImg = imresize(grayImg, [64, 64]);

% Extract HOG features
[featureVector, hogVisualization] = extractHOGFeatures(resizedImg);

figure;
subplot(1, 3, 1);
imshow(grayImg);
title('Original Grayscale Image');

%resized image
subplot(1, 3, 2);
imshow(resizedImg);
title('Resized Image 64x64');

% Display the HOG visualization
subplot(1, 3, 3);
imshow(resizedImg);
hold on;
plot(hogVisualization);
hold off;
title('HOG Visualization');
