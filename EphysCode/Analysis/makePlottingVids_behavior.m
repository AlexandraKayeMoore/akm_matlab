
function makePlottingVids_behavior(vidDir,vidSampRate)
% Creates an .avi movie for each trial of an experiment. 
% akm 2/7/18

dbstop if error

disp('Creating combined plotting video...')
trialStr=vidDir(strfind(vidDir,'vidout'):end);
dataDir=strrep(vidDir,['\' trialStr],''); % location of the corresponding daqout file
savePath=vidDir;

cd(vidDir);

if ~isempty(dir('flowData*')) && isempty(dir('comb_plot*'))
    
    
    %% Load data
    
    % Go to the main data folder and get the axopatch data
    cd(dataDir)
    daqFileName=strrep([trialStr '.mat'],'vidout','daqout');
    in=load(daqFileName);
    settings=in.settings;
    stimulus=in.stimulus;
    clear in
    
    % Load optic flow data
    cd(vidDir);
    flowFile=dir('flowData*');
    in=load(flowFile.name);
    flowMag=in.flowData;
    flowMag(1:5)=median(flowMag); % Clear the first few OF values
    flowMag=rescale(flowMag);
    clear in
    
    if sum(settings.cameraTrigOut>.5) ~= length(flowMag)
        keyboard % Mismatch!
    end
    
    
    % Input video
    cd(vidDir)
    aviFile=dir('*.avi');
    savedVid=VideoReader(aviFile.name);
    currFrame=rgb2gray(readFrame(savedVid));
    currFrame=imresize(currFrame,0.5);
    myMovie=uint8(zeros(size(currFrame,1),size(currFrame,2),length(flowMag)));
    myMovie(:,:,1)=currFrame;
    frameCount=1;
    while hasFrame(savedVid)
        frameCount=frameCount+1;
         currFrame=rgb2gray(readFrame(savedVid));
         currFrame=imresize(currFrame,0.5);
        myMovie(:,:,frameCount)=currFrame; 
    end
    clear savedVid
    
    if 1 % Create combined movie
        
        % Start new video file
        cd(savePath)
        newVid=VideoWriter(...
            fullfile(savePath,...
            [strrep(trialStr,'vidout','comb_plot') '.avi'])...
            );
        newVid.FrameRate=vidSampRate;
        open(newVid)
        
        
        % Generate fig & write each frame to video
        [~,frameTimes_samples]=find(settings.cameraTrigOut>0.5);
        for frameCount=1:size(myMovie,3)
            
            currFrame=myMovie(:,:,frameCount); 
            if frameCount==length(frameTimes_samples)
                currSamples=frameTimes_samples(frameCount):length(settings.cameraTrigOut);
            else
            currSamples=frameTimes_samples(frameCount):frameTimes_samples(frameCount+1);
            end
            currSamples(end)=[];
            
            figPos=[26 745 862 532];
            framePos=[251 222 360 283];
            OFPos=[19 63 830 142];
            h=figure(10);
            clf
            set(h,'Position',figPos,'color',[1 1 1]);
            
            % Video frame
            axes('Units', 'Pixels', 'Position', framePos);
            hold on
            imshow(currFrame);
            axis off
            hold on
            title([strrep(trialStr,'vidout_','') ' (' num2str(frameCount) '/' num2str(length(frameTimes_samples)) ')' ],...
                'interpreter','none','fontweight','normal');
            
            % Plot optic flow & stimuli
            axes('Units','Pixels', 'Position',OFPos);
            stim_t=[1:length(stimulus.A_valve_command)]/settings.sampRate;
            hold on; area(stim_t,stimulus.A_valve_command,'facecolor',[255 234 116]/255,'edgecolor','none');
            hold on; area(stim_t,stimulus.B_valve_command,'facecolor',rgb('lightblue'),'edgecolor','none');
            hold on; area(stim_t,rescale(stimulus.laser_command),'facecolor',rgb('orangered'),'edgecolor','none');
            flow_t=frameTimes_samples/settings.sampRate;
            hold on; plot(flow_t,flowMag,'color','k','linewidth',1);
            
            x1=currSamples(1)/settings.sampRate;
            x2=currSamples(end)/settings.sampRate;
            hold on; line(x1*[1 1],[0 1],'color','r')
            hold on; line(x2*[1 1],[0 1],'color','r')
            
            axis tight
            box off
            xlabel('time (s)');
            set(gca,'fontsize',12,'tickdir','out','ticklength',[.008 .008],...
                'ytick',[]);
            
            % Write to video
            writeFrame=getframe(h);
            writeVideo(newVid, writeFrame);
            
        end
        
        close(newVid)
        disp('done')
        
    end
    
end

end