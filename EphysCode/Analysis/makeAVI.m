function makeAVI(parentDir,FR,ycrop,xcrop)
%============================================================================================================================
% CREATE MOVIES FROM .TIF FILES
% Creates an .avi movie for each trial of an experiment from the .tif files captured by the fly behavior camera, and returns 
% a message string indicating whether the operation was a success (and if not, which trial it failed on). The videos are
% saved in the same location as the .tif files that they were created from.
%       
%       parentDir = *full path* to the folder containing the .tif files for this trial.
%       FR = frame rate (usually 30)
%       ycrop, xcrop = vectors of rows/cols to keep; pass NaNs to use the whole image
% 
% edited 7/19/17 akm

%============================================================================================================================

cd(parentDir)
%startchar=strfind(parentDir,'vidout');
% trialStr=parentDir(startchar:end);
trialStr=strsplit(parentDir,'\');
trialStr=trialStr{end};
savePath=parentDir;

currFiles = dir('*.tif');

% Make sure there's at least one image file and no .avi file already in this trial's directory
if ~isempty(currFiles) && isempty(dir('*.avi'))
    
    currFrames = {currFiles.name}';
    
    % Create video writer object
    outputVid = VideoWriter([fullfile(savePath, [trialStr, '.avi'])]);
    outputVid.FrameRate = FR; % normally 30; expData.expInfo(1).acqSettings.frameRate;
    open(outputVid)
    
    % Write each .tif file to video
    tic
    for iFrame = 1:length(currFrames)
        currImg = imread(fullfile(savePath, currFrames{iFrame}));
        if ~isnan([ycrop(:);xcrop(:)]); 
            currImg = currImg(ycrop,xcrop);
        end
        writeVideo(outputVid, currImg);
    end
    toc
    close(outputVid)
    
end


end%function