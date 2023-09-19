function [centers,radii,h_out] = findPupil(ax_in,image_in,radiusRange, sensitivity)
%UNTITLED2 Find the Pupils in an image via imfindcircles(). Should allow
%for dynamic selection of options such as RadiusRange and Sensitivity.
%   ax_in       : axes object to display found circles
%   image_in    : 2D greyscale image (uint16)
%   radiusRange : {low high} value pair to find circles (pupils) within
%                 radius range
%   Sensitivity : Value [0:1] to help discern circles. Set higher value for
%                 low-contrast image
%OUTPUTS
%   centers     : an array (or singular) pair showing found (h,k)
%   radii       : an vector giving approximate radius lengths for each
%                 centers pair

 
[centers, radii] = imfindcircles(image_in,radiusRange,'Sensitivity',sensitivity);

centers = ceil(centers);
radii = ceil(radii);

% h_out =  viscircles(ax_in,centers,radii);
 h_out =  appviscircles(ax_in,centers,radii);

end

