function plotTraceSnippets_CA(filepath,filename,snippets,mvLineAt)

%% Load data

dbstop if error
vidfolder=filepath;
cd(filepath)
in=load(filename);
fprintf('\n\nPlotting %s',filename)

% Check for laser pulses --
laserTrace=[];
try strcmp(in.stimulus.type,'laser_pulses');
    laserTrace=in.stimulus.laserTrace;
    fprintf('\n  Laser pulses found.\n')
catch
    fprintf('\n  No laser pulses found.\n')
end

% Check for i-clamp commands --
Icmd=[];
if range(in.stimulus.ao_command)<1;
    try
        Icmd=in.stimulus.stimTrace;
    catch
        Icmd=in.stimulus.currentTrace;
    end
else
    fprintf('\n  No current steps found.\n')
end

% Check for optic flow data --
fdFile=[];
try
    % Load flow data file, if it exists
    fdFile=dir( strrep([filename '*'],'daqout','flowData') );
    fdFile=load(fdFile(1).name);
    fprintf('\n  flowData file found.\n')
catch
    fprintf('\n  No flowData found.\n')
end




t_s=[1:length(in.data.current)]/in.settings.sampRate;

if 1
    data=in.data.current;
    low_pass_cutoff=500; % 3 kHz
    
    fprintf('\nLow-pass filtering at %d Hz\n',low_pass_cutoff);
    [b,a]=butter(1,low_pass_cutoff/(in.settings.sampRate/2),'low');
    filteredTrace_LP=filtfilt(b,a,data);   
%     figure
%     hold on; plot(t_s,data,'r')
%     hold on; plot(t_s,filteredTrace_LP,'k')

    high_pass_cutoff=10;
    fprintf('\nHigh-pass filtering at %d Hz\n',high_pass_cutoff);
    [b,a]=butter(1,high_pass_cutoff/(in.settings.sampRate/2),'high');
    filteredTrace_HP=filtfilt(b,a,filteredTrace_LP);
%     figure
%     hold on; plot(t_s,filteredTrace_LP,'r')
%     hold on; plot(t_s,filteredTrace_HP,'k')
    in.data.current=filteredTrace_HP;
end

%% For each snippet...
figure;
yoffset=0;
for s=1:length(snippets)
    
    yoffset=yoffset+2;

%% Voltage trace & line - rescale and plot
    
    [~,startSample]=find( t_s>=snippets(s).sec(1) );
    startSample=startSample(1);
    [~,endSample]=find( t_s<snippets(s).sec(2) );
    endSample=endSample(end);
    
    xoffset=t_s(startSample);

    vSnip=in.data.current(startSample:endSample);
    vLine=repmat(mvLineAt,1,length(vSnip));
    vLine(in.settings.sampRate:(1.5*in.settings.sampRate))=vLine(1)+5; % mark +5 mV & 500 ms
    vSnip2=vSnip-min(vSnip);
    vLine2=vLine-min(vSnip);
    vSnip3=vSnip2/max(vSnip2);
    vLine3=vLine2/max(vSnip2);
        
    hold on; plot(t_s(startSample:endSample)-xoffset,vSnip3+yoffset,'color','k');
    hold on; plot(t_s(startSample:endSample)-xoffset,vLine3+yoffset,'color','b');
    hold on; TH=text(1,vSnip3(1)+yoffset,sprintf('\n%0.f mV (5 mV, 500 ms)',vLine(end)));
    set(TH,'color','b','fontsize',8);
    
    %% Plot laser trace
       if ~isempty(laserTrace)
        % t_s, startSample, endSample, and xoffset
        % all apply to 'laserTrace'
        laserSnip=laserTrace(startSample:endSample);
        laserSnip=laserSnip-min(laserSnip);
        laserSnip=(laserSnip/max(laserSnip))*0.5;
        hold on;
        plot(t_s(startSample:endSample)-xoffset,...
            laserSnip+(yoffset-0.5),...
            'color','k');

    end
    
    
    
    %% OF trace - load, rescale and plot
  
    
    
    
    
    
    
    
    in.settings.camRate=15;
    
    % Always discard the first frame and set t_s_frames(1)
    % to 1/camrate (0.0333 s), instead of zero.
    flowMag=fdFile.flowMag(2:end);
    flowMag( flowMag>prctile(flowMag,99) )=prctile(flowMag,99);
    % Calculate samples/frame and round that number to get the
    % inter-frame-interval!
    samples_per_frame=round(in.settings.sampRate/in.settings.camRate);
    t_s_frames=t_s(samples_per_frame:samples_per_frame:end);
   
    % Sanity check:
    %   figure
    %   hold on; plot(t_s_frames,flowMag,'o-');
    %   hold on; plot(t_s,in.settings.cameraTrigOut*median(flowMag));

    
    
    
    [~,startSample_frames]=find( t_s_frames>=snippets(s).sec(1) );
    startSample_frames=startSample_frames(1);
    [~,endSample_frames]=find( t_s_frames<snippets(s).sec(2) );
    endSample_frames=endSample_frames(end);
    xoffset_frames=t_s_frames(startSample_frames);
    
    % Subtract baseline & normalize to 0.5
    fSnip=flowMag(startSample_frames:endSample_frames);
    fSnip=fSnip-min(fSnip); 
    fSnip=(fSnip/max(fSnip))*.5;
    
    % Plot just below the voltage trace
    hold on; plot(t_s_frames(startSample_frames:endSample_frames)-xoffset_frames,...
        fSnip+(yoffset-0.5),...
        'color','r','linewidth',1.2)
    


    
    
end




title(filename,'interpreter','none')
set(gca,'ylim',[1 yoffset+2],'position',[.08 .15 .87 .70])
axis off
set(gcf,'color',[1 1 1],...
    'position',[45 105 1200 650])



end





