%% Flash object at each location on the screen

clear all; clc
dbstop if error


% ***** Function-specific parameters *****

% 4x4 object

% fDescription='flash_each_location_4x4_obj_0.5sec';
% xfuncNum='035';
% yfuncNum='036';
% object_width=4; 
% flashDuration_s=0.5;
% isiDuration_s=1;

fDescription='flash_each_location_4x4_obj_2.0sec';
xfuncNum='037';
yfuncNum='038';
object_width=4; 
flashDuration_s=2.0;
isiDuration_s=1;





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

% Divide up the arena based on object size (note that xpos,ypos specifies the location of the object's *center*)
azimuth_positions=(object_width/2):object_width:xposMax;
elevation_positions=(object_width/2):object_width:yposMax;

% Make each scan an 'event'
events=struct();
i=1;

for az=1:length(azimuth_positions)
    for ev=1:length(elevation_positions)
        events(i).name='flash_object';
        events(i).xposvalues=azimuth_positions(az);
        events(i).yposvalues=elevation_positions(ev);
        fprintf('\n #%.0f x=%.0f,y=%.0f',i,events(i).xposvalues,events(i).yposvalues)
        i=i+1;
    end
end






%% Pseudo-shuffle the order of events, then create the frame sequence to send to the panels 

shuffledOrder=randperm(length(events));


% frames_per_pos: number of frames to devote to each (xpos,ypos) value
frames_per_pos=floor(flashDuration_s*PANELS_FRAME_RATE); % [# frames delivered in 1 second] / [# of positions to traverse in 1 second]

% Number of blank frames to add between events (isi period)
frames_per_isi=isiDuration_s*PANELS_FRAME_RATE;

% Last position in the pattern file=black screen. We'll use this during the ISI period.
BLANK_DIM_X=LEDdotsAcross;  
BLANK_DIM_Y=LEDdotsVertically; 

% Show blank screen for 4 seconds (200 frames) before the 1st stimulus
xpositionFunction=[repmat(BLANK_DIM_X,1,200)]; 
ypositionFunction=[repmat(BLANK_DIM_Y,1,200)];

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

% Show blank screen for 4 seconds (200 frames) after the last stimulus
xpositionFunction=[xpositionFunction repmat(BLANK_DIM_X,1,200)];
ypositionFunction=[ypositionFunction repmat(BLANK_DIM_Y,1,200)];

func_X=xpositionFunction;
func_Y=ypositionFunction;

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









