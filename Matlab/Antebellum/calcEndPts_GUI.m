function [endpts] = calcEndPts_GUI(center,maxRadius)
%CALCENDPTS will return a 2x2 matrix holding the index values about a
%bounding box relative to the pupil index. It is based on the maximum
%radius given by all the found circles.

%   Inputs:
%   Center: one Double variable representing Center of Circle
%   maxRadius: double Max radius of all pupils. Using Max Radius ensures a
%   consistent size replacement across all boxes
%

% endpts = round([center(pupilIdx,1) - maxRadius,center(pupilIdx,1) + maxRadius;
%      center(pupilIdx,2) - maxRadius,center(pupilIdx,2) + maxRadius]);


endpts = round([center(1) - maxRadius,center(1) + maxRadius;
     center(2) - maxRadius,center(2) + maxRadius]);
 
 
 
end
