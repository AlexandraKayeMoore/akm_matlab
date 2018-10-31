% Pattern for a vertical bar sweeping across the screen - version 2
%
% These x/y combinations will be a blank screen:
% x=1, y=1:16
% x=1:72, y=1
%
% - Animate the bar at each x location within a 71-by-15 pixel space,
%   with the same x sequence repeated across the y dimension.
% - Set blanks
% - Save it

clear all; close all; clc

dbstop if error




% filename='Pattern_032_2px_bright_bar';
% backgroundValue=0; 
% object_width=2;
% half_width=object_width/2;

% filename='Pattern_033_4px_bright_bar';
% backgroundValue=0; 
% object_width=4;
% half_width=object_width/2;

filename='Pattern_034_4px_dark_bar';
backgroundValue=1; 
object_width=4;
half_width=object_width/2;









%% Make pattern

numOfPanelsAcross=9; % These are all fixed values
numOfPanelsVertically=2;
LEDdotsPerPanel=8; 
LEDdotsAcross=numOfPanelsAcross*LEDdotsPerPanel; % 72
LEDdotsVertically=numOfPanelsVertically*LEDdotsPerPanel;  % 16

pattern.x_num=LEDdotsAcross; 
pattern.y_num=LEDdotsVertically; 
pattern.num_panels=18;  
pattern.gs_val=2; % Pattern gray scale value

% Initialize Pats array with zeros
Pats=zeros(LEDdotsVertically,LEDdotsAcross,pattern.x_num,pattern.y_num); % 16x72x72x16

% Draw the initial arena image, with some extra space that we'll shave off
% before adding it to Pats
blankImage=zeros(LEDdotsVertically+object_width,LEDdotsAcross+object_width);

% Draw the object @ each x,y location

for ypos=1:pattern.y_num
    for xpos=1:pattern.x_num
        thisImage=blankImage;
        thisImage(:,[xpos:(xpos+object_width-1)])=1;
        thisImage=thisImage( [half_width:(LEDdotsVertically+half_width-1)] , [half_width:(LEDdotsAcross+half_width-1)] );
        Pats(:,:,xpos,ypos)=thisImage; 
    end
end

% Set blanks in y
xpos=1;
for ypos=1:pattern.y_num
    Pats(:,:,xpos,ypos)=zeros(LEDdotsVertically,LEDdotsAcross);
end

% Set blanks in x
ypos=1;
for xpos=1:pattern.x_num
    Pats(:,:,xpos,ypos)=zeros(LEDdotsVertically,LEDdotsAcross);
end


if backgroundValue==1  % Invert values, including 'blank' screen
    invertedPats=Pats;
    invertedPats(invertedPats==0)=2; % Convert 0s to 2s
    invertedPats=invertedPats-1; % Subtract one so that 2s --> 1s, and 1s --> 0s
    Pats=invertedPats;
end



%% Check pattern

if 1
    
figure; imagesc(thisImage)
set(gca,'xtick',1:size(thisImage,2),'ytick',1:size(thisImage,1))
grid on
set(gca,'gridcolor','r','gridalpha',0.5)


myvid=squeeze(Pats(:,:,:,8));
implay(myvid)

end



%% Save pattern

% Make panel map for 270 degree arena ("updated 10/25/17" - YF)
pattern.Panel_map=[9, 12, 13, 15, 17, 14, 16, 18, 8 ;...
    1, 5, 2, 6, 10, 3, 7, 11, 4];

% Put data in pattern structure
pattern.Pats=Pats;
pattern.BitMapIndex=process_panel_map(pattern);
pattern.data=Make_pattern_vector(pattern);

% Save pattern to be put on the SD card (name must begin with ‘Pattern_’)
cd('C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns')
save(filename, 'pattern')
clc; fprintf('\n\n   Done! ''%s'' was successfully saved.\n',filename)



