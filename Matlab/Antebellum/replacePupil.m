function [imageOut] = replacePupil(imageIn,subPupil,subMask,subPoints)
%ReplacePupil replaces sub pupil into the Full-sized image.
%   imageIn     : Full size image with missing pupil
%   subPupil    : image of subpuipl to be inserted into imageIn to produce
%                 imageOut
%   subMask     : binary mask of smaller pupil.Im 
%   subPoints   : destination corner points inside imageIn where insertion
%                 of subPupil will take place


row_sub = subPoints(2,1):subPoints(2,2)-1;
col_sub = subPoints(1,1):subPoints(1,2)-1;

imageOut = imageIn;
for i = 1: size(subPupil,1)
    for j = 1:size(subPupil,2)
        if(subMask(i,j))
            imageOut(row_sub(i),col_sub(j)) = subPupil(i,j);
        end
    end
end

end

