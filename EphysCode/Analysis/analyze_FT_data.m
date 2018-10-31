function analyze_FT_data(dataDir,csvFile,FR,stimulus,cameraTriggers)
% Input:
%   dataDir = 'C:\Users\A. K. Moore\Desktop\Lab\FT_Output_030918_002\005';
%   csvFile = 'vidout_030918_002_005.dat';
%   FR = 80
%   stimulus array & cameraTriggers = from daqout file

dbstop if error


 %% Load data 
 
cd(dataDir);
M=csvread(csvFile);

if 0 
    
    % 1: Frame counter
    %         Corresponding video frame (starts at #1).
    % 5: Delta rotation score
    %         Error score associated with rotation estimate.
    % 15: Integrated x position (lab)
    % 16: Integrated y position (lab)
    %         Integrated x/y position (radians) in laboratory coordinates. Scale by
    %         sphere radius for metric position. Incorporates animal's changes in
    %         heading.
    % 17: Integrated animal heading (lab)
    %         Integrated heading direction (radians) of the animal in laboratory
    %         coordinates. This is the absolute direction the animal would be facing if it
    %         wasn't tethered.
    % 18: Animal movement direction (lab)
    %         Instantaneous running direction (radians) of the animal in laboratory
    %         coordinates. This is the direction the animal is moving in the lab frame
    %         (add to heading to get instantaneous movement direction in world).
    % 19: Animal movement speed
    %         Instantaneous running speed (radians/frame) of the animal. Scale by
    %         sphere radius for metric speed.
    % 20: Integrated forward motion
    % 21: Integrated side motion
    %         Integrated x/y position (radians) of the sphere in laboratory coordinates
    %         neglecting heading – i.e. equivalent to the accumulated vertical
    %         component of the output from two optic mice sensors placed beside and
    %         behind the animal.
    % 23: Sequence number
    %         Frame number in current tracking sequence. Usually corresponds directly
    %         to frame counter but can reset to 1 if tracking is reset (see parameter
    %         max_bad_frames in input configuration file).
    
end % explination of csv headings



%% Speed & heading direction 

% *Inst. running speed*
iSpeed=M(:,19);
iSpeed(1)=iSpeed(2);
low_pass_cutoff=20; % Hz
[b,a]=butter(1,low_pass_cutoff/(FR/2), 'low');
iSpeed=filtfilt(b,a,iSpeed);
iSpeed=iSpeed*0.3501*FR; % convert to cm/s: (rad/frame)*(frames/s)*0.3501
% distance in cm = fraction of full rotation * circumference of ball 
% distance = radians/2pi * 2.2 cm = radians * 0.3501

% *Integrated heading direction*
intHeading=M(:,17);
intHeading(1)=intHeading(2);
low_pass_cutoff=20; % Hz
[b,a]=butter(1,low_pass_cutoff/(FR/2), 'low');
intHeading=filtfilt(b,a,intHeading);
intHeading=intHeading*57.2958; % convert radians to degrees

% Frames to seconds
t=1:length(M);
t=t/FR;

if ~isempty(stimulus)
    dataSampRate=length(stimulus.A_valve_command)/stimulus.stimDur_s;
    odorTrace=resample(stimulus.A_valve_command,length(M),length(stimulus.A_valve_command));
    odorTrace(odorTrace>0)=1;
    odorTrace(odorTrace<=0)=0;
    % For movement direction, set the origin to be the direction of movement @ odor onset
    [~,odorStart]=find(odorTrace>0);
    odorStart=odorStart(1);
else
    odorTrace=zeros(1,length(M));
end

figure
subplot(2,1,1);
area(t,(odorTrace*range(iSpeed))+min(iSpeed),min(iSpeed),'edgecolor','none','facecolor',[255 233 132]/255);
hold on; plot(t,iSpeed);
axis tight; box off
set(gca,'tickdir','out')
title([csvFile sprintf(' (med. %.2f cm/s)',median(iSpeed))],'interpreter','none',...
    'fontweight','normal');
ylabel('running speed (cm/s)')
subplot(2,1,2);
area(t,(odorTrace*range(intHeading))+min(intHeading),min(intHeading),'edgecolor','none','facecolor',[255 233 132]/255);
hold on; plot(t,intHeading);
axis tight; box off
ylabel('Heading direction (\circ)')
xlabel('seconds')
ylim([-1 361])
set(gca,'tickdir','out','ytick',[0:90:360])
set(gcf,'color',[1 1 1])







%% 2D location vs. time
if 1
    
xposition=M(:,15);
yposition=M(:,16);
elapsedTime_s=[1:size(M,1)]/FR;

% Low pass filter the trajectory for a cleaner plot
low_pass_cutoff=20; % Hz
[b,a]=butter(1,low_pass_cutoff/(FR/2), 'low');
xposition=filtfilt(b,a,xposition);
yposition=filtfilt(b,a,yposition);

% Convert to cm
xposition=xposition*0.2992; % see note in previous section
yposition=yposition*0.2992; % see note in previous section

if ~isempty(stimulus)
    [~,allFrames]=find(cameraTriggers>0.1);
    [~,odorFrames]=find([stimulus.A_valve_command+cameraTriggers]>1.1);
    [~,odorFrameNumbers,~]=intersect(allFrames,odorFrames);
    preFrameNumbers=1:(odorFrameNumbers(1)-1);
    postFrameNumbers=(odorFrameNumbers(end)+1):length(M);
else
    preFrameNumbers=1:length(M);
    odorFrameNumbers=[];
    postFrameNumbers=[];
end

figure
set(gcf,'color',[1 1 1])
pointsize=25;
hold on; scatter(xposition,yposition,pointsize,elapsedTime_s,'filled');
hold on; plot(xposition,yposition,'color',[.25 .25 .25])
if ~isempty(stimulus)
    hold on; plot(xposition([odorFrameNumbers(1) odorFrameNumbers(end)]),...
    yposition([odorFrameNumbers(1) odorFrameNumbers(end)]),'r.','markersize',30)
end
grid on; axis tight; axis equal
xt=get(gca,'xtick');
yt=get(gca,'ytick');
tickspacing=max([(xt(2)-xt(1)) (yt(2)-yt(1))]);
set(gca,'tickdir','out','xtick',[xt(1):tickspacing:xt(end)],'ytick',[yt(1):tickspacing:yt(end)])
t=title(csvFile,'interpreter','none',...
    'fontweight','normal');
xlabel('x position (cm)')
ylabel('y position (cm)')
c=colorbar;
c.Label.String='time (s)';
set(c,'tickdirection','out')

end

end










