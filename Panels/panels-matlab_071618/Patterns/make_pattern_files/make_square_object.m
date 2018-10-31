%% n-by-n pixel object at each location
% -Location on the display is encoded as combinations of x dim and y dim.
% -Positions (1,1) and (xmax,ymax) = blank screen.
% -Object width should be divisible by 2.

clear all; clc

%% Pattern-specific info


% 4x4 pixels--

% filename='Pattern_014_bright_obj_4x4_pix';
% DOT_WIDTH=4;
% backgroundValue=0;

% filename='Pattern_015_dark_obj_4x4_pix';
% DOT_WIDTH=4;
% backgroundValue=1;  



% 8x8 pixels--

% filename='Pattern_018_bright_obj_8x8_pix';
% DOT_WIDTH=8; 
% backgroundValue=0; 

filename='Pattern_019_dark_obj_8x8_pix';
DOT_WIDTH=8;
backgroundValue=1;  




%% Make pattern

numOfPanelsAcross = 9;  
numOfPanelsVertically = 2;
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs will always be 8 dots in x and y.
LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 72
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;  % 16

% make pattern structure
pattern.x_num = LEDdotsAcross; 
pattern.y_num = LEDdotsVertically; 
pattern.num_panels = 18;  
pattern.gs_val = 2; % Pattern gray scale value

nGhostPixels=DOT_WIDTH; 
% Adding imaginary panels so that the object appears to shift 
% all the way off the edges of the display


    
% Initialize Pats array with zeros
Pats = zeros(LEDdotsVertically+(2*nGhostPixels),...
    LEDdotsAcross+(2*nGhostPixels),...
    pattern.x_num,pattern.y_num);

% Draw the initial image at xpos=l, ypos=1
initialImage=zeros(LEDdotsVertically+(2*nGhostPixels),LEDdotsAcross+(2*nGhostPixels));
initialImage(1:DOT_WIDTH,1:DOT_WIDTH)=1;

% Shift the initial image by half the object's width in both directions,
% so that (xpos,ypos) corresponds to the object's center
initialImage=circshift(initialImage,[DOT_WIDTH DOT_WIDTH]/2);


% Construct the pattern for each ypos
for ypos=1:pattern.y_num
    Pats(:,:,1,ypos)=circshift(initialImage,[ypos-1,0]); % shift the 1st dimension "down" by ypos
    for xpos=2:pattern.x_num % shift the image to the right along the azimuth
        lastImage=Pats(:,:,xpos-1,ypos);
        newImage=circshift(lastImage,[0 1]); % shift the 1st dimension by 0, shift the 2nd dimension by 1
        Pats(:,:,xpos,ypos)=newImage;
    end
end

% Discard ghost pixels

% shift the arena images so that 1/4th of the object is visible at
% position 1,1 and xmax,ymax -- i.e., xpos,ypos specifies the CENTER
% of the object.
xvals2keep=(nGhostPixels+1):(size(Pats,2)-nGhostPixels);
yvals2keep=(nGhostPixels+1):(size(Pats,1)-nGhostPixels);

Pats=Pats(yvals2keep,xvals2keep,:,:);


% Make sure whole matrix is blank at (1,1) & (xmax,ymax) 
Pats(:,:,pattern.x_num,pattern.y_num)=zeros(size(Pats,1),size(Pats,2)); 
Pats(:,:,1,1)=zeros(size(Pats,1),size(Pats,2)); 


if backgroundValue==1 % Invert values, if requested - including 'blank' screen
    invertedPats=Pats;
    invertedPats(invertedPats==0)=2; % Convert 0s to 2s
    invertedPats=invertedPats-1; % Subtract one so that 2s --> 1s, and 1s --> 0s
    Pats=invertedPats;
end




% Make panel map for 270 degree arena ("updated 10/25/17" - YF)
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ;...
    1, 5, 2, 6, 10, 3, 7, 11, 4];

% Put data in pattern structure
pattern.Pats = Pats;
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

% Save pattern to be put on the SD card (name must begin with ‘Pattern_’)
cd('C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns')
save(filename, 'pattern')
clc
fprintf('\n\n   Done! ''%s'' was successfully saved.\n',filename)




