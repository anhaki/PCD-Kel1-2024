function hand_sign_gui()
    % Main figure
    hFig = figure('Name', 'Hand Sign Classification', 'NumberTitle', 'off', 'Position', [100 100 1400 400]);
    
    % Display Original Image
    hImageAxes = axes('Parent', hFig, 'Units', 'pixels', 'Position', [50 150 200 200]);
    
    % Display Grayscale and Resized Image
    hGrayResizedAxes = axes('Parent', hFig, 'Units', 'pixels', 'Position', [300 150 200 200]);
    
    % Display HOG features
    hHogAxes = axes('Parent', hFig, 'Units', 'pixels', 'Position', [550 150 200 200], 'Color', 'k'); 
    
    % Display HOG features histogram
    hHogHistAxes = axes('Parent', hFig, 'Units', 'pixels', 'Position', [800 250 200 100]);
    
    % Display predicted class histogram
    hPredHistAxes = axes('Parent', hFig, 'Units', 'pixels', 'Position', [800 100 200 100]);
    
    % Result
    hResult = uicontrol('Style', 'text', 'String', '', 'Position', [1050 200 200 40], 'FontSize', 14);
    
    % Load trained KNN model
    load('trainedKNN.mat', 'trainedKNN');
    
    % BTN UPLOAD IMAGE
    hUploadBtn = uicontrol('Style', 'pushbutton', 'String', 'Upload Image', 'Position', [1050 300 100 40], 'Callback', @uploadImage);
    
    function uploadImage(~, ~)
        
        [file, path] = uigetfile({'*', 'Image Files'});
        if isequal(file, 0)
            return;
        end
        
        img = imread(fullfile(path, file));
        imshow(img, 'Parent', hImageAxes);
        title(hImageAxes, 'Input Gambar');
        
        % Process the image
        imgGray = rgb2gray(img);
        resizedImg = imresize(imgGray, [64 64]);
        
        % Display the resized and grayscale image
        imshow(resizedImg, 'Parent', hGrayResizedAxes);
        title(hGrayResizedAxes, 'Grayscale and Resized Image');
        
        % Extract HOG 
        [features, visualization] = extractHOGFeatures(resizedImg);
        
        % Display HOG visualization
        axes(hHogAxes); 
        plot(visualization, 'Color', 'w'); 
        set(hHogAxes, 'XColor', 'none', 'YColor', 'none'); 
        title(hHogAxes, 'HOG');
        
        % Display histogram of HOG features
        axes(hHogHistAxes); 
        histogram(features, 'FaceColor', 'cyan');
        title(hHogHistAxes, 'HOG Features Histogram');
        xlabel('Feature Bin');
        ylabel('Frequency');
        
        % Classify image using trained KNN model
        label = predict(trainedKNN, features);
        
        % Find the features of training images
        classFeatures = [];
        for i = 1:numel(trainedKNN.Y)
            if trainedKNN.Y(i) == label
                classFeatures = [classFeatures; trainedKNN.X(i, :)];
            end
        end
        
        % Display histogram of the predicted class features
        axes(hPredHistAxes); 
        histogram(classFeatures(:), 'FaceColor', 'cyan');
        title(hPredHistAxes, 'Predicted Class HOG Features Histogram');
        xlabel('Feature Bin');
        ylabel('Frequency');
        
        % Display result
        set(hResult, 'String', ['Predicted: ', char(label)]);
    end
end
