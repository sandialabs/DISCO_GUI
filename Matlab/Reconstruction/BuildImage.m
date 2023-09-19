function [ImageOut, MaxRadius] = BuildImage(PupilBankIn,ImSize)
%BuildImage will combine the images in PupilBankIn to form a full-size
%DISCO Image based on the parameters of the Pupil Object. It will consider
%each translation and rotation
%   Detailed explanation goes here

addpath(genpath('../Antebellum'));

% [imname, impath] = uigetfile('*.*','Choose Location of Raw Image', '..\..\sample_files\LabCaptures');
% if(impath)
%     rawIm = imread([impath imname]);
%     if(length(size(rawIm)) == 3)
%         rawIm = rgb2gray(imread([impath imname]));
%     end
%     
%     imsize = size(rawIm);
    
    pb = PupilBankIn;
    ImageOut = uint16(ones(ImSize)); % TODO: make userdefined size
    
    max_r = max([pb.Radius]);
    for i = 1 : length(pb)
        
        im = pb(i).Im;
%         pupil_rot = imrotate(trimmed_im,pupil.Rotation,'nearest','crop'); 
        im = imrotate(im, pb(i).Rotation,'nearest','crop');% conserve square dimensions
        decenter = pb(i).Center + pb(i).Translation;
        sub_mask = pb(i).Mask;
        subpts = calcEndPts_GUI(decenter,max_r); % calculate substitution coordinates
        sub_im = replacePupil(ImageOut,im,sub_mask,subpts);
        ImageOut = sub_im;
    end
    
    
    figure;
    imshow(ImageOut)
    title('Pupil Bank Reconstruction')
    MaxRadius = max_r ;
    
% else
%     uialert(app.UIFigure,'No File Selected. Please select File','File Selection Error')
%     return
% end
end



