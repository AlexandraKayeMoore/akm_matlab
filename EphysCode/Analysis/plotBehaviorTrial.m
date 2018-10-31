function axH=plotBehaviorTrial(dataDir,daqfilename,FR)
% --Input--
% dataDir: main data directory
% daqfilename: name of daqout file & corresponding 'vidout' folder
% FR: video frame rate in Hz
% --Output--
% figH: handle to figure




% Load data file

cd(dataDir);
load(daqfilename);
t_s=0:(1/settings.sampRate):stimulus.stimDur_s;
t_s(1)=[];

% Load optic flow trace 

vidfolder=strrep(daqfilename,'daqout','vidout');
vidfolder=strrep(vidfolder,'.mat','');
cd(vidfolder);
flowdatafile=dir('flowData*');
load(flowdatafile(1).name);

[~,frameTriggers]=find(settings.cameraTrigOut>0.5);
if length(frameTriggers)~=length(flowMag); keyboard; end % Sanity check!
frameTimes_s=frameTriggers/settings.sampRate;


% Plot data
flowMag(1:3)=min(flowMag); % Set the first few OF values to "0" so it'll scale noramlly
flowTrace=rescale(flowMag);
laserTrace=rescale(stimulus.laser_command);
odorOn=stimulus.odor_valve_command;
pinchOpen=stimulus.pinch_valve_command*0.1;

figH=figure;
axH=axes;
hold on; area(t_s,laserTrace>0,'edgecolor','none','facecolor',rgb('firebrick'),'facealpha',0.25,'DisplayName','IR laser');
hold on; area(t_s,odorOn,'edgecolor','none','facecolor',rgb('teal'),'facealpha',0.25,'DisplayName','Odor');
hold on; plot(frameTimes_s,flowTrace,'displayname','Optic flow','linewidth',1,'color',rgb('darkslategray')); 

L=legend('show'); 
set(L,'box','off','fontsize',11);
set(gca,'ytick',[],'xtick',[1:stimulus.stimDur_s],'ycolor','none','tickdir','out','ticklength',[0.005 0.025],'fontsize',11);
xlabel('seconds','fontsize',11);
ylim([-.01 .99])
figTitle=strrep(daqfilename,'daqout_','');
title(figTitle,'interpreter','none','fontweight','normal','fontangle','italic','fontsize',11);
set(figH,'color',[1 1 1],'position',[70 1080 1370 190]);








end