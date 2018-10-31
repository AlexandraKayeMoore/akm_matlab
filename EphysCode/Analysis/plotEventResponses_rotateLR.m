function plotEventResponses_rotateLR(filepath,daqfilename,eventsfilename,xlims,baseline_mV,plus_minus_mV)
%% plotEventResponses_rotateLR(filepath,daqfilename,eventsfilename,xlims,baseline_mV,plus_minus_mV)
% 10/23/18
% Example arguments --
%   filepath: 'D:\data_main\090318_001'
%   daqfilename: 'daqout_090318_001_001.mat'
%   eventsfilename: 'events_090318_001_001.mat'
%   xlims: [-1 8] 
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

figure;

%% Title plot

subplot(length(eventNames)+1,1,1);
set(gca,'position',[0.050 0.872 0.910 0.120]);
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

%% Event plots

for thisEvent=1:length(eventNames) % For each unique event...
    
    subplot(length(eventNames)+1,1,thisEvent+1);
    repCount=1;
    yoffset=0;
    
    for e=1:length(events)
        if strcmp(eventNames(thisEvent),events(e).name)
  
 
            [~,plotSamples(1)]=find(events(e).t_seconds==xlims(1));
            [~,plotSamples(2)]=find(events(e).t_seconds==xlims(2));
            plotSamples=plotSamples(1):1:plotSamples(2);

            t_s=events(e).t_seconds(plotSamples);
            
            % plot event 
            etrace=events(e).eventSnippet(plotSamples);
            eON=t_s(find(etrace>0));
            hold on; line([eON(1) eON(end)],(baseline_mV+yoffset)*[1 1],'linewidth',6,'color',[1 .92 .48]);
            
            % plot response
            vtrace=events(e).voltageSnippet(plotSamples)+yoffset;
            hold on; plot(t_s,vtrace','k');

            % mark baseline voltage
            hold on; line([t_s(1) t_s(end)],(baseline_mV+yoffset)*[1 1],'color',rgb('darkslateblue'));
            % Mark 3 mV above baseline_mV
            hold on; line([t_s(1) t_s(end)],(baseline_mV+yoffset+plus_minus_mV)*[1 1],'color',rgb('darkslateblue'),'linestyle',':');
            % Mark 3 mV below baseline_mV
            hold on; line([t_s(1) t_s(end)],(baseline_mV+yoffset-plus_minus_mV)*[1 1],'color',rgb('darkslateblue'),'linestyle',':');
            
            yoffset=yoffset+range(vtrace)+5;
            repCount=repCount+1;

        end
    end
    
    axis tight;
    yl=get(gca,'ylim');
    xl=get(gca,'xlim');
    set(gca,'ylim',yl+[-plus_minus_mV plus_minus_mV]);
    set(gca,'ytick',[],'ycolor',[1 1 1]);
    set(gcf,'color',[1 1 1]);
    t=title(eventNames(thisEvent),'interpreter','none','fontweight','normal','fontsize',8);
    set(gca,'fontsize',8);
    
    if thisEvent==1;
        set(gca,'position',[0.071 0.494 0.865 0.324]);
    elseif thisEvent==2;
        set(gca,'position',[0.071 0.085 0.865 0.324]);
        xlabel('time (s)');
    end
    

end





end