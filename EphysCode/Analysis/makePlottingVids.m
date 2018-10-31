
function makePlottingVids(vidDir,vidSampRate)
%============================================================================================================================
% CREATE COMBINED PLOTTING VIDEOS
% Creates an .avi movie for each trial of an experiment that combines the behavior video, 
% the membrane voltage, and the optic flow data.
% e.g. 
% vidDir='C:\Users\AKM\MATLAB_AKM\Data\071917_001\vidout_071917_001_008';
% makePlottingVids(vidDir,10e3,15);

%============================================================================================================================
dbstop if error


disp('Creating combined plotting video...')
trialStr=vidDir(strfind(vidDir,'vidout'):end);
dataDir=strrep(vidDir,['\' trialStr],''); % location of the corresponding daqout file 
savePath=vidDir;

cd(vidDir);

if ~isempty(dir('flowData*'))
    
    
    %% Load data
    
    % Go to the main data folder and get the axopatch data
    cd(dataDir)
    daqFileName=strrep([trialStr '.mat'],'vidout','daqout');
    in=load(daqFileName);
    dataSampRate=in.settings.sampRate;
    if strcmp(in.trialMeta.mode,'I=0') || strcmp(in.trialMeta.mode,'I-Clamp Normal')
        %axoTrace.data=in.data.scaledVoltage;
        axoTrace.data=in.data.voltage;
        axoTrace.units='voltage (mV)';
    elseif strcmp(in.trialMeta.mode,'V-Clamp')
        %axoTrace.data=in.data.scaledCurrent;
        axoTrace.data=in.data.current;
        axoTrace.units='current (pA)';
    end
    trialDur_s=length(axoTrace.data)/dataSampRate;
    startTime=in.trialMeta.trialStartTime;
    clear in
    
    % Load optic flow data & resample
    cd(vidDir);
    flowFile=dir('flowData*');
    in=load(flowFile.name);
    flowMag=in.flowMag;
    flowMag=resample(flowMag,dataSampRate,vidSampRate);
    clear in
    
    % Load the movie for the current file
    myMovie=[];
    aviFile=dir('*.avi');
    myVid=VideoReader(aviFile.name);
    while hasFrame(myVid)
        currFrame=readFrame(myVid);
        myMovie(:,:,end+1)=rgb2gray(currFrame);
    end
    myMovie=uint8(myMovie(:,:,2:end)); % Adds a black first frame for some reason, so drop that
    clear myVid

    % Get the inter-frame interval in samples
    nframes=size(myMovie,3);
    frameInterval=round(length(axoTrace.data)/nframes);
    timeTrace_s=1:length(axoTrace.data);
    timeTrace_s=timeTrace_s/dataSampRate;
    expectedFrames=floor(trialDur_s/(frameInterval/dataSampRate));

    flowMag=flowMag(1:length(timeTrace_s)); % Discard extra samples at the end of the flow trace
    
    
    %% Create static figure 
    
    if 1
        
        figure
        set(gcf,'color',[1 1 1],'position',[5 940 2500 400])
        
        low_pass_cutoff=3e3; % 3 kHz
        fprintf('\nLow-pass filtering at %d Hz\n',low_pass_cutoff);
        [b,a]=butter(1,low_pass_cutoff/(dataSampRate/2),'low');
        filteredTrace=filtfilt(b,a,axoTrace.data);
        hold on; plot(timeTrace_s,filteredTrace,'k')
        %filteredTrace=notch60(axoTrace.data,dataSampRate);

        
        % Optic flow trace
        sFactor=2*(max(filteredTrace)-min(filteredTrace));
        flowMag_scaled=(flowMag/max(flowMag))*sFactor;
        flowMag_scaled=flowMag_scaled-min(flowMag_scaled);
        flowMag_scaled=flowMag_scaled-(median(filteredTrace));
        if median(filteredTrace)>median(flowMag_scaled)
            flowMag_scaled=flowMag_scaled-(2.5*min(filteredTrace));
        end
        hold on; plot(timeTrace_s,flowMag_scaled,'color',rgb('SteelBlue'))
        
        axis tight
        yl=get(gca,'ylim');
        set(gca,'ylim',[yl+[-8 +8]])
        ylabel('voltage (mV)');
        xlabel('time (s)')
        grid on
        title(vidDir,'interpreter','none') 
        
        if 1
            figName=trialStr;
            savefig(figName);
            close
        end
        
    end
    
    
    
    if 1 % Create combined movie
        
        % Create save directory and open video writer
        
        cd(savePath)
        myVid=VideoWriter(...
            fullfile(savePath,...
            [strrep(trialStr,'vidout','comb_plot') '.avi'])...
            );
        myVid.FrameRate=vidSampRate;
        open(myVid)
        
        % Display & write each frame
        
        for thisFrame=1:expectedFrames
            
            currFrame=myMovie(:,:,thisFrame);
            if thisFrame==1
                currSamples=1:frameInterval;
            else
                currSamples=currSamples(end)+1:round(frameInterval*thisFrame);
            end
            
            figPos=[19 200 2500 950];
            framePos=[62 508 596 408];
            OFPos=[85 103 2384 387];
            h=figure(10);
            clf
            set(h,'Position',figPos,'color',[1 1 1]);
            
            % Movie frame
            
            axes('Units', 'Pixels', 'Position', framePos);
            imshow(currFrame);
            axis off
            hold on
            textpos=ceil([size(currFrame)*0.9]);
            frametext=text(textpos(2),textpos(1),...
                [strrep(trialStr,'vidout_','') ' (' num2str(thisFrame) ')' ]);
            set(frametext,'fontsize',15,'Color',[1 1 1],...
                'HorizontalAlignment','right','interpreter','none');
            
            % Optic flow (scaled) & Vm
            
            axes('Units', 'Pixels', 'Position',OFPos);
            hold on; plot(timeTrace_s,flowMag_scaled(1:length(timeTrace_s)),...
                'color',rgb('SteelBlue'))
            hold on; plot(timeTrace_s, axoTrace.data,...
                'color','k');
            
            axis tight
            yl=get(gca,'ylim');
            set(gca,'ylim',[yl+[-10 +10]])
            
            x1=timeTrace_s(currSamples(1));
            x2=timeTrace_s(currSamples(end));
            hold on; line(x1*[1 1],yl,'color','r')
            hold on; line(x2*[1 1],yl,'color','r')
            
            xlabel('time (s)');
            ylabel(axoTrace.units);
            set(gca,'fontsize',15,'ylim',yl,'tickdir','out','ticklength',[.005 .005])
            
            % Write to video
            
            writeFrame=getframe(h);
            writeVideo(myVid, writeFrame);
            
        end
        
        close(myVid)
        disp('done')
        
    end
    
end

end



