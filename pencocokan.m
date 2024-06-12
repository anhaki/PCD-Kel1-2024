clc;
clear;

load ciri_database
img = rgb2gray(imread('0004_test.jpg'));

pixel_dist = 1;
GLCM = graycomatrix(img,'Offset',[0 pixel_dist; -pixel_dist pixel_dist; -pixel_dist 0; -pixel_dist -pixel_dist]);
stats = graycoprops(GLCM,{'contrast','correlation','energy','homogeneity'});
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;

ciri_test = [Contrast, Correlation, Energy, Homogeneity];

num_samples = size(ciri_database, 1);
distance = zeros(num_samples, 1);

for i = 1:num_samples
    distance(i) = sqrt(sum((ciri_test - ciri_database(i,:)).^2));
end

[~, hasil] = min(distance);

kelas = labels{hasil};  % Get the corresponding label for the closest match

fprintf('Kelas: %s\n', kelas);
