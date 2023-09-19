function [mask] = mask(image_in, center_in, radius_in )
% mask() receives an image, return binary mask
%   image_in should be the image currently being worked on
%   center_in : pass in 1 center pair. {row,column} corresponding to the pupil of interest.
%   radius_in : corresponding radius of pupil of interest.

[rr,cc] =  meshgrid(1:size(image_in,2),1:size(image_in,1)); % create mesh index plane
mask = sqrt( (rr-center_in(1,1)).^2 + (cc - center_in(1,2)).^2 ) <= radius_in(1); 

end

