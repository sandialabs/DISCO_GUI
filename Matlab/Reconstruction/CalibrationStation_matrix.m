%Load raw Image
raw2 = rgb2gray(imread('..\sample_files\DISCO_prototype_image_raw.png'));
%% Trim Raw Rectangular Image to Square Image

a = size(raw2);% insert commen
b = diff(a)/2; 
raw2 = raw2(:, b+1:(max(a)- b)); % assumes Horiz > Vert lengths

h_main = figure;
ax_main = axes(h_main); % specify axes
imshow(raw2,'Parent',ax_main);

%% Load PupilBank array
load('../sample_files/Progress/IP_PupilBank_20200409.mat')

processedIm = BuildImage(pb);
% processedIm = double(processedIm );

%% Math!
k = inv(double(raw2)) * processedIm;

%% show k
figure;imshow(k);

%% Try math

A = double(raw2)* k ;

figure; imshow(A);

%% For loop: Isolate circles

% Rotate subpupils according to pupil.Rot


