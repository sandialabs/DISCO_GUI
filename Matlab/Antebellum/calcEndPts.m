function [endpts] = calcEndPts(pupilIdx,centers,maxRadius)
%CALCENDPTS will return a 2x2 matrix holding the index values about a
%bounding box relative to the pupil index. It is based on the maximum
%radius given by all the found circles.

%   Detailed explanation goes here
%
%
%

endpts = round([centers(pupilIdx,1) - maxRadius,centers(pupilIdx,1) + maxRadius;
     centers(pupilIdx,2) - maxRadius,centers(pupilIdx,2) + maxRadius]);


end

