%% Functions 009/010, elevationScan_2x2_30degPerSec_altLR_sequential

clear all; clc

desiredSpeed_degreesPerSec=30; 
alternating_mvmt_direction=1;
pseudo_shuffle_elevations=0;  

fDescription='elevationScan_2x2_30degPerSec_altLR_sequential'
xfilename=['position_function_009_' fDescription '_Xpos.mat']
yfilename=['position_function_010_' fDescription '_Ypos.mat']

isiDuration_s = 0.5;








% ------------------------------------




numOfPanelsAcross = 9;  
numOfPanelsVertically = 2;
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 
LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

PIXELS_PER_DEGREE = 96/360; % If we had a full circle with 12 more panels (12*8 = 96 LEDs)
PANELS_FRAME_RATE = 50; % 50 Hz = new frame every 20 ms
OBJECT_WIDTH = 2; % object size in pixels, for spacing the trajectories 

xposMin = 1; xposMax = 72;  % 72 = # of steps in the animation  ("xposMax=39; % LED position at midline")
yposMin = 1; yposMax = LEDdotsVertically-(OBJECT_WIDTH);  % LED panels position

xposValues = xposMin : xposMax; % Pass through each point on the azimuth
yposValues = yposMin : 2 : yposMax; % Sample every other elevation 

% We can use this function with 1x1 and 2x2 pixel objects. If the
% object is any larger than that, the trajectories will overlap in space.



%% --- Populate the x and y position arrays ---

xpositionArray=[];
ypositionArray=[];

if pseudo_shuffle_elevations
    ypos_index = [7 2 6 1 3 4 5]; % randperm(length(yposValues));
else
    ypos_index = 1:length(yposValues);
end

for yp=ypos_index
    
    % Repeat the xpos sequence for each starting position
    
    if alternating_mvmt_direction && mod(yp,2)==0
        % If we're alternating the direction of movement AND this is an
        % even elevation index number, then use the reverse sequence
        xpositionArray=[xpositionArray xposValues(end:-1:1)];
        ypositionArray=[ ypositionArray repmat(yposValues(yp),1,length(xposValues)) ];
    else
        xpositionArray=[xpositionArray xposValues];
        ypositionArray=[ ypositionArray repmat(yposValues(yp),1,length(xposValues)) ];
    end
    
end







%% Create frame sequence to send to the panels 

% Frames_per_xpos: number of frames to devote to each xposValue
desiredSpeed_pixelsPerSec = desiredSpeed_degreesPerSec * PIXELS_PER_DEGREE;
frames_per_xpos = floor(PANELS_FRAME_RATE/desiredSpeed_pixelsPerSec); % [# frames delivered in 1 second] / [# of positions to traverse in 1 second]

% Number of blank frames to add between trajectories
num_isi_frames = isiDuration_s * PANELS_FRAME_RATE;

% Last position in the pattern file = black screen. We'll use this during the ISI period.
BLANK_DIM_X = LEDdotsAcross;  
BLANK_DIM_Y = LEDdotsVertically; 



% Make the frame sequence

xpositionFunction = []; 
ypositionFunction = [];

for p=1:length(xpositionArray) % For each xpos,ypos combination...
    
    current_xpos = xpositionArray(p);
    current_ypos = ypositionArray(p);
    
    % duplicate x and y values for the appropriate number of frames
    xframes = repmat(current_xpos, 1, frames_per_xpos);
    yframes = repmat(current_ypos, 1, frames_per_xpos);
    
    if mod(p,length(xposValues))==0
        % Add ISI frames before we step to a new elevation
        xframes = [ xframes repmat(BLANK_DIM_X, 1, num_isi_frames) ];
        yframes = [ yframes repmat(BLANK_DIM_Y, 1, num_isi_frames) ];
    end
    
    xpositionFunction = [xpositionFunction xframes]; 
    ypositionFunction = [ypositionFunction yframes];

end

func_X = xpositionFunction;
func_Y = ypositionFunction;

% Note the duration of the file in seconds and frames
totalDur_frames=length(func_X);
totalDur_s=totalDur_frames*(1/PANELS_FRAME_RATE);
fprintf('\nFunction duration: %.1f seconds, %.0f frames\n\n',totalDur_s,totalDur_frames)


%% Save function to load onto the SD card

directory_name='C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\functions';

func = func_X;
str_x = [directory_name '\' xfilename]; 
save(str_x, 'func'); % variable must be named 'func'

func = func_Y;
str_y = [directory_name '\' yfilename]; 	
save(str_y, 'func'); % variable must be named 'func'
