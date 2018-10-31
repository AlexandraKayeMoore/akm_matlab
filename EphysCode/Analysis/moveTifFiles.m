function moveTifFiles(vidFolder)
% moveTifFiles(), akm 11/11/17
% Move tif images to the back-up drive if a 'flowData' file and .avi movie
% have been created. 
% INPUT:
%  vidFolder - *full path* to video folder
% Example: moveTifFiles('C:\Users\AKM\MATLAB_AKM\Data\100917_001\vidout_100917_001_012')

str_idx=strfind(vidFolder,'\');
str_idx=str_idx(end-1);
dataBackupDir= ['D:\data_backup' vidFolder(str_idx:end)];

if ~isdir(dataBackupDir)
    mkdir(dataBackupDir);
end

cd(vidFolder)

movieFile=dir('vidout*.avi');
flowDataFile=dir('flowData*.mat');

if ~isempty(movieFile) && ~isempty(flowDataFile)
    
    imFiles=dir('fc2_save*.tif');
    for f=1:length(imFiles);
        movefile(imFiles(f).name,dataBackupDir);
    end
    fprintf('\n\n %.0f tif files were moved to backup.\n\n',length(imFiles));
    
else
    
    fprintf('\n\n Tif files were not moved to backup because processed video files were not found.\n\n')
    return
    
end


end