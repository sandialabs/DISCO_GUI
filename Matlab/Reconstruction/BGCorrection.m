function [BGcorrected] = BGCorrection(calibIm,BGSignal)
%BGCorrection : This function takes the output of
%CalibrationStation_Clipped and removes the background signal from a DISCO
%Lab Capture. 
%   BGSignal - the Background Signal should be 2D double matrix. It is
%           assumed this image is co-oriented with the output of 
%           CalibrationStation(_Clipped). 
%   calibIm  - 2D double matrix. This Image should be the desired output of
%           CalibrationStation(_Clipped)
%   
%   Both input dimensions must agree




BGcorrected = calibIm - BGSignal;

end

