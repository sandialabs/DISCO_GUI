%% Final Image Save Sequence

%Converts the mat data file into an image with correct caxis limits.

load('C:\Users\asmith2\Documents\GitKraken\DISCO_Master\disco_imageprocessor\Matlab\Antebellum\ImageSaveSeq\Final_Im_Mat.mat');

%Convert nans to 0

finIm = FinImMat;

finIm(isnan(finIm)) = 0;

dmin = min(finIm(:));
dmax = max(finIm(:));

a = 0;
b = 2^16 -1;

X = a + (b-a).*(finIm - dmin)./(dmax - dmin);
X = X./(2^16 -1);

figure; imshow(X);


Y = FinImMat./2^16;
Z = mat2gray(Y);
figure; imshow(Z)
