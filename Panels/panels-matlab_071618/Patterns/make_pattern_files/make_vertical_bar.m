%% make vertical bar
% blank screen @ positions 
% (xpos=72, ypos=1:16)
% (xpos=1, ypos=1:16)


clear all; clc

% --------------- Pattern-specific info ---------------

% filename='Pattern_021_bright_vertical_bar_2x2_pix';
% object_width=2; % number of LED dots wide
% backgroundValue=0; % 0=bright obj. on dark bkgd, 1=dark obj. on bright bkgd

filename='Pattern_022_dark_vertical_bar_2x2_pix';
object_width=2; % number of LED dots wide
backgroundValue=1; % 0=bright obj. on dark bkgd, 1=dark obj. on bright bkgd

% -----------------------------------------------------




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

nGhostPixels=object_width; 
% Adding imaginary panels on the azimuth so that the bar appears to shift 
% all the way off the edges of the display

% initialize Pats array with zeros
Pats = zeros(LEDdotsVertically,...
    LEDdotsAcross,...
    pattern.x_num,pattern.y_num);

% Draw the initial image at xpos=l, ypos=1
initialImage=zeros(LEDdotsVertically,LEDdotsAcross);
initialImage(1:LEDdotsVertically,1:object_width)=1;


% Construct the pattern - image sequence will be identical at each ypos
for ypos=1:pattern.y_num
    Pats(:,:,1,ypos)=initialImage; 
    for xpos=2:pattern.x_num % shift the image to the right along the azimuth
        lastImage=Pats(:,:,xpos-1,ypos);
        newImage=circshift(lastImage,[0 1]); % shift the 1st dimension by 0, shift the 2nd dimension by 1
        Pats(:,:,xpos,ypos)=newImage;
    end
end

% Make sure whole matrix is blank at the right position(s)
for yp=1:16
    Pats(:,:,1,yp)=initialImage*0;
    Pats(:,:,72,yp)=initialImage*0;
end




if backgroundValue==1 % Invert values (including 'blank' screen), if requested - 
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
save(filename,'pattern')




    