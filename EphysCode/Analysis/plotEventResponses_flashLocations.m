function plotEventResponses_flashLocations(filepath,daqfilename,eventsfilename,baseline_mV,plus_minus_mV)
%% plotEventResponses_flashLocations(filepath,daqfilename,eventsfilename,baseline_mV,plus_minus_mV)
% 10/26/18
% Example arguments --
%   filepath: 'D:\data_main\090318_001'
%   daqfilename: 'daqout_090318_001_001.mat'
%   eventsfilename: 'events_090318_001_001.mat'
%   baseline_mV: -35 (defaults to average V_m if 'nan')
%   plus_minus_mV: 3 (defaults to 5 if 'nan')

dbstop if error

patterns_dir='C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns';
functions_dir='C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\functions\make_function_files';

cd(filepath);
load(eventsfilename);



% Count up the number of unique events

all_event_strings={events(:).name};
eventNames=unique(all_event_strings);

evalues=[];
avalues=[];
for e=1:length(events)
    if strcmp('elevation_scan_DU',events(e).name) || strcmp('elevation_scan_UD',events(e).name)
        avalues=[avalues unique(events(e).xposvalues)];
    end
    
    if strcmp('azimuth_scan_RL',events(e).name) || strcmp('azimuth_scan_LR',events(e).name)
        evalues=[evalues unique(events(e).yposvalues)];
    end
end

evalues=unique(evalues);
avalues=unique(avalues);



if isnan(baseline_mV) % Get baseline value, if it wasn't provided
    
    grandMed=[];
    for e=1:length(events)
        grandMed(e)=median(events(e).voltageSnippet);
    end
    baseline_mV=round(median(grandMed));
    
end
if isnan(plus_minus_mV)
    plus_minus_mV=5;
end 



% Load panel look-up table
load('C:\Users\amoore\akm_matlab\EphysCode\Analysis\panelLookUp.mat');


figure; 
set(gcf,'position',[320 60 910 1230]);

for thisPanel=1:18
    
    subplot(9,2,thisPanel);
    title(num2str(thisPanel));
    
    for e=1:length(events)
        
        e_pos=[events(e).xposvalues events(e).yposvalues];
        
        if panelInfo(thisPanel).xpos_ypos==e_pos
            esnip=events(e).eventSnippet;
            esnip=esnip*(plus_minus_mV*4);
            esnip=esnip+baseline_mV;
            vsnip=events(e).voltageSnippet;
            hold on; plot(events(e).t_seconds,esnip,'b');  
            hold on; plot(events(e).t_seconds,vsnip,'k');
        end
       
    end
    
    set(gca,'xlim',[-0.5 2]);
    axis tight
    if thisPanel==17
        xlabel('s'); ylabel('mV');
        set(gca,'tickdir','out');
    else
        set(gca,'xtick',[],'ytick',[]); 
    end
    
end







end