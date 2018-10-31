%% make_grating_pattern

clear all; clc


filename='Pattern_026_drifting_grating_9px_stripes';
path2arenaImage='C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns\make_pattern_files\older patterns\arena_image_vertical_grating_9px.mat'


%% Make pattern

numOfPanelsAcross=9;  
numOfPanelsVertically=2;
LEDdotsPerPanel=8;  
LEDdotsAcross=numOfPanelsAcross*LEDdotsPerPanel; % 72
LEDdotsVertically=numOfPanelsVertically*LEDdotsPerPanel;  % 16

% make pattern structure
pattern.x_num=LEDdotsAcross; 
pattern.y_num=LEDdotsVertically; 
pattern.num_panels=18;  
pattern.gs_val=2; % Pattern gray scale value

% initialize Pats array with zeros
Pats=zeros(LEDdotsVertically,LEDdotsAcross,pattern.x_num,pattern.y_num);

% Draw the initial image at xpos=l, ypos=1
infile=load(path2arenaImage);
initialImage=infile.arenaImage;
clear infile

% Shift image in the x dimension (the sequence will be identical at each ypos)
for ypos=1:pattern.y_num
    Pats(:,:,1,ypos)=initialImage; 
    for xpos=2:pattern.x_num % shift the image to the right along the azimuth
        lastImage=Pats(:,:,xpos-1,ypos);
        newImage=circshift(lastImage,[0 1]); % shift the 1st dimension by 0, shift the 2nd dimension by 1
        Pats(:,:,xpos,ypos)=newImage;
    end
end

% Make sure whole matrix is blank at (xpos=1,ypos=all) and (xpos=72,ypos=all)
for yp=1:16
    Pats(:,:,1,yp)=initialImage*0;
    Pats(:,:,72,yp)=initialImage*0;
end


% Make panel map for 270 degree arena ("updated 10/25/17" - YF)
pattern.Panel_map=[9, 12, 13, 15, 17, 14, 16, 18, 8 ;...
    1, 5, 2, 6, 10, 3, 7, 11, 4];


% Put data in pattern structure
pattern.Pats=Pats;
pattern.BitMapIndex=process_panel_map(pattern);
pattern.data=Make_pattern_vector(pattern);

% Save pattern to be put on the SD card (name must begin with ‘Pattern_’)
cd('C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns')
save(filename,'pattern');