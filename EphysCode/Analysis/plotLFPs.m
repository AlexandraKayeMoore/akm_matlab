function plotLFPs(filepath,daqfiles2plot)
% Quick plotting function for daqout files. akm, 6/21/17
% filepath = path to main data directory
% daqfiles2plot = file info with .name field, e.g. --
% **example** 
% clear all; close all; clc
% dataDir='C:\Users\amoore\AKM\Data\121917_001';
% i=1;
% daqfiles2plot(i).name='daqout_121917_001_011.mat'; i=i+1;
% daqfiles2plot(i).name='daqout_121917_001_012.mat'; i=i+1;
% daqfiles2plot(i).name='daqout_121917_001_013.mat'; i=i+1;
% daqfiles2plot(i).name='daqout_121917_001_014.mat'; 
% plotLFPs(dataDir,daqfiles2plot);


figure;
dbstop if error;
cd(filepath);
yoffset=0.1;

for f=1:length(daqfiles2plot)
    
    in=load(daqfiles2plot(f).name);
    fprintf('\n\nPlotting %s',daqfiles2plot(f).name)
    
    % Check for laser pulses --
    laserTrace=[];
    try strcmp(in.stimulus.type,'laser_pulses')
        laserTrace=in.stimulus.laserTrace;
        fprintf('\n  Laser pulses found.\n')
    catch
        fprintf('\n  No laser pulses found.\n')
    end
    
    % Check for i-clamp commands --
    Icmd=[];
    if range(in.stimulus.iclamp_command)>1;
        try
            Icmd=in.stimulus.stimTrace;
        catch
            Icmd=in.stimulus.currentTrace;
        end
    else
        fprintf('\n  No current steps found.\n')
    end
    
    % Check for optic flow data --
    vidfolder=strrep(daqfiles2plot(f).name,'daqout','vidout');
    vidfolder=strrep(vidfolder,'.mat','');
    fdFile=[];
    try
        % Load flow data file, if it exists
        cd([filepath '\' vidfolder])
        fdFile=dir('flowData*');
        fdFile=load(fdFile(1).name);
        fprintf('\n  flowData file found.\n')
    catch
        fprintf('\n  No flowData found.\n')
    end
    
    
    %% Process & plot
    
    t_s=[1:length(in.data.current)]/in.settings.sampRate;
    
    % Low pass filter
    low_pass_cutoff=30; % Hz
    fprintf('\nLow pass filtering at %d Hz', low_pass_cutoff);
    [b,a]=butter(1,low_pass_cutoff/(in.settings.sampRate/2), 'low');
    filteredtrace=filtfilt(b,a,in.data.voltage );
    
    % High pass filter
    high_pass_cutoff=0.5; % Hz
    fprintf('\nHigh pass filtering at %.1f Hz\n', high_pass_cutoff);
    [b,a]=butter(1,high_pass_cutoff/(in.settings.sampRate/2), 'high');
    filteredtrace=filtfilt(b,a,filteredtrace);
    
    % Plot the stimulus first
    if f==1
        %hold on; plot(t_s,in.stimulus.pinch_valve_command,'k:','linewidth',0.5);
        hold on; area(t_s,in.stimulus.A_valve_command,'facecolor',rgb('lightgreen'),'edgecolor','none','facealpha',0.5);
    end
    
    hold on; plot(t_s,yoffset+filteredtrace,'color','k');
    linetxt=['      ' strrep(daqfiles2plot(f).name,'.mat','')];
    [~,labelXpos]=find(in.stimulus.A_valve_command>0.5);
    labelXpos=labelXpos(end);
    text(t_s(labelXpos),yoffset+min(filteredtrace),linetxt,'interpreter','none',...
        'fontsize',8,'fontangle','italic')
    yoffset=yoffset+0.15;
    
end

hold on;line([2.5 2.5],[0.05 0.16],'linewidth',2,'color','k')
hold on;line([2.5 3.5],[0.05 0.05],'linewidth',2,'color','k')
hold on; text(2.7,0.14,'0.1 mV')
hold on; text(2.7,0.03,'1 s')
axis tight
set(gca,'tickdir','out')
xlabel('ms')
ylabel('mV')
title('');
set(gcf,'color',[1 1 1]);



end

