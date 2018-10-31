function plotScaledData(daqfilepath,daqfilename,xlimits_s)
%% plotScaledData(daqfilepath,daqfilename,xlimits_s)
% Examples: 
%    daqfilepath - 'D:\data_main\090318_001'
%    daqfilename - 'daqout_090318_001_001.mat' 
%    xlimits_s - [4.5 6.5], defaults to the full recording time if []
% plotScaledData('D:\data_main\090318_001','daqout_090318_001_001.mat',[])

% Updated 10/26/18 - saves events traces to file, now with voltage traces

dbstop if error

patterns_dir='C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns';
functions_dir='C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\functions\make_function_files';

cd(daqfilepath)
in=load(daqfilename);
fprintf('\n       %s',daqfilename);

%% Check for visual stimuli
panelParams=[];
events=[];

if strcmp(in.stimulus.type,'visual_stim')
    
    panelParams=in.stimulus.panelParams;
    fprintf('\n   Panel stimului found:');
    
    % Find pattern & function files
    
    cd(patterns_dir);
    patternFile=dir( sprintf('Pattern_%03d*',panelParams.patternNum) );
    fprintf('\n    - %s\n',patternFile.name);
    
    cd(functions_dir);
    fInfoFilename=sprintf('fInfo_%03d_%03d.mat',panelParams.positionFunctionX,panelParams.positionFunctionY);
    load(fInfoFilename);
    fprintf('    - %s\n\n',fInfo.fDescription);
    
    % Process & parse panel events  
    
    events_filename=strrep(daqfilename,'daqout','events');
    
    [events,eventTrace]=processPanelData(in,fInfo,daqfilename);
    
    if ~isempty(events)
        cd(daqfilepath)
        save(events_filename,...
            'events','eventTrace',...
            'patternFile','fInfoFilename');
        
    end
    
    eventTypes=unique({events(:).name});
else
    eventTypes=[];
end







%% Check for other stimuli and current steps

% Check for laser pulses...
laserTrace=[];
try strcmp(in.stimulus.type,'laser_pulses')
    laserTrace=in.stimulus.laserTrace;
    fprintf('\n       Laser pulses found.')
end


% Check for i-clamp commands...
Icmd=[];
try
    range(in.stimulus.iclamp_command);
catch
    in.stimulus.iclamp_command=in.stimulus.ao_command;
end
if range(in.stimulus.iclamp_command)>1 %(stimulus.ao_command)<1
    if isfield(in.stimulus,'stimTrace')
        Icmd=in.stimulus.stimTrace;
    elseif isfield(in.stimulus,'currentTrace')
        Icmd=in.stimulus.currentTrace;
    else
        % calculate requested current
        Icmd=in.stimulus.iclamp_command*in.settings.AO_output_scaling_factor*in.settings.axopatch_picoAmps_per_volt;
    end
    fprintf('\n       I_clamp command found.')
end


% Check for FicTrac [formerly optic flow] data...
try
    
    % Find .dat file--
    
    cd(daqfilepath)
    ftFolder=dir('ft_output*');
    cd(ftFolder.name);
    ftFile=strrep(daqfilename,'daq','vid');
    ftFile=strrep(ftFile,'.mat','.dat');
    M=csvread(ftFile);
    
    % Get speed & heading traces--
    
    % Inst. running speed
    iSpeed=M(:,19);
    iSpeed(1)=iSpeed(2);
    low_pass_cutoff=20; % Hz
    [b,a]=butter(1,low_pass_cutoff/(in.settings.camRate/2),'low');
    iSpeed=filtfilt(b,a,iSpeed);
    iSpeed=iSpeed*0.3501*in.settings.camRate; % convert to cm/s: (rad/frame)*(frames/s)*0.3501
    
    % Integrated heading direction
    intHeading=M(:,17);
    intHeading(1)=intHeading(2);
    low_pass_cutoff=20; % Hz
    [b,a]=butter(1,low_pass_cutoff/(in.settings.camRate/2),'low');
    intHeading=filtfilt(b,a,intHeading);
    intHeading=intHeading*57.2958; % convert radians to degrees
    
    % Time of each frame in seconds
    FT_t=1:length(M);
    FT_t=FT_t/in.settings.camRate;
    
    fprintf('\n       FicTrac data found.')
    
catch
    iSpeed=[];
end





%% Plot current trace

figHandle=figure;
set(figHandle,'color',[1 1 1])%'position',[50 50 1263 920])

axI=subplot(2,1,1);
t_s=[1:length(in.data.current)]/in.settings.sampRate;



plot(t_s,in.data.current,'color',rgb('darkcyan')*.8);

xlabel('');
ylabel('pA');
axis tight;
yl=get(gca,'ylim');
yl=yl+(range(in.data.current)*[-0.6 0.6]);
set(gca,'ylim',yl);
grid on; box off;

