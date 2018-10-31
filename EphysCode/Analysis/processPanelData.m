function [events,eventTrace]=processPanelData(infile,fInfo,filename)
    
% akm - updated 10/26/18



%% Process x/y position traces

xpositionTrace=infile.rawData(:,7);
ypositionTrace=infile.rawData(:,8);

xpositionTrace=xpositionTrace-min(xpositionTrace); % rescale trace
xpositionTrace=xpositionTrace/max(xpositionTrace);
ypositionTrace=ypositionTrace-min(ypositionTrace);
ypositionTrace=ypositionTrace/max(ypositionTrace);

data=xpositionTrace;
low_pass_cutoff=60; % panel frame rate is 50 Hz
[b,a]=butter(1,low_pass_cutoff/(infile.settings.sampRate/2),'low');
xpositionTrace=filtfilt(b,a,data);

data=ypositionTrace;
low_pass_cutoff=60; % panel frame rate is 50 Hz
[b,a]=butter(1,low_pass_cutoff/(infile.settings.sampRate/2),'low');
ypositionTrace=filtfilt(b,a,data);



%% Find event periods

if 0 % Old patterns
    
    
    if mean(xpositionTrace(1:1e3))>0.5 % invert trace
        xpositionTrace=(xpositionTrace*-1)+1;
    end
    if mean(ypositionTrace(1:1e3))>0.5
        ypositionTrace=(ypositionTrace*-1)+1;
    end
    
    combinedTrace=[];
    eventTrace=[];
    if strfind(fInfo.fDescription,'rotate_starfield')
        eventTrace=xpositionTrace>0.014;
    elseif strfind(fInfo.fDescription,'rotate_vertical_bar')
        eventTrace=xpositionTrace>0.015;
    elseif strfind(fInfo.fDescription,'rotate_vertical_grating')
        eventTrace=xpositionTrace>0.05;
    elseif strfind(fInfo.fDescription,'elevation_azimuth_scan_')
        combinedTrace=xpositionTrace+ypositionTrace;
        eventTrace=combinedTrace>0.025;
    elseif strfind(fInfo.fDescription,'FF_flashes')
        eventTrace=xpositionTrace>0.5;
    elseif strfind(fInfo.fDescription,'flash_each_location')
        combinedTrace=xpositionTrace+ypositionTrace;
        eventTrace=combinedTrace>0.1;
    else
        keyboard
    end
end

% Wipe the first 2 sec.  of the trace
xpositionTrace([1:(2*infile.settings.sampRate)])=min(xpositionTrace);
ypositionTrace([1:(2*infile.settings.sampRate)])=min(ypositionTrace);

% Find events
eventTrace=ypositionTrace>0.025;
startTimes=find(diff(eventTrace)>0.5); % in samples
stopTimes=find(diff(eventTrace)<-0.5); % in samples

% Discard the first "event" (ramp in y)
eventTrace([1:stopTimes(1)])=min(eventTrace);
startTimes(1)=[];
stopTimes(1)=[];

if 0 % visual check
    
    figure;
    hold on; plot(xpositionTrace,'k')
    hold on; plot(ypositionTrace,'b')
    hold on; plot(eventTrace*.5,'g')
    hold on; plot(diff(eventTrace)*.1,'r')
    
    axis tight
    set(gca,'position',[0.035 0.145 0.926 0.779]);
    set(gcf,'position',[124 870 2396 468]);
    title(filename,'interpreter','none')
    
end










if (length(startTimes)+length(stopTimes)) == length(fInfo.shuffledEvents)*2;


    for e=1:length(startTimes)
        events(e).start=startTimes(e);
        events(e).stop=stopTimes(e);
        events(e).name=fInfo.shuffledEvents(e).name;
        events(e).xposvalues=fInfo.shuffledEvents(e).xposvalues
        events(e).yposvalues=fInfo.shuffledEvents(e).yposvalues
    end
    
    % Get trace snippets for plotting, from the end of
    % the previous event to the start of the next one.
    for e=1:length(events)
        
        if e==1;
            traceStart=1;
            traceStop=events(e+1).start;
        elseif e==length(events)
            traceStart=events(e-1).stop;
            traceStop=length(xpositionTrace);
        else
            traceStart=events(e-1).stop;
            traceStop=events(e+1).start;
        end
        
        events(e).currentSnippet=infile.data.current(traceStart:traceStop);
        events(e).voltageSnippet=infile.data.voltage(traceStart:traceStop);
        events(e).eventSnippet=eventTrace(traceStart:traceStop);
        
        % t=0 marks the start of the event
        events(e).t_samples=[traceStart:traceStop]-events(e).start;
        events(e).t_seconds=[events(e).t_samples]/infile.settings.sampRate;
        
        if 0 % for debugging purposes
            figure;
            hold on; plot(events(e).t_seconds,events(e).eventSnippet*100)
            hold on; plot(events(e).t_seconds,events(e).currentSnippet)
            hold on; plot(events(e).t_seconds,events(e).voltageSnippet)
            title(['event ' num2str(e)])
        end
        
    end

else
 
    fprintf('\n\n *** # events detected ~= # events expected *** \n\n')
    keyboard

    events=[];
    eventTrace=[];
    
end














    
end