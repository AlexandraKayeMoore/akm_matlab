
clear all
close all
clc

AxPos(1,:)=[30 749 1246 142];
AxPos(2,:)=[30 519 1246 142];
AxPos(3,:)=[30 288 1246 142];
AxPos(4,:)=[30 59 1246 142];


% Open old figures and move axes
figFiles(1).name='020618_003_026.fig';
figFiles(2).name='020618_003_027.fig';
figFiles(3).name='020618_003_024.fig';
figFiles(4).name='020618_003_025.fig';


for fNum=1:4
    openfig(figFiles(fNum).name);
end


% New figure
figurePos=[33 355 1295 944];
groupFig=figure;
set(groupFig,'position',figurePos,'color',[1 1 1]);



for fNum=1:4
    figure(fNum)
    oldAx=get(gcf,'children');
    newAx=copyobj(oldAx,groupFig);
    set(newAx,'Units','Pixels','position',AxPos(fNum,:));
end

