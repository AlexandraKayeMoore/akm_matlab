%% Make FF flash functions (015,016)
% Five full field flashes (duration 200 ms), separated by 4 seconds of
% darkness.

clear all; clc
dbstop if error


% -----------------------------
fDescription='FF_flashes';
xfuncNum='015';
yfuncNum='016';
% -----------------------------





%% Standard parameters...

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

%% Make frame sequence

% Full screen bright: xpos=5:10, ypos=5:10 
% Full screen dark: all other values

% 2,2 = whole screen dark
dark_X=2;  
dark_Y=2; 

% 7,7 = whole screen bright
bright_X=7;
bright_Y=7;


% This is a super-simple function so we'll 
% just create each event as we go...

events=struct();
xpositionFunction=[]; 
ypositionFunction=[];

% Start with 4 seconds (200 frames) of darkness
i=1;
events(i).name='FF_dark';
events(i).xposvalues=repmat(dark_X,1,200);
events(i).yposvalues=repmat(dark_Y,1,200);
xpositionFunction=[xpositionFunction events(i).xposvalues];
ypositionFunction=[ypositionFunction events(i).yposvalues];

for nreps=1:5
    
    % Whole screen bright for 0.2 seconds (10 frames)
    i=i+1;
    events(i).name='FF_flash';
    events(i).xposvalues=repmat(bright_X,1,10);
    events(i).yposvalues=repmat(bright_Y,1,10);
    xpositionFunction=[xpositionFunction events(i).xposvalues];
    ypositionFunction=[ypositionFunction events(i).yposvalues];
    
    % Whole screen dark for 4 seconds (200 frames)
    i=i+1;
    events(i).name='FF_dark';
    events(i).xposvalues=repmat(dark_X,1,200);
    events(i).yposvalues=repmat(dark_Y,1,200);
    xpositionFunction=[xpositionFunction events(i).xposvalues];
    ypositionFunction=[ypositionFunction events(i).yposvalues];
    
end

func_X=xpositionFunction;
func_Y=ypositionFunction;

% Note the duration of the whole file in seconds and frames
totalDur_frames=length(func_X);
totalDur_s=totalDur_frames*(1/PANELS_FRAME_RATE);


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
fInfo.shuffledEvents=events; % events, in the order in which they occur
fInfo.frames_per_pos=1;
fInfo.frames_per_isi=200;
fInfo.totalDur_frames=totalDur_frames;
fInfo.totalDur_s=totalDur_s;
fInfo.xpositionFunction=xpositionFunction;
fInfo.ypositionFunction=ypositionFunction;

cd('C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\functions\make_function_files');
save(fInfo_filename,'fInfo');

fprintf('\n     Done!')
fprintf('\n     Function duration: %.1f seconds, %.0f frames\n',totalDur_s,totalDur_frames)










