%% Rotate grating R/L

clear all; clc
dbstop if error


% ***** Function-specific parameters *****

fDescription='rotate_vertical_grating_9px_36dps';
xfuncNum='021';
yfuncNum='022';
desiredSpeed_degreesPerSec=36; 
isiDuration_s=4;



%% Standard parameters

xfilename=['position_function_' xfuncNum '_' fDescription '_Xpos.mat'];
yfilename=['position_function_' yfuncNum '_' fDescription '_Ypos.mat'];
fInfo_filename=['fInfo_' xfuncNum '_' yfuncNum '.mat']; 

numOfPanelsAcross=9;  
numOfPanelsVertically=2;
LEDdotsPerPanel=8; % this shouldn't change!  LEDs are always 8 dots in x and y. 
LEDdotsAcross=numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically=numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
PIXELS_PER_DEGREE=96/360; % If we had a full circle with 12 more panels (12*8=96 LEDs)
PANELS_FRAME_RATE=50; % 50 Hz=new frame every 20 ms
xposMin=1; 
xposMax=LEDdotsAcross; % range of potential xpos and ypos values
yposMin=1; 
yposMax=LEDdotsVertically;  

%% Make events

% Ypos is arbitrary and won't change
yFixed=4;

% Make each sweep across the display an 'event'
events=struct();
i=1;

% grating moves L-->R
for reps=1:4
    events(i).name='sweep_R';
    events(i).xposvalues=repmat([1:18],1,4); % shift the grating by 1 full period, four times, to get the appearance of a full sweep
    events(i).yposvalues=repmat(yFixed,1,72);
    i=i+1;
end

% grating moves R-->L
for reps=1:4
    events(i).name='sweep_L';
    events(i).xposvalues=repmat([18:-1:1],1,4);
    events(i).yposvalues=repmat(yFixed,1,72);
    i=i+1;
end



%% Pseudo-shuffle the order of events, then create the frame sequence to send to the panels 

shuffledOrder=randperm(length(events));


% frames_per_pos: number of frames to devote to each (xpos,ypos) value
desiredSpeed_pixelsPerSec=desiredSpeed_degreesPerSec * PIXELS_PER_DEGREE;
frames_per_pos=floor(PANELS_FRAME_RATE/desiredSpeed_pixelsPerSec); % [# frames delivered in 1 second] / [# of positions to traverse in 1 second]

% Number of blank frames to add between events (isi period)
frames_per_isi=isiDuration_s * PANELS_FRAME_RATE;

% Blank screen is xpos=72,ypos=any. We'll use this during the ISI period.
BLANK_DIM_X=72;  
BLANK_DIM_Y=yFixed; 

xpositionFunction=[]; 
ypositionFunction=[];

for e=shuffledOrder % For each event...
    
    eventLength=length(events(e).xposvalues); % (x and y arrays will be the same length)
    
    for p=1:eventLength % For each position in this event...
        
        current_xpos=events(e).xposvalues(p);
        current_ypos=events(e).yposvalues(p);
        
        % Duplicate values for the appropriate number of frames
     
        % Add frames to the position functions
        xpositionFunction=[xpositionFunction repmat(current_xpos,1,frames_per_pos)];
        ypositionFunction=[ypositionFunction repmat(current_ypos,1,frames_per_pos)];
        
    end
    
    % Add ISI frames before starting the next event
    xpositionFunction=[xpositionFunction repmat(BLANK_DIM_X,1,frames_per_isi) ];
    ypositionFunction=[ypositionFunction repmat(BLANK_DIM_Y,1,frames_per_isi) ];
    
end

% Add an initial ISI period before the first stimulus
func_X=[repmat(BLANK_DIM_X,1,frames_per_isi) xpositionFunction];
func_Y=[repmat(BLANK_DIM_Y,1,frames_per_isi) ypositionFunction];

% Note the duration of the whole file in seconds and frames
totalDur_frames=length(func_X);
totalDur_s=totalDur_frames*(1/PANELS_FRAME_RATE);
fprintf('\nFunction duration: %.1f seconds, %.0f frames\n\n',totalDur_s,totalDur_frames)


%% Save functions to load onto the SD card

cd('C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\functions')
func=func_X;
save(xfilename,'func'); % variable must be named 'func'
func=func_Y;
save(yfilename,'func'); % variable must be named 'func'


%% Save "fInfo"
   
% Make a separate matlab structure with information 
% about the position functions we've just created

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
fprintf('\nDone.\n')









