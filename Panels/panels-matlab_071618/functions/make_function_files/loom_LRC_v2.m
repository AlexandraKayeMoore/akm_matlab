%% Object expanding from L/R/C - "version 2"
% Create position functions for use with patterns 035 (bright object expanding) 
% and 028 (dark object expanding). 
%

% isi = 5 seconds
% 3 reps @ each location:	
% expansion from center -- xpos: 2-70, ypos: 6
% expansion from left -- xpos: 2-70, ypos: 3
% expansion from right -- xpos: 2-70, ypos: 9
% frames_per_pos=1 (animation played @ 50 fps) 
% 
% At 50 fps, the edge of the expanding object is moving 
% ~180 dps, which is comparable to the speed of the looming
% stimuli used in De Vries & Clandinin (2012) --
% https://www.cell.com/current-biology/fulltext/S0960-9822(12)00008-5#secd72266970e376



clear all; close all; clc
dbstop if error






fDescription='loom_LRC_50fps'; 
xfuncNum='041';
yfuncNum='042';
xfilename=['position_function_' xfuncNum '_' fDescription '_Xpos.mat'];
yfilename=['position_function_' yfuncNum '_' fDescription '_Ypos.mat'];
fInfo_filename=['fInfo_' xfuncNum '_' yfuncNum '.mat']; 

isiDuration_s=5;
reps_per_stim=3;
frames_per_pos=1; 



%% Make position functions

% Fixed params
numOfPanelsAcross=9;  
numOfPanelsVertically=2;
LEDdotsPerPanel=8; % this shouldn't change!  LEDs are always 8 dots in x and y. 
LEDdotsAcross=numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically=numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
PIXELS_PER_DEGREE=96/360; % If we had a full circle with 12 panels instead of 9, we would have 12*8=96 LEDs
PANELS_FRAME_RATE=50; % 50 Hz; new frame every 20 ms

% This is the blank screen that we'll show during the ISI period
ISI_x_val=1;  
ISI_y_val=1; 
frames_per_isi=isiDuration_s*PANELS_FRAME_RATE; % # of blank frames to add between events 

%% Start by ramping through blank dimensions in x and y 
% Blank dims:
% x=1, y=1:16
% x=1:72, y=1
% Note that this is *not* logged as an 'event'

xpositionFunction=[];
ypositionFunction=[];

% Start out at x=1, y=1 for 25 frames (0.5 sec)
xpositionFunction=[xpositionFunction repmat(1,1,25)]; % repmat(current_xpos,1,numFrames)
ypositionFunction=[ypositionFunction repmat(1,1,25)]; % repmat(current_ypos,1,numFrames)




% Ramp in x 
%  1. step from 1-72, with 2 frames per pos (144 frames)
%  2. reset to 1 (1 frame)
%  3. wait at 1 while y is ramping (32 frames)
xramp=[];
xramp=[xramp sort([1:72 1:72])]; 
xramp=[xramp 1];
xramp=[xramp repmat(1,1,32)];

% Ramp in y
%  1. wait at 1 while x is ramping (144 frames)
%  2. stay at 1 while x resets (1 frame)
%  3. step from 1-16, with 2 frames per pos (32 frames)
yramp=[];
yramp=[yramp repmat(1,1,144)];
yramp=[yramp 1];
yramp=[yramp sort([1:16 1:16])]; 

% Add ramps to position functions
xpositionFunction=[xpositionFunction xramp];
ypositionFunction=[ypositionFunction yramp];




% Step back down to 1,1 (ISI pos) for 25 frames before starting the
% first event
xpositionFunction=[xpositionFunction repmat(1,1,25)];  
ypositionFunction=[ypositionFunction repmat(1,1,25)];  


%% Create frames for the ISI period 

isi_frames_X=repmat(ISI_x_val,1,frames_per_isi);
isi_frames_Y=repmat(ISI_y_val,1,frames_per_isi);

%% Create scan events 

x_locations=[2:70]; % looming animation
y_locations=[3,6,9]; % 3=left, 6=center, 9=right
event_names={'loom_L','loom_C','loom_R'};

events=struct();
i=1;

for yp=1:length(y_locations)
    for r=1:reps_per_stim
        events(i).name=event_names{yp};
        events(i).xposvalues=x_locations;
        events(i).yposvalues=repmat(y_locations(yp),1,length(x_locations));
        i=i+1;
    end
end


%% Add events and ISI periods to the frame sequence 

shuffledOrder=randperm(length(events)); % Pseudo-shuffle the order of events

for e=shuffledOrder 
    
    if length(events(e).xposvalues) ~= length(events(e).yposvalues); 
        keyboard % x and y arrays should be the same length!
    else
        eventLength=length(events(e).xposvalues);
    end
    
    % For each x,y position in this event...
    for p=1:eventLength 
        
        current_xpos=events(e).xposvalues(p);
        current_ypos=events(e).yposvalues(p);
        
        % Duplicate x/y values for the appropriate number of frames
        % and add them to the sequence
        xpositionFunction=[xpositionFunction repmat(current_xpos,1,frames_per_pos)];
        ypositionFunction=[ypositionFunction repmat(current_ypos,1,frames_per_pos)];
   
    end
    
    % Add ISI period before moving on the next event
    xpositionFunction=[xpositionFunction isi_frames_X];
    ypositionFunction=[ypositionFunction isi_frames_Y];
    
end

func_X=xpositionFunction;
func_Y=ypositionFunction;

if length(func_X) ~= length(func_Y); % Make sure the functions are same length
        keyboard 
end

%% Save functions to be loaded onto the SD card

% Report the duration of the whole file and # of events
totalDur_frames=length(func_X);
totalDur_s=totalDur_frames*(1/PANELS_FRAME_RATE);
fprintf('\n  %.0f events; duration = %.1f seconds, %.0f frames\n\n',...
    length(events),totalDur_s,totalDur_frames)


if 0 % visual check
    figure;
    hold on; plot(xpositionFunction,'r');
    hold on; plot(ypositionFunction,'b');
    axis tight
    set(gca,'ytick',0:72)
    ylim([0 72])
    grid on
end


cd('C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\functions')
func=func_X;
save(xfilename,'func'); % variable must be named 'func'
func=func_Y;
save(yfilename,'func'); % variable must be named 'func'

%% Save "fInfo" 
% fInfo: a separate matlab structure with info about the functions we've just created

fInfo=struct();
fInfo.fDescription=fDescription;
fInfo.xfilename=xfilename;
fInfo.yfilename=yfilename;
fInfo.shuffledEvents=events(shuffledOrder); % events, in the order in which they occur
fInfo.frames_per_pos=frames_per_pos;
fInfo.frames_per_isi=frames_per_isi;
fInfo.totalDur_frames=totalDur_frames;
fInfo.totalDur_s=totalDur_s;
fInfo.xpositionFunction=xpositionFunction;
fInfo.ypositionFunction=ypositionFunction;

cd('C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\functions\make_function_files');
save(fInfo_filename,'fInfo');
fprintf('\n\nDone!\n%s\n%s\n',xfilename,yfilename)



