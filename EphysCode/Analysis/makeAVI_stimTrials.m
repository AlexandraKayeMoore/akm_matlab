function makeAVI_stimTrials(parentDir,FR)
%============================================================================================================================
% CREATE MOVIES FROM .TIF FILES
% Creates a .avi movie file; indicates when stimuli are presented. 
%       parentDir=*full path* to the folder containing the .tif files for this trial.
%       FR=frame rate (usually 30)
%============================================================================================================================
dbstop if error

cd(parentDir)
trialStr=strsplit(parentDir,'\');
trialStr=trialStr{end};
savePath=parentDir;

all_image_files=dir('*.tif');

if ~isempty(all_image_files) % && isempty(dir('*.avi'))
    
    
    % Create video writer object
    outputVid=VideoWriter([fullfile(savePath, [trialStr, '.avi'])]);
    outputVid.FrameRate=FR; % normally 30; expData.expInfo(1).acqSettings.frameRate;
    open(outputVid)
    
    % Get stimulus file
    daqfilepath=strrep(parentDir,'vidout','daqout');
    daqfile=load(daqfilepath);
    frameTrigs=daqfile.settings.cameraTrigOut;
    A_valve_cmd=daqfile.stimulus.A_valve_command;
    B_valve_cmd=daqfile.stimulus.B_valve_command;
    laser_cmd=daqfile.stimulus.laser_command;
    dataSampRate=daqfile.settings.sampRate;
    frameRate=daqfile.settings.camRate;
    
    % Get status of stimulus channels for each video frame
    [~,triggerIndeces]=find(frameTrigs>0.5);
    A_valve_status=A_valve_cmd(triggerIndeces);
    B_valve_status=B_valve_cmd(triggerIndeces);
    laser_status=laser_cmd(triggerIndeces);
    clear daqfile
    
    % Write to video
    
    image_filenames={all_image_files.name}';
    h=figure;
    
    for iFrame=1:length(image_filenames)
        
        currImg=imread(fullfile(savePath,image_filenames{iFrame}));
        clf(h);
        imshow(currImg);
        
            if A_valve_status(iFrame)>0;
                t=text(size(currImg,1)-100,size(currImg,2)-380,'Odor A');
                set(t,'color',[1 1 1],'fontsize',35,'fontweight','b');
            end
            
            if B_valve_status(iFrame)>0;
                t=text(size(currImg,1)-100,size(currImg,2)-300,'Odor B');
                set(t,'color',[1 1 1],'fontsize',35,'fontweight','b'); 
            end
            
            if laser_status(iFrame)>0;
                t=text(size(currImg,1)-100,size(currImg,2)-220,'Laser');
                set(t,'color',[1 1 1],'fontsize',35,'fontweight','b'); 
            end
                    
        axis off
        writeFrame=getframe(h);
        writeFrame=rgb2gray(writeFrame.cdata);
        writeVideo(outputVid,writeFrame);
         
    end
    
    close(outputVid)
    
end

end %function