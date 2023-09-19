close all;clear all; clc

addpath(genpath('../Antebellum'));


%% Load raw Image
% rawIm = rgb2gray(imread('..\sample_files\DISCO_prototype_image_raw.png'));

[imname, impath] = uigetfile('*.tif','Choose The Raw Data Image','../../sample_files/LabCaptures/');
rawIm = imread([impath imname]);
imSize = size(rawIm);
%% Trim Raw Rectangular Image to Square Image

% a = size(rawIm);% insert comment
% b = diff(a)/2;
% rawIm = rawIm(:, b+1:(max(a)- b)); % assumes Horiz > Vert lengths

h_main = figure;
ax_main = axes(h_main); % specify axes
imshow(rawIm,'Parent',ax_main);
title('Raw Data Image')
%% Load PupilBank array
% load('../sample_files/Progress/IP_PupilBank_20200409.mat')
[pbname, pbpath] =  uigetfile('*.mat','Choose Pupil Bank Mat File','../../Temp/Archive/');
load([pbpath pbname]);

[CalibGuiIm, maxR] = BuildImage(pb,imSize);

%% Calibration Start: 


% Create Canvas
calibIm = 0.*rawIm;
inProgressPupil = 0.*pb(1).Im;
for i = 1:length(pb)
    % Select pupil
    pupil = pb(i);
    decenter = pupil.Center+pupil.Translation;

    %operations on RawIm
    
    % Isolate the subpupil on rawIm ( operate on a box, return a circle )
    endpts = calcEndPts_GUI(pupil.Center,pupil.Radius);
%     endpts = calcEndPts_GUI(decenter,pupil.Radius);
    pupilMask = mask(rawIm,pupil.Center,pupil.Radius);
    
    isolated_image = uint16(pupilMask) .* rawIm;
    trimmed_im = isolated_image;
    trimmed_im(~any(isolated_image,2),:) = []; % deletes any 0 column
    trimmed_im(:,~any(isolated_image,1)) = []; % deletes any 0 row
    
    padding = size(pupil.Im) - size(trimmed_im);
    if (padding(1) && padding(1)<0)
        pupil.Im = [zeros(abs(padding(1)), size(pupil.Im,2));pupil.Im];
        pupil.Mask = [zeros(abs(padding(1)), size(pupil.Mask,2));pupil.Mask];
    end
    if (padding(2) && padding(2)<0)
        pupil.Im = [pupil.Im, zeros(size(pupil.Im,1),abs(padding(2)))];
        pupil.Mask = [pupil.Mask, zeros(size(pupil.Mask,1),abs(padding(2)))];
        maxR=maxR+1;
    end
    if (padding(1)&& padding(1)>0)
        trimmed_im = [zeros(padding(1),size(trimmed_im,2));trimmed_im]; % pad rows
    end
    if (padding(2)&& padding(2)>0)
        trimmed_im = [trimmed_im , zeros(size(trimmed_im,1),padding(2))]; %pad columns
    end
    
    pupil_rot = imrotate(trimmed_im,pupil.Rotation,'nearest','crop'); % conserve square dimensions
    
    % remask!
    pupil_rot = uint16(pupil.Mask).* pupil_rot;
    % Substitute Image
    subpts = calcEndPts_GUI(decenter,maxR);
    calibIm = replacePupil(calibIm,pupil_rot,pupil.Mask,subpts);
    
end


figure;
imshow(calibIm);
 
% imageDiff = abs(CalibGuiIm - calibIm);
% figure ;imshow(imageDiff);
% figure ;imshow(~imageDiff);

%% Save Sequence
saveTitle = [imname(1:end-3), 'tiff' ] ;
imwrite(calibIm, ['../Antebellum/Temp/P_', saveTitle]);
