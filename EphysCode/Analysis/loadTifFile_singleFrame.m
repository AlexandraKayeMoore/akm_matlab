function [frameOut, imInf]=loadTifFile_singleFrame(filename)
% Loads a file into the workspace given a filename.
% Must be in the directory containing the desired tiff file.
% akm 7/3/17

curDir=pwd;
filepath=[curDir, '\',filename];

fullFile=strcat(filepath);

imInf=imfinfo(fullFile);

%create matrix to store the image file
frameOut=uint8(zeros(imInf(1).Height,imInf(1).Width,size(imInf,1)));

%store the entire .tif in matrix S

for frame=1%:size(imInf,1)
    thisFrame_rgb=imread(fullFile,frame);
    frameOut(:,:)=thisFrame_rgb(:,:,1); % (PG TIFF files are saved as RGB, but the 3 channels are identical)
end


end




