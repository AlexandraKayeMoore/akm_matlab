%% make_2_obj_patterns_bright

% Make patterns with one dark, 8x8 pixel object at a fixed location,
% and a second object at every location on the screen.

% Modified from 'square_objects_v2.m' - 10/25/18

clear all; close all; clc
dbstop if error

%% Info for 18 patterns - one for each 8x8 panel

i=0;

i=i+1;
pats2make(i).horizontalRange=1:8; % px to fill, max=72
pats2make(i).verticalRange=1:8; % px to fill, max=16
pats2make(i).filename='Pattern_037_two_bright_objects_panel_1';

i=i+1;
pats2make(i).horizontalRange=1:8;
pats2make(i).verticalRange=9:16;
pats2make(i).filename='Pattern_038_two_bright_objects_panel_2';

i=i+1;
pats2make(i).horizontalRange=9:16;
pats2make(i).verticalRange=1:8;
pats2make(i).filename='Pattern_039_two_bright_objects_panel_3';

i=i+1;
pats2make(i).horizontalRange=9:16;
pats2make(i).verticalRange=9:16;
pats2make(i).filename='Pattern_040_two_bright_objects_panel_4';

i=i+1;
pats2make(i).horizontalRange=17:24;
pats2make(i).verticalRange=1:8;
pats2make(i).filename='Pattern_041_two_bright_objects_panel_5';

i=i+1;
pats2make(i).horizontalRange=17:24;
pats2make(i).verticalRange=9:16;
pats2make(i).filename='Pattern_042_two_bright_objects_panel_6';

i=i+1;
pats2make(i).horizontalRange=25:32;
pats2make(i).verticalRange=1:8;
pats2make(i).filename='Pattern_043_two_bright_objects_panel_7';

i=i+1;
pats2make(i).horizontalRange=25:32;
pats2make(i).verticalRange=9:16;
pats2make(i).filename='Pattern_044_two_bright_objects_panel_8';

i=i+1;
pats2make(i).horizontalRange=33:40;
pats2make(i).verticalRange=1:8;
pats2make(i).filename='Pattern_045_two_bright_objects_panel_9';

i=i+1;
pats2make(i).horizontalRange=33:40;
pats2make(i).verticalRange=9:16;
pats2make(i).filename='Pattern_046_two_bright_objects_panel_10';

i=i+1;
pats2make(i).horizontalRange=41:48;
pats2make(i).verticalRange=1:8;
pats2make(i).filename='Pattern_047_two_bright_objects_panel_11';

i=i+1;
pats2make(i).horizontalRange=41:48;
pats2make(i).verticalRange=9:16;
pats2make(i).filename='Pattern_048_two_bright_objects_panel_12';

i=i+1;
pats2make(i).horizontalRange=49:56;
pats2make(i).verticalRange=1:8;
pats2make(i).filename='Pattern_049_two_bright_objects_panel_13';
i=i+1;
pats2make(i).horizontalRange=49:56;
pats2make(i).verticalRange=9:16;
pats2make(i).filename='Pattern_050_two_bright_objects_panel_14';

i=i+1;
pats2make(i).horizontalRange=57:64;
pats2make(i).verticalRange=1:8;
pats2make(i).filename='Pattern_051_two_bright_objects_panel_15';

i=i+1;
pats2make(i).horizontalRange=57:64;
pats2make(i).verticalRange=9:16;
pats2make(i).filename='Pattern_052_two_bright_objects_panel_16';

i=i+1;
pats2make(i).horizontalRange=65:72;
pats2make(i).verticalRange=1:8;
pats2make(i).filename='Pattern_053_two_bright_objects_panel_17';

i=i+1;
pats2make(i).horizontalRange=65:72;
pats2make(i).verticalRange=9:16;
pats2make(i).filename='Pattern_054_two_bright_objects_panel_18';

%% Make and save patterns

backgroundValue=0;
object_width=8;
half_width=object_width/2;

for i=1:length(pats2make)
    
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
            
            % Draw the first object
            thisImage=blankImage;
            thisImage( [ypos:(ypos+object_width-1)], [xpos:(xpos+object_width-1)] )=1;
            thisImage=thisImage( [half_width:(LEDdotsVertically+half_width-1)] , [half_width:(LEDdotsAcross+half_width-1)] );
            
            % Add in the 2nd object at a fixed location
            thisImage2=thisImage;
            thisImage2(pats2make(i).verticalRange,pats2make(i).horizontalRange)=1;
            
            Pats(:,:,xpos,ypos)=thisImage2; % Save to Pats array
            
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
    
    
    if 0 % Check pattern
        
        figure; imagesc(thisImage2)
        set(gca,'xtick',1:size(thisImage2,2),'ytick',1:size(thisImage2,1));
        grid on; set(gca,'gridcolor',[1 1 1],'gridalpha',0.5)
        set(gca,'fontsize',8)
        title(pats2make(i).filename,'interpreter','none');
        set(gcf,'position',[10 605 1660 310])
        shg
        
        
        %myvid=squeeze(Pats(:,:,:,8));
        %implay(myvid)
        
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
    save(pats2make(i).filename, 'pattern')
    clc; fprintf('\n\n   Done! ''%s'' was successfully saved.\n',...
        pats2make(i).filename)
    
end

