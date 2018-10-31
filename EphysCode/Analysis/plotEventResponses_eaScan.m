function plotEventResponses_eaScan(filepath,daqfilename,eventsfilename,baseline_mV,plus_minus_mV)
%% plotEventResponses_eaScan(filepath,daqfilename,eventsfilename,baseline_mV,plus_minus_mV)
% 10/23/18
% Example arguments --
%   filepath: 'D:\data_main\090318_001'
%   daqfilename: 'daqout_090318_001_001.mat'
%   eventsfilename: 'events_090318_001_001.mat'
%   baseline_mV: -35
%   plus_minus_mV: 3


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



%% * Plot elevation scans *

% Load color code 
load('C:\Users\amoore\akm_matlab\EphysCode\Analysis\azimuth_CC_72.mat')

% Determine y offset values 
yoff=0;
yOffsets=zeros(1,72);
for a=avalues;
    yoff=yoff+(plus_minus_mV*3.5);
    yOffsets(a)=yoff;
end

figure; 
set(gcf,'position',[420 60 565 710]);


if 1 % downward scan 


eDown=axes();
set(gca,'position',[0.072 0.083 0.41 0.83]);

for a=sort(avalues)
    for e=1:length(events)
        az_position=unique(events(e).xposvalues);
        if strcmp('elevation_scan_UD',events(e).name) && az_position==a
            
            % Determine xlimits for trace
            x_min=8e3; % samples to plot before event starts
            x_max=8e3; % samples to plot after event ends
            [temp,~]=find(events(e).eventSnippet>0.5);
            plotSamples(1)=temp(2)-x_min; 
            plotSamples(2)=temp(end)+x_max; 
            plotSamples=plotSamples(1):1:plotSamples(2);
            t_s=events(e).t_seconds(plotSamples);
            
            % Plot event
            etrace=events(e).eventSnippet(plotSamples);
            eON=t_s(find(etrace>0.5));
            hold on; line([eON(1) eON(end)],(baseline_mV+yOffsets(a))*[1 1],...
                'linewidth',10,'color',[1 .96 .52]);
            
            % mark baseline voltage
            hold on; line([t_s(1) t_s(end)],(baseline_mV+yOffsets(a))*[1 1],'color','k');
            % Mark x mV above & below baseline_mV
            hold on; line([t_s(1) t_s(end)],(baseline_mV+yOffsets(a)+plus_minus_mV)*[1 1],'color','k','linestyle',':');
            hold on; line([t_s(1) t_s(end)],(baseline_mV+yOffsets(a)-plus_minus_mV)*[1 1],'color','k','linestyle',':');

                       
            % plot trace
            vtrace=events(e).voltageSnippet(plotSamples)+yOffsets(a);
            hold on; plot(t_s,vtrace,...
                'color',[azimuthColorCode(a).RGB]);
        end
    end
end

axis tight
yl=get(gca,'ylim');
set(gca,'ylim',yl+(plus_minus_mV*[-1 0.5]),'fontsize',10);
title('scan_down','interpreter','none','fontweight','normal','fontsize',10);
xlabel('time (s)');
set(gca,'ytick',[],'ycolor',[1 1 1]);

end


if 1 % upward scan

eUp=axes();
set(gca,'position',[0.53 0.083 0.41 0.83]);

for a=sort(avalues)
    for e=1:length(events)
        az_position=unique(events(e).xposvalues);
        if strcmp('elevation_scan_DU',events(e).name) && az_position==a
            
            % Determine xlimits for trace
            x_min=8e3; % samples to plot before event starts
            x_max=8e3; % samples to plot after event ends
            [temp,~]=find(events(e).eventSnippet>0.5);
            plotSamples(1)=temp(2)-x_min; 
            plotSamples(2)=temp(end)+x_max; 
            plotSamples=plotSamples(1):1:plotSamples(2);
            t_s=events(e).t_seconds(plotSamples);
            
            % Plot event
            etrace=events(e).eventSnippet(plotSamples);
            eON=t_s(find(etrace>0.5));
            hold on; line([eON(1) eON(end)],(baseline_mV+yOffsets(a))*[1 1],...
                'linewidth',10,'color',[1 .96 .52]);
            
            % mark baseline voltage
            hold on; line([t_s(1) t_s(end)],(baseline_mV+yOffsets(a))*[1 1],'color','k');
            % Mark x mV above & below baseline_mV
            hold on; line([t_s(1) t_s(end)],(baseline_mV+yOffsets(a)+plus_minus_mV)*[1 1],'color','k','linestyle',':');
            hold on; line([t_s(1) t_s(end)],(baseline_mV+yOffsets(a)-plus_minus_mV)*[1 1],'color','k','linestyle',':');

            % plot trace
            vtrace=events(e).voltageSnippet(plotSamples)+yOffsets(a);
            hold on; plot(t_s,vtrace,...
                'color',[azimuthColorCode(a).RGB]);
        end
    end
