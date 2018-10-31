function run_closed_loop()

dataDir='C:\Users\amoore\AKM\Data\011118_001'

global fileID laserStatus outputData ...
    pxRegion movementThreshold opticFlowObj

pxRegion={[100 500] [100 500]};
movementThreshold=1e4;

detectMotionPeriod=0.2; % seconds
cameraTriggerRate=20; % triggers/second
sampRate=10e3; % samples/second
laserOutput=3; % mW
V_per_mW=5/15; % +5V command => maximum output of 15 mW

cd('C:\tmp\')
if ~isempty(dir('C:\tmp\*txt')); cd('C:\tmp\'); keyboard; end % Files found in temporary directory

dbstop if error

%% Set up NI object & listener

s=daq.createSession('ni');
s.Rate=sampRate;
addAnalogOutputChannel(s,'Dev1',1,'Voltage'); % dac1out --> IR laser
addDigitalChannel(s,'Dev1','port0/line2', 'OutputOnly'); % dio1 --> flea3

% Set up output traces 

[laserOFF,laserON,cameraTriggers]=deal(repmat(0,detectMotionPeriod*sampRate,1));
laserON(:)=laserOutput*V_per_mW;
cam_trigger_interval=sampRate*(1/cameraTriggerRate); 
cameraTriggers(10:cam_trigger_interval:end)=1;
outputData.laserON=[laserON cameraTriggers];
outputData.laserOFF=[laserOFF cameraTriggers];
queueOutputData(s,outputData.laserOFF);

s.NotifyWhenScansQueuedBelow=detectMotionPeriod*sampRate;
L1=addlistener(s,'DataRequired',@addMoreData); 
type('addMoreData.m')
s.IsContinuous=true;

%% Start process 
x=nan;
while isnan(x)
    x=input('\n\n   Ready. Hit any key to start the session. ','s');
end

% Make 'stop figure'
stopFigure=figure(1);
text(0,0,'Close figure to finish','horizontalalignment','center','fontangle','italic');
set(gca,'xlim',[-1 1],'ylim',[-1 1]);
axis off; 
set(gcf,'color',[1 0 0],'position',[2233 1260 257 54]);
fprintf('\n   Starting session... \n   To finish & save, close figure at right. \n\n') 

cd('C:\tmp\');
files=dir('fc2_*');
nextFrame=imread(files(end).name,'PixelRegion',pxRegion);
opticFlowObj=opticalFlowFarneback;
estimateFlow(opticFlowObj,nextFrame);
laserStatus=0;
fileID=fopen('C:\tmp\tiffDataFile.txt','w');

% Run until the first figure is closed
s.startBackground();
uiwait(stopFigure); 
s.stop();

%% Clean up & save

delete(L1);
fclose(fileID);
fprintf('\n   -- session closed --   \n\n');




% Get next file number
existingFiles=dir('*18*');
if isempty(existingFiles);
    nextFileNum=1;
else
    nextFileNum=length(existingFiles)+1;
end
mkdir([dataDir '\' num2str(nextFileNum)]);
newLocation=[dataDir '\' num2str(nextFileNum)];

cd('C:\tmp')
imFiles=dir('*tif*');
for f=1:length(imFiles);
    movefile(imFiles(f).name,newLocation);
end

fprintf('\n\n Image files moved to %s\n\n',...
    newLocation)

cd(newLocation)







end










