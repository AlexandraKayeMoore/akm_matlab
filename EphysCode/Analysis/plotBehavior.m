
function plotBehavior(vidDir)
% akm 2/7/18

dbstop if error

trialStr=vidDir(strfind(vidDir,'vidout'):end);
dataDir=strrep(vidDir,['\' trialStr],''); % location of the corresponding daqout file
savePath=vidDir;
cd(vidDir);

%% Load data

% Load daq file
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

[~,frameTimes_samples]=find(settings.cameraTrigOut>0.5);
    


%% Generate figure

figPos=[15 1103 1293 242];
axPos=[21 70 1246 142];
h=figure;
set(h,'Position',figPos,'color',[1 1 1]);

% Plot optic flow & stimuli
axes('Units','Pixels', 'Position',axPos);
stim_t=[1:length(stimulus.A_valve_command)]/settings.sampRate;
hold on; area(stim_t,stimulus.A_valve_command,'facecolor',[255 234 116]/255,'edgecolor','none');
hold on; area(stim_t,stimulus.B_valve_command,'facecolor',rgb('lightblue'),'edgecolor','none');
hold on; area(stim_t,rescale(stimulus.laser_command),'facecolor',rgb('orangered'),'edgecolor','none','facealpha',0.25);
flow_t=frameTimes_samples/settings.sampRate;
hold on; plot(flow_t,flowMag,'color','k','linewidth',1);


axis tight
box off
xlabel('time (s)');
set(gca,'fontsize',11,'tickdir','out','ticklength',[0.008 0.008],'ylim',[-.01 1.05],...
    'ytick',[],'xtick',[0:5:stim_t(end)],'ycolor',[1 1 1]);
title(strrep(trialStr,'vidout_',''),...
    'interpreter','none','fontweight','normal');
    





cd(dataDir)
figName=strrep(daqFileName,'.mat','.fig');
figName=strrep(figName,'daqout_','');
savefig(h,figName);
close

end
