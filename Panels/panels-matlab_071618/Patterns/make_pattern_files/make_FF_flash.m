%% Pattern 020 - FF on/off
% - whole arena is bright at xpos=5:10 and ypos=5:10
% - whole arena is dark at all other positions 

clear all; clc


filename='Pattern_020_FFon_FFoff';


numOfPanelsAcross = 9; 
numOfPanelsVertically = 2;
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs will always be 8 dots in x and y.
LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 72
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel; % 16

% Add info to pattern structure
pattern.x_num = LEDdotsAcross; % last x,y value will be a blank screen, i.e. we'll skip the last position/frame.
pattern.y_num = LEDdotsVertically; 
pattern.num_panels = 18; 
pattern.gs_val = 2; % Pattern gray scale value

% Create 'Pats' array filled with zeros
Pats = zeros(LEDdotsVertically,LEDdotsAcross,pattern.x_num,pattern.y_num);

% Make the arena bright at xpos=5:10 and ypos=5:10
Pats(:,:,5:10,5:10)=1; 

% Make panel_map ("230 degree arena updated 10/25/17" - YF)
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1, 5, 2, 6, 10, 3, 7, 11, 4];

% Add data to struct
pattern.Pats = Pats;
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

% Save pattern to be put on the SD card (name must begin with ‘Pattern_’)
directoryname = 'C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns\';
str = [directoryname filename];
save(str, 'pattern');






