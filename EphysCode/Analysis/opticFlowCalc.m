function opticFlowCalc(parentDir)
%============================================================================================================================
% CALCULATE MEAN OPTICAL FLOW
% Calculates the mean optic flow across each frame of each video from the fly behavior camera. Returns an nx1 cell array with
% a vector of these values for each trial in the experiment, and also saves it as a variable 'flowData' in a .mat file.
%       expData=entire data object for the experiment in question
%       parentDir=the file path to the parent folder containing all the .tif files for each trial. Within this directory,
%                   the frames for each trial should be saved in a folder named with the experiment and trial numbers
%                   separated by an understore (e.g. 'E1_T3')
%       savepath=the file path to the location where the .mat file containing the optical flow data will be saved
% example: opticFlowCalc('C:\Users\AKM\MATLAB_AKM\Data\100917_001\vidout_100917_001_031')
%============================================================================================================================
savePath=parentDir;
cd(parentDir)
aviFile=dir('*avi');

if ~isempty(dir('*flowData*'))
    fprintf('\n\nFlow data file already exists.\n\n')
    return
end

if ~isempty(aviFile) % Check to make sure we have video for this file
    
    % Load frames & calculate optic flow
    myVid=VideoReader(aviFile.name);
    tempImage=imresize(zeros(myVid.Height,myVid.Width),0.5);
    imageDims=size(tempImage);
    clear tempImage
    
    opticFlow=opticalFlowFarneback;
%     outputVid = VideoWriter([fullfile(savePath,flowDataFilename)]);
%     outputVid.FrameRate=FR;
%     open(outputVid);
    frameCount=0;
    flowData=[];
    
    while hasFrame(myVid)
        frameCount=frameCount+1;
        currFrame=rgb2gray(readFrame(myVid));
        currFrame=imresize(currFrame,0.3);
        currFlow=estimateFlow(opticFlow,currFrame);
        flowData(frameCount)=sum(currFlow.Magnitude(:));
    end
    
%     close(outputVid)
    clear myVid
    flowDataFilename=strrep(aviFile.name,'vidout','flowData');
    flowDataFilename=strrep(flowDataFilename,'.avi','.mat');
    cd(savePath)
    save(flowDataFilename,'flowData');
   
end




end


