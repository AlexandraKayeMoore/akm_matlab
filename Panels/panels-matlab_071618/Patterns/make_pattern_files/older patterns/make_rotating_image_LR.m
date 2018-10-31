%% make_rotating_image_LR
% Shift an arena image (16x72) rightwards.
% Frame sequence is the same regardless of ypos. 
% xpos=72, ypos=16 is a dark screen

clear all; close all; clc





%% Pattern-specific info


% filename='Pattern_008_drifting_grating_6px_vertical_stripes';
% infile=load('C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns\make_pattern_files\arena_image_vertical_grating_6px.mat');
% initialImage=infile.arenaImage;
% blankScreenValue=0; 

% filename='Pattern_009_drifting_grating_12px_vertical_stripes';
% infile=load('C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns\make_pattern_files\arena_image_vertical_grating_12px.mat');
% initialImage=infile.arenaImage;
% blankScreenValue=0; 

% filename='Pattern_010_bright_vertical_bar_6px';
% infile=load('C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns\make_pattern_files\arena_image_bright_vertical_bar_6px.mat');
% initialImage=infile.arenaImage;
% blankScreenValue=0;

% filename='Pattern_011_dark_vertical_bar_6px';
% infile=load('C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns\make_pattern_files\arena_image_dark_vertical_bar_6px.mat');
% initialImage=infile.arenaImage;
% blankScreenValue=1;

 





if 0
    
imagesc(initialImage);
set(gca,'xtick',[0:72]+0.5,'ytick',[0:16]+0.5,'xticklabel',{},'yticklabel',{},'ticklength',[0 0]); 
axis tight
grid on
set(gcf,'position',[110 910 2050 420],'color',[1 1 1])

end % show image


%% Generate the pattern

numOfPanelsAcross = 9;  
numOfPanelsVertically = 2;
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs will always be 8 dots in x and y.
LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 72
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;  

% save to structure
pattern.x_num = LEDdotsAcross; % last x value will be a blank screen, i.e. we'll skip the last position/frame.
pattern.y_num = LEDdotsVertically; % elevation of the dot; value 16 will be
pattern.num_panels = 18; % 24
pattern.gs_val = 2; % Pattern gray scale value





% initialize Pats array with zeros
Pats = zeros( LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num );





% Shift image right by 1 pixel, 72 times, to populate the x dimension.
% We'll duplicate the shifted images across the y dimension in the next
% step.

Pats(:,:,1,1)=initialImage; % xpos=1 is the initial image

for xpos = 2 : LEDdotsAcross 
    
     lastImage=Pats(:,:,xpos-1,1);
     newImage=circshift(lastImage,[0 1]); % shift the 1st dimension by 0, shift the 2nd dimension by 1
     Pats(:,:,xpos,1)=newImage;
  
     if 0 % check new image
         imagesc(newImage);
         set(gca,'xtick',[0:72]+0.5,'ytick',[0:16]+0.5,'xticklabel',{},'yticklabel',{},'ticklength',[0 0]);
         axis tight
         grid on
         set(gcf,'position',[110 910 2050 420],'color',[1 1 1])
     end 
     
end

for ypos = 2 : LEDdotsVertically
    Pats(:,:,:,ypos)=squeeze(Pats(:,:,:,1));
end

Pats(:,:,pattern.x_num,pattern.y_num) = blankScreenValue; % Make sure whole matrix is blank when x or y is max

if 1
    implay(squeeze(Pats(:,:,:,LEDdotsVertically-1)))
end



% Make panel map for 230 degree arena ("updated 10/25/17" - YF)
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ;...
    1, 5, 2, 6, 10, 3, 7, 11, 4];

% Put data in pattern structure
pattern.Pats = Pats;
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

% Save pattern to be put on the SD card (name must begin with ‘Pattern_’)
directoryname = 'C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns\';
str = [directoryname filename];
save(str, 'pattern');








 




 