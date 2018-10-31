function plotOdorReps_Vm(dataDir,daqFiles,stimString,baselineV)
% Inputs --
%   dataDir = main data directory
%   daqFiles = structure with file names, e.g. cd(dataDir); daqFiles=dir('daqout*.mat'); 
%   stimString = stimulus description, e.g. 'PENAC, 5E-4'
%   baselineV = for scale on y axis
% Example -- 
%   plotOdorReps_Vm(dataDir,daqFiles(68:72),'PENAC, 5E-4')

tMax=[];
for f=1:length(daqFiles);
    [t_s,voltageTrace,scaledOdorTrace]=plotScaledData(dataDir,daqFiles(f).name,[]);
    traces(f).t_s=t_s;
    traces(f).voltage=voltageTrace;
    traces(f).odor=scaledOdorTrace;
    tMax=max([tMax t_s(end)]);
end
close all

figure
yoffset=0;
for f=length(daqFiles):-1:1;
    thisVTrace=traces(f).voltage+yoffset;
    [~,thisOdor]=find(traces(f).odor>0.5);
    hold on; line([traces(f).t_s(thisOdor(1)) traces(f).t_s(thisOdor(end))],...
        (baselineV+yoffset)*[1 1],'linewidth',10,'color',[1 .92 .48])
    % Mark baseline
    hold on; line([0 tMax],(baselineV+yoffset)*[1 1],'color',rgb('darkslateblue'));
    % Mark 5 mV above baselineV
    hold on; line([0 tMax],(baselineV+yoffset+5)*[1 1],'color',rgb('darkslateblue'),'linestyle',':');
    % Plot trace
    hold on; plot(traces(f).t_s,thisVTrace,'color','k');
    yoffset=yoffset+range(thisVTrace)+5;
    
end
axis tight
yl=get(gca,'ylim');
xl=get(gca,'xlim');
set(gca,'ylim',yl+[-8 8])
text(traces(f).t_s(thisOdor(1))-1,baselineV-5,sprintf('%.0f mV',baselineV),'color',rgb('darkslateblue'));
  


lastFile=strsplit(daqFiles(end).name,{'_','.mat'},'CollapseDelimiters',false);
lastFile=lastFile{end-1};
figtitle=[strrep(daqFiles(1).name,'.mat','') '-' lastFile ', ' stimString]
title(figtitle,'interpreter','none','fontweight','normal','fontangle','italic')
xlabel('time (s)')
set(gca,'ytick',[],'ycolor',[1 1 1])
set(gcf,'color',[1 1 1])


if 1
set(gca,'xlim',[4 10]); set(gcf,'position',[110 530 1150 400])

figHandles=findobj('Type','figure'); save2pdf([figtitle '.pdf'],gcf,300);

end

end