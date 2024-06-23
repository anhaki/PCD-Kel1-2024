function trainedKNN = train_knn()

%%Dataset & Preprocessing
    datasetPath = 'dataset/';
    imageSize = [64, 64];
    classes = 'A':'E';
    
    % Initialize image datastore
    imds = imageDatastore(datasetPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    
    % Resize images and convert to grayscale
    imds.ReadFcn = @(filename) imresize(rgb2gray(imread(filename)), imageSize);
    
%% Split Data
    [imdsTrain, imdsValidation] = splitEachLabel(imds, 0.8, 'randomized');
    
%% Ekstraksi Fitur HOG
    trainingFeatures = [];
    trainingLabels = []; 
    
    for i = 1:numel(imdsTrain.Files)
        img = readimage(imdsTrain, i);
        features = extractHOGFeatures(img);
        trainingFeatures = [trainingFeatures; features];
        trainingLabels = [trainingLabels; imdsTrain.Labels(i)];
    end
    
%% Train Klasifikasi K-NN 
    trainedKNN = fitcknn(trainingFeatures, trainingLabels, 'NumNeighbors', 9);

    % Extract features from validation (testing) data
    validationFeatures = [];
    validationLabels = [];
    
    for i = 1:numel(imdsValidation.Files)
        img = readimage(imdsValidation, i);
        features = extractHOGFeatures(img);
        validationFeatures = [validationFeatures; features];
        validationLabels = [validationLabels; imdsValidation.Labels(i)];
    end

    % Save the trained model and validation data
    save('trainedKNN.mat', 'trainedKNN', 'validationFeatures', 'validationLabels');
    
    % Calculate predictions on the validation set
    predictedLabels = predict(trainedKNN, validationFeatures);
    
%% Confusion Matrix
    confMat = confusionmat(validationLabels, predictedLabels);

    % Hitung Akurasi
    accuracy = sum(diag(confMat)) / sum(confMat(:));
    disp(['Validation Accuracy: ', num2str(accuracy * 100), '%']);

    % Hitung precision and recall untuk tiap huruf
    numClasses = numel(unique(validationLabels));
    precision = zeros(numClasses, 1);
    recall = zeros(numClasses, 1);
    
    for i = 1:numClasses
        TP = confMat(i, i);
        FP = sum(confMat(:, i)) - TP;
        FN = sum(confMat(i, :)) - TP;
        
        precision(i) = TP / (TP + FP);
        recall(i) = TP / (TP + FN);
    end

    % Display confusion matrix and metrics
    disp('Confusion Matrix:');
    disp(confMat);
    
    disp('Precision for each class:');
    disp(precision);
    
    disp('Recall for each class:');
    disp(recall);
end
