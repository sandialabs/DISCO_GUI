close all;clear all; clc
%{
Version Release Notes






%}
%% Import Raw Image and Display

raw2 = rgb2gray(imread('..\sample_files\DISCO_prototype_image_raw.png'));
pupil_num = 1; % pupil you would like to manipulate
pupil_dest = 3;% pupil you would like to replace
%% Trim Raw Rectangular Image to Square Image

a = size(raw2);% insert commen
b = diff(a)/2; 
raw2 = raw2(:, b+1:(max(a)- b)); % assumes Horiz > Vert lengths

h_main = figure;
ax_main = axes(h_main); % specify axes
imshow(raw2,'Parent',ax_main);

%% Find Pupils

[centers, radii, h] = findPupil(ax_main,raw2,[172 183],0.995);

% highlight pupil being used
h2 = h;
roi = images.roi.Circle(h2,'center',centers(pupil_num,:),'radius',radii(pupil_num));

%% Label the Pupils

strIdx = 1:7;
h_strIdx = text(ax_main,centers(:,1),centers(:,2),num2cell(strIdx(1,:)),'color','red');
% delete(h_strIdx); % command if you want to delete text label

%% Check Dimensions of Largest Bounding Box

bbox_r = round([centers(:,1) - radii(:),centers(:,1) + radii(:)]);
bbox_c = round([centers(:,2) - radii(:),centers(:,2) + radii(:)]);
boxLengths = [diff(bbox_r,1,2),diff(bbox_c,1,2)];
max_r = max(radii);
max_square = max(boxLengths(:,1))*ones(1,2);

%% Create mask using centers and radii

p_mask = mask(raw2,centers(pupil_num,:),radii(pupil_num));

h_mask = figure;
ax_mask = axes(h_mask);
imshow(p_mask,'Parent', ax_mask)

%% Overlay Mask and Square Image

isolated_image = uint16(p_mask) .* raw2;

h_iso = figure; 
ax_iso = axes(h_iso);
imshow(isolated_image, 'Parent', ax_iso)

%% Separate ROI into its own Matrix
% Trimmed_im is found by manipulating the isolated image (image after mask)
% Make a square ROI- find end points:

endpts = calcEndPts(pupil_num,centers,max_r);
trimmed_im = isolated_image;
trimmed_im(~any(isolated_image,2),:) = []; % deletes any 0 column
trimmed_im(:,~any(isolated_image,1)) = []; % deletes any 0 row

%% Re-Pad trimmed_im to match Max Box Dimensions (important for substitution)

padding = max_square - size(trimmed_im);
if padding(1)
trimmed_im = [zeros(padding(1),size(trimmed_im,2));trimmed_im]; % pad rows
end
if padding(2)
trimmed_im = [trimmed_im , zeros(size(trimmed_im,1),padding(2))]; %pad columns
end

h_pupil = figure;
ax_pupil = axes(h_pupil);
imshow(trimmed_im,'Parent', ax_pupil); % show trimmed Image

%% Rotate the trimmed image
% 2D Rotation!
pupil_rot = imrotate(trimmed_im,205,'nearest','crop'); % conserve square dimensions
% imshow(B, 'Parent', ax_pupil)

%% Re-mask B!!

[sc, sr, sh] = findPupil(ax_pupil,pupil_rot,[172 183],0.995);
sub_mask = mask(pupil_rot,sc(1,:),sr(1));
pupil_rot = uint16(sub_mask).* pupil_rot; % re-mask the individual pupil

%% Replace rotated image to Destination Place

subpts = calcEndPts(pupil_dest,centers,max_r);
sub_im = replacePupil(raw2,pupil_rot,sub_mask,subpts);

%% Final Image

h_sub = figure;
ax_sub = axes(h_sub);
imshow(sub_im, 'Parent', ax_sub);

strIdx = 1:7;
h_strIdx_post = text(ax_sub,centers(:,1),centers(:,2),num2cell(strIdx(1,:)),'color','blue');
% delete(h_strIdx); % command if you want to delete text label