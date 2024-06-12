clc; clear; close all; warning off all;

% Base directory containing subfolders with images
base_folder = 'dataset';
subfolders = dir(base_folder);

% Initialize an empty array to store the features
ciri_database = [];
labels = {};

% Loop through each subfolder
for k = 1:length(subfolders)
    subfolder_name = subfolders(k).name;
    % Skip '.' and '..' directories
    if strcmp(subfolder_name, '.') || strcmp(subfolder_name, '..')
        continue;
    end
    
    % Get the full path of the subfolder
    subfolder_path = fullfile(base_folder, subfolder_name);
    if isfolder(subfolder_path)
        % Get all JPG images in the current subfolder
        filenames = dir(fullfile(subfolder_path, '*.jpg'));
        total_images = numel(filenames);

        % Loop through each image in the subfolder
        for n = 1:total_images
            full_name = fullfile(subfolder_path, filenames(n).name);
            Img = imread(full_name);

            Img_gray = rgb2gray(Img);

            pixel_dist = 1;
            GLCM = graycomatrix(Img_gray,'Offset',[0 pixel_dist; -pixel_dist pixel_dist; -pixel_dist 0; -pixel_dist -pixel_dist]);
            stats = graycoprops(GLCM,{'contrast','correlation','energy','homogeneity'});
            Contrast = stats.Contrast;
            Correlation = stats.Correlation;
            Energy = stats.Energy;
            Homogeneity = stats.Homogeneity;

            % Append the features to the database
            ciri_database = [ciri_database; [Contrast, Correlation, Energy, Homogeneity]];
            labels{end+1} = subfolder_name;  % Save the label corresponding to the current image
        end
    end
end

% Save the feature database
save('ciri_database.mat', 'ciri_database', 'labels');