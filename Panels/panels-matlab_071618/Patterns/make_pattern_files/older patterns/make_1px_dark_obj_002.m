%% Pattern 002: Dark obj. 1 LED wide at each location on the display

% ***State (56,16) = whole screen bright***

clear all; clc

numOfPanelsAcross = 9; %12
numOfPanelsVertically = 2;
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs will always be 8 dots in x and y.
LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 72
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel; % 16

% Save to structure
pattern.x_num = LEDdotsAcross; % last x value will be a blank screen, i.e. we'll skip the last position/frame.
pattern.y_num = LEDdotsVertically; % elevation of the dot; value 16 will be
pattern.num_panels = 18; % 24
pattern.gs_val = 2; % Pattern gray scale value


DOT_WIDTH = 1; % number of LED dots wide


% initialize the array with zeros
Pats = zeros(LEDdotsVertically,LEDdotsAcross,pattern.x_num,pattern.y_num);

% construct the dot patterns within each dimention (0 = dark, 1 = bright)
for ypos = 1: LEDdotsVertically - ( DOT_WIDTH - 1)
    
    % build intial dot pattern for this y position (elevation)
    dot_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
    dot_pattern( ypos: ypos + DOT_WIDTH - 1 , 1 : DOT_WIDTH ) = 1; % draw the object
    
    for xpos = 1: LEDdotsAcross - ( DOT_WIDTH - 1)
        
        % shift the object to a new azimuth position ("shift dot_pattern to
        % each different location depending on current x pos")
        Pats(:, :, xpos , ypos) = ShiftMatrix (dot_pattern, (xpos - 1),'r','y');
        
    end
    
end

Pats(:,:,pattern.x_num, pattern.y_num) = 0; % Make sure whole matrix is blank when x or y is max

% 230 degree arena updated 10/25/17 (YF)
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ;...
    1, 5, 2, 6, 10, 3, 7, 11, 4];





% ***Invert values***
invertedPats=Pats;
invertedPats(invertedPats==0)=2; % Convert 0s to 2s
invertedPats=invertedPats-1; % Subtract one so that 2s --> 1s, and 1s --> 0s

% Put data in pattern structure
pattern.Pats = invertedPats;
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

% Save pattern to be put on the SD card (name must begin with ‘Pattern_’)
directory_name = 'C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns';
str = [directory_name '\Pattern_002_Dark_Obj_1px'];
save(str, 'pattern');