if ~isempty(xlimits_s)
    set(gca,'xlim',xlimits_s);
end

% Add title to topmost subplot
if isempty(panelParams)
    title(daqfilename,'interpreter','none','fontweight','normal','fontangle','italic')
else
    titleString=[strrep(daqfilename,'.mat','') ' - ' strrep(patternFile.name,'.mat','')];
    title(titleString,'interpreter','none','fontweight','normal','fontangle','italic')
end


try % Plot odor
    yl=get(gca,'ylim');
    odorTrace=in.stimulus.A_valve_command;
    scaledOdorTrace=rescale(odorTrace,yl(1),yl(2));
    hold on; h1=area(t_s,scaledOdorTrace,yl(1)); % previously 'stimulus.odor_valve_command' and 'in.stimulus.pinch_valve_command'
    set(h1,'edgecolor','none','facecolor',rgb('goldenrod'),'facealpha',0.2)
catch
    odorTrace=[];
end

if ~isempty(events) % Plot events 
    
    hold on; ah=area(t_s,(eventTrace*range(yl))+yl(1),yl(1));
    set(ah,'edgecolor','none','facecolor',[255 245 34]/255,'facealpha',0.4);
    uistack(ah,'bottom');
    
    % Label events
    if length(eventTypes)>1
        for e=1:length(events) % For each event...
            eI=find(strcmp(events(e).name,eventTypes)==1);
            shortLabel=[num2str(eI)];
            xp=events(e).start/in.settings.sampRate;
            yp=max(in.data.current)+(yl(2)/4);
            t=text(xp,yp,shortLabel);
            set(t,'color','k','fontsize',8);
        end
    end
    
    
end




%% Plot voltage trace

axV=subplot(2,1,2);

%hold on; plot(t_s,in.data.scaledVoltage,'color',rgb('midnightblue'));
hold on; plot(t_s,in.data.voltage,'color',rgb('midnightblue'));

xlabel('time (s)');
ylabel('mV');
axis tight;
yl=get(gca,'ylim');
yl=yl+(range(in.data.voltage)*[-0.25 0.25]);
set(gca,'ylim',yl);
grid on; box off

if ~isempty(xlimits_s)
    set(gca,'xlim',xlimits_s);
end

try % Plot odor
    yl=get(gca,'ylim');
    scaledOdorTrace=rescale(odorTrace,yl(1),yl(2));
    hold on; h1=area(t_s,scaledOdorTrace,yl(1)); % previously 'stimulus.odor_valve_command' and 'in.stimulus.pinch_valve_command'
    set(h1,'edgecolor','none','facecolor',rgb('goldenrod'),'facealpha',0.2)
catch
    odorTrace=[];
end

if ~isempty(events) % Plot and label events
    
    hold on; ah=area(t_s,(eventTrace*range(yl))+yl(1),yl(1));
    set(ah,'edgecolor','none','facecolor',[255 245 34]/255,'facealpha',0.4);
    uistack(ah,'bottom');
    
    % Label events
    if length(eventTypes)>1
        for e=1:length(events) % For each event...
            eI=find(strcmp(events(e).name,eventTypes)==1);
            shortLabel=[num2str(eI)];
            xp=events(e).start/in.settings.sampRate;
            yp=max(in.data.voltage)+2;
            t=text(xp,yp,shortLabel);
            set(t,'color','k','fontsize',8);
        end
    end
    
    
end

linkaxes([axV axI], 'x');

if ~isempty(eventTypes)
    set(axI,'position',[0.089 0.590 0.877 0.306])
    set(axV,'position',[0.089 0.176 0.877 0.340])
    axE=axes();
    set(axE,'position',[0.080 0.045 0.877 0.071],'ylim',[0 2]);
    eventKey=[];
    for m=1:length(eventTypes)
        eventKey=[eventKey num2str(m) '=' eventTypes{m}  '   '];
    end
    text(0.01,1,eventKey,'interpreter','none');
    axis off
end


if ~isempty(events)



%% optional, 0/1 - Plot stimuli and fictrac data

if 0
    
    axStim=subplot(3,1,3);
    
    if sum([isempty(laserTrace),isempty(Icmd),isempty(iSpeed)])==3
        axis off
    else
        % Plot ft data --
        if ~isempty(iSpeed)
            hold on; plot(FT_t,iSpeed,'color',rgb('darkolivegreen'))
            ylabel('cm/s')
        end
        % Plot laser --
        if ~isempty(laserTrace)
            laserTrace=laserTrace/max(laserTrace);
            hold on; plot(t_s,laserTrace,'color',rgb('firebrick'))
        end
        xlabel('time (s)')
        axis tight;
        % yl=get(gca,'ylim');
        % set(gca,'ylim',yl+[-5 5]);
        grid on;
        box on;
    end
    
    set(figHandle,'color',[1 1 1])
    
end

end






