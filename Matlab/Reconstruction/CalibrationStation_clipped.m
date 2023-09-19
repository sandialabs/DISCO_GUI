close all;clear all; clc
addpath(genpath('../Antebellum'));

%{
Version Release Notes:

17 Aug 20 - This script is compatible with clipped calibration images and
            mirrors the GUI steps by padding the original raw image with
            inf values. The inf values are saved in sub-pupil images to
            conserve dimensionality and later converted to zeros.

14 Aug 20 - This sandbox tests the feasability of using an overfilled
            calibration image where certain pupils are clipped.
%}
padFlag = 1;
pad = 512;      % Pixels value to pad
%% Load Raw Image

% rawIm = imread('C:\Users\asmith2\Documents\GitKraken\DISCO_Master\disco_imageprocessor\sample_files\LabCaptures\B200812_calibration.tif');
[imname, impath] = uigetfile('*.tif','Choose The Raw Data Image','../../sample_files/LabCaptures/');
rawIm = imread([impath imname]);
imSize = size(rawIm);

%% Pad Raw Image
if padFlag
    
    horizPad = inf(size(rawIm,1),pad); % Column padding
    imPad = [horizPad,rawIm,horizPad];
    vertPad = inf(pad, size(imPad,2));% row Padding
    imPad = [vertPad;imPad;vertPad];
    %     figure; imshow(imPad)
    
    rawIm = imPad;
    imSize = size(rawIm);
end

h_main = figure;
ax_main = axes(h_main); % specify axes
imshow(rawIm,'Parent',ax_main);
title(['Raw Data Image' imname]);

%% Load PupilBank array
% load('../sample_files/Progress/IP_PupilBank_20200409.mat')
[pbname, pbpath] =  uigetfile('*.mat','Choose Pupil Bank Mat File','../../Temp/Archive/');
load([pbpath pbname]);

[CalibGuiIm, maxR] = BuildImage(pb,imSize);


%% Calibration Start:

% Create Canvas
% calibIm = 0.*rawIm;
calibIm = nan(size(rawIm));
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
    %     trimmed_im(trimmed_im == 0) = nan;
    
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

% calibIm = double(calibIm);
calibIm(calibIm >= 2^16 -1) = NaN;
% calibIm = calibIm./2^16;

figure;
imagesc(calibIm);
title(['Calibrated Image Based on GUI: ' imname ]);
axis('equal')
% imwrite(calibIm, ['Calib', imname], 'Tiff')
%% Post Rotation -- Use if running this script using old calibration file

rotVal = -9;

% postrot = imrotate(calibIm, rotVal , 'nearest', 'crop');
% figure;
% imagesc(postrot)
% % % caxis([0 0.4])
% title('Calibrated Image with Additional Rotation');
% axis('equal')
%
% % imageDiff = abs(CalibGuiIm - calibIm);
% % figure ;imshow(imageDiff);
% % figure ;imshow(~imageDiff);


%% Function Call to Background Correction

% load the desired Background Flat Field response
[bgname, bgpath] =  uigetfile('*.mat','Choose Background Field Correction File','../../Temp/Archive/');

if ischar(bgname)
    
    % load('201218_FlatFieldBackground.mat');
    load([bgpath bgname]);
    bgdata = BG_B21012607_Diffuser1;
%     bgdata  = imrotate(bgdata , 16, 'nearest', 'crop');
    BgCorrected = BGCorrection(calibIm, bgdata );
    
    %     BgCorrected = BGCorrection(postrot, standalone201218_BGdiffuser);
    
    figure;
    imagesc(BgCorrected)
    title('Calibrated Image with Background Signal Removed');
    axis('equal')
    
    
end