end

axis tight
yl=get(gca,'ylim');
set(gca,'ylim',yl+(plus_minus_mV*[-1 0.5]),'fontsize',10);
title('scan_up','interpreter','none','fontweight','normal','fontsize',10);
xlabel('time (s)');
set(gca,'ytick',[],'ycolor',[1 1 1]);

end

% Title 
ftext=[strrep(daqfilename,'.mat','') ' - scan azimuth'];
fth=text(0.5,4,ftext,'interpreter','none','HorizontalAlignment','center','fontweight','bold');
set(fth,'position',[-0.846 158.80 0],'fontsize',10);
set(gcf,'color',[1 1 1]);









%% *Plot azimuth scans*

figure;

for eIndex=1:length(evalues) % For each elevation...

    subplot(length(evalues)+1,1,eIndex+1);
    title(sprintf('azimuth_scan, y=%.0f (RL=b, LR=k)',evalues(eIndex)),'interpreter','none','fontweight','normal','fontsize',6);
    yoffset=0;
    
    for e=1:length(events)
        
        % Find events of the right type and position...
        if strcmp('azimuth_scan_RL',events(e).name) || strcmp('azimuth_scan_LR',events(e).name)
            if unique(events(e).yposvalues)==evalues(eIndex)
                
                % Determine xlimits for this type of event type:
                % 1 second before it starts to 1 second after it ends
                [temp,~]=find(events(e).eventSnippet>0.5);
                plotSamples(1)=temp(2)-10e3; % 1s before event starts
                plotSamples(2)=temp(end)+10e3; % 1s after event ends
                plotSamples=plotSamples(1):1:plotSamples(2);
                
                t_s=events(e).t_seconds(plotSamples);
                
                % plot event
                etrace=events(e).eventSnippet(plotSamples);
                eON=t_s(find(etrace>0.5));
                hold on; line([eON(1) eON(end)],(baseline_mV+yoffset)*[1 1],'linewidth',10,'color',[1 .92 .48]);
                
                
                % mark baseline voltage
                hold on; line([t_s(1) t_s(end)],(baseline_mV+yoffset)*[1 1],'color','k');
                % Mark 3 mV above baseline_mV
                hold on; line([t_s(1) t_s(end)],(baseline_mV+yoffset+plus_minus_mV)*[1 1],'color','k','linestyle',':');
                % Mark 3 mV below baseline_mV
                hold on; line([t_s(1) t_s(end)],(baseline_mV+yoffset-plus_minus_mV)*[1 1],'color','k','linestyle',':');
                
                
                % plot response
                vtrace=events(e).voltageSnippet(plotSamples)+yoffset;
                if strcmp('azimuth_scan_RL',events(e).name)
                   hold on; h1=plot(t_s,vtrace','b');
                else
                   hold on; h2=plot(t_s,vtrace','k');
                end
                
            end
        end
    end
    
    try; uistack(h1,'top'); catch; end;
    try; uistack(h2,'top'); catch; end;
    
    if eIndex==length(evalues)
        xlabel('time (s)');
    end
    axis tight;
    yl=get(gca,'ylim');
    xl=get(gca,'xlim');
    set(gca,'ylim',yl+(plus_minus_mV*[-1 1]));
    set(gca,'ytick',[],'ycolor',[1 1 1]);
    set(gcf,'color',[1 1 1]);
    set(gca,'fontsize',8);

end





% Title plot
subplot(length(evalues)+1,1,1);
set(gca,'position',[0.135 0.845 0.775 0.135]);
ylim([0.5 4.5]);
temp=load([functions_dir '\' fInfoFilename]);
ftext=[strrep(daqfilename,'.mat','') ' ' sprintf('(%.0f+/-%.0f mV)',baseline_mV,plus_minus_mV)];
ptext=['p' strrep(patternFile.name(2:end),'.mat','')];
xtext=strrep(temp.fInfo.xfilename,'.mat','');
ytext=strrep(temp.fInfo.yfilename,'.mat','');
hold on; text(0.5,4,ftext,'interpreter','none','HorizontalAlignment','center','fontsize',9,'fontweight','bold');
hold on; text(0.5,3,ptext,'interpreter','none','HorizontalAlignment','center','fontsize',8,'fontangle','italic');
hold on; text(0.5,2,xtext,'interpreter','none','HorizontalAlignment','center','fontsize',8,'fontangle','italic');
hold on; text(0.5,1,ytext,'interpreter','none','HorizontalAlignment','center','fontsize',8,'fontangle','italic');
axis off









end