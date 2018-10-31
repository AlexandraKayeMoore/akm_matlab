% make_Patterns

%% <<<akm>>> LIGHT ON dots 1 LED wide at each location on the screen
 % UPDATED for new 270 degree arena!!
 %   The dot location is encoded as combinations of x dim and y dim
 %   xpos = 56 and y pos = 16 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 12;% 9;% 9 panels across - updated 10/25
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 DOT_WIDTH = 1; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = LEDdotsVertically; 		% Y will store where the dot is on the screen in y, last dim = 16 is blank
 
 pattern.num_panels = 24; %18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 for ypos = 1: LEDdotsVertically - ( DOT_WIDTH - 1)
     % build intial dot pattern for this y position
     dot_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
     dot_pattern( ypos: ypos + DOT_WIDTH - 1 , 1 : DOT_WIDTH ) = 1; % draw light dot into matrix
     
     
     for xpos = 1: LEDdotsAcross - ( DOT_WIDTH - 1)
         
         % shift dot_pattern to each different location depending on current
         % x pos
         Pats(:, :, xpos , ypos) = ShiftMatrix (dot_pattern, (xpos - 1),'r','y'); % place
         
     end
 end
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 230 degree arena updated 10/25/17 define panel structure vector
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_007_1pixelBrightDot']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% LIGHT ON dots 1 LED wide vertical bar
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 12;%9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 1; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 24; %18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
 bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix
 
 
 for xpos = 1: LEDdotsAcross - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 230 degree arena updated 10/25/17 define panel structure vector
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_008_1pixelBrightVertBar']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');

%% LIGHT ON dots 2 LED wide at each location on the screen
%   The dot location is encoded as combinations of x dim and y dim
%   xpos = 56 and y pos = 16 are the full screen dark. 

clear all;
numOfPanelsAcross = 12; % virtual 360 degrees repsented %9;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

DOT_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
pattern.y_num = LEDdotsVertically; 		% Y will store where the dot is on the screen in y, last dim = 16 is blank

pattern.num_panels = 24;% fictive panels for 360 %18; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 2; 	% This pattern gray scale value

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Construct the dot patterns within each dimention
% zeros 0 = dark, ones 1 = light

for ypos = 1: LEDdotsVertically - ( DOT_WIDTH - 1)   
    % build intial dot pattern for this y position
    dot_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
    dot_pattern( ypos: ypos + DOT_WIDTH - 1 , 1 : DOT_WIDTH ) = 1; % draw light dot into matrix
    

    for xpos = 1: LEDdotsAcross - ( DOT_WIDTH - 1)
        
        % shift dot_pattern to each different location depending on current
        % x pos
        Pats(:, :, xpos , ypos) = ShiftMatrix (dot_pattern, (xpos - 1),'r','y'); % place 
       
    end
end

% Make sure whole matrix is blank when x or y is max  = 0 for a blank
% screen,
Pats(:, : , pattern.x_num, pattern.y_num) = 0;

pattern.Pats = Pats; 		% put data in structure 

%pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
%pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
% panels 19-24 are fictive and do not actually exist on hardware!

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_001_2pixelBrightDot']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% LIGHT ON dots 4 LED wide at each location on the screen
%   The dot location is encoded as combinations of x dim and y dim
%   xpos = 56 and y pos = 16 are the full screen dark. 

clear all;
numOfPanelsAcross = 9;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

DOT_WIDTH = 4; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
pattern.y_num = LEDdotsVertically; 		% Y will store where the dot is on the screen in y, last dim = 16 is blank

pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 2; 	% This pattern gray scale value

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Construct the dot patterns within each dimention
% zeros 0 = dark, ones 1 = light

for ypos = 1: LEDdotsVertically - ( DOT_WIDTH - 1)   
    % build intial dot pattern for this y position
    dot_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
    dot_pattern( ypos: ypos + DOT_WIDTH - 1 , 1 : DOT_WIDTH ) = 1; % draw light dot into matrix
    

    for xpos = 1: LEDdotsAcross - ( DOT_WIDTH - 1)
        
        % shift dot_pattern to each different location depending on current
        % x pos
        Pats(:, :, xpos , ypos) = ShiftMatrix (dot_pattern, (xpos - 1),'r','y'); % place 
       
    end
end

% Make sure whole matrix is blank when x or y is max  = 0 for a blank
% screen,
Pats(:, : , pattern.x_num, pattern.y_num) = 0;

pattern.Pats = Pats; 		% put data in structure 

%pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_002_4pixelBrightDot']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');

%%  <<<akm>>> LIGHT ON 2 LED wide vertical bar
%   The bar's horizontal location is encoded in x dim 
% whether the bar is on or not is encoded in y dim

clear all;
numOfPanelsAcross = 12;% 9;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

BAR_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;

pattern.num_panels = 24; %18; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 2; 	% This pattern gray scale value

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Construct the dot patterns within each dimention
% zeros 0 = dark, ones 1 = light

% build intial bar pattern 
bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix


for xpos = 1: LEDdotsAcross - ( BAR_WIDTH - 1)
    
    % shift dot_pattern to each different location depending on current
    % x pos
    Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
    
end


% Make sure whole matrix is blank when x or y is max  = 0 for a blank
% screen,
Pats(:, : , pattern.x_num, pattern.y_num) = 0;

pattern.Pats = Pats; 		% put data in structure 

%pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
%pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 230 degree arena updated 10/25/17 define panel structure vector
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
% panels 19-24 are fictive and do not actually exist on hardware!

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_003_2pixelBrightVertBar']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');

%%  <<<akm>>> LIGHT ON 2 LED wide horizonal bar
%   The bar's vertical location is encoded in y dim 
% whether the bar is on or not is encoded in x dim
%   xpos = 2 and/or y pos = 16 are the full screen dark. 

clear all;
numOfPanelsAcross = 12;%9;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

BAR_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = 2; %  X will encode if the bar is displayed=1, not displayed= 2;
pattern.y_num = LEDdotsVertically; 		% Y will store where the dot is on the screen in y, last dim = 16 is blank

pattern.num_panels = 24;%18; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 2; 	% This pattern gray scale value

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Construct the dot patterns within each dimention
% zeros 0 = dark, ones 1 = light
for ypos = 1: LEDdotsVertically - ( BAR_WIDTH - 1)
    % build  bar pattern for this ypos
    bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
    bar_pattern(  ypos: ypos + BAR_WIDTH - 1, : ) = 1; % draw light dot into matrix
    
    % store that matrix in this ydim for Pats
    Pats(:, :, 1 , ypos) = bar_pattern; % place
    
    
end

% Make sure whole matrix is blank when x or y is max  = 0 for a blank
% screen,
Pats(:, : , pattern.x_num, pattern.y_num) = 0;

pattern.Pats = Pats; 		% put data in structure 

%pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
%pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 230 degree arena updated 10/25/17 define panel structure vector
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
% panels 19-24 are fictive and do not actually exist on hardware!

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_004_2pixelBrightHorizBar']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% LIGHT ON 4 LED wide vertical bar
%   The bar's horizontal location is encoded in x dim 
% whether the bar is on or not is encoded in y dim
%   xpos = 56 and/or y pos = 2 are the full screen dark. 

clear all;
numOfPanelsAcross = 12;%9;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

BAR_WIDTH = 4; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;

pattern.num_panels = 24;%18; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 2; 	% This pattern gray scale value

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Construct the dot patterns within each dimention
% zeros 0 = dark, ones 1 = light

% build intial bar pattern 
bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix


for xpos = 1: LEDdotsAcross - ( BAR_WIDTH - 1)
    
    % shift dot_pattern to each different location depending on current
    % x pos
    Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
    
end

% Make sure whole matrix is blank when x or y is max  = 0 for a blank
% screen,
Pats(:, : , pattern.x_num, pattern.y_num) = 0;

pattern.Pats = Pats; 		% put data in structure 

%pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
%pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 230 degree arena updated 10/25/17 define panel structure vector
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
% panels 19-24 are fictive and do not actually exist on hardware!

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_005_4pixelBrightVertBar']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern'); 
 
%% Full field illumination ydim = 1 light, y dim = 2 dark
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 4; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = 1; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Make the whole matrix of y = 1 LEDs all ON
 ONIndex = 1;
 Pats(:, : , :, ONIndex) = 1;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_006_fullFieldIllumination']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%%  <<<akm>>> 4 pixel wide grating, 8 pixel period:
 clear all;
 numOfPanelsAcross = 12;% 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 4; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 24; %18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the grating pattern in Y = 2, and all x values
 % zeros 0 = dark, ones 1 = light
 PATTERN_INDEX = 1;
 gratingWidth = 4;
 grating = zeros( 1 , LEDdotsAcross);
 
 for i = 1: LEDdotsAcross
     if( mod( i , gratingWidth * 2) < ( gratingWidth ) )
         grating(i) = 1; % add in light stripes at each of these locations
     end
 end
 
 stripe_pattern = repmat ( grating, LEDdotsVertically,  1); % extend matrix to include the whole vertical extent of the panels
 
 Pats(:, :, 1, PATTERN_INDEX) = stripe_pattern;
 
 for j = 2:LEDdotsAcross 			%use ShiftMatrixPats to rotate stripe image
     Pats(:,:,j, PATTERN_INDEX) = ShiftMatrix(Pats(:,:,j-1,PATTERN_INDEX),1,'r','y');
 end
 
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_012_4pixelGrating']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% ONE DARK bar 2 LEDs wide 
 % The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 
 clear all;
 numOfPanelsAcross = 12;% 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 24; %18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 Pats = ones(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 % build intial bar pattern
 bar_pattern = ones( LEDdotsVertically , LEDdotsAcross) ;
 bar_pattern( : , 1 : BAR_WIDTH ) = 0; % draw light dot into matrix
 
 
 for xpos = 1: LEDdotsAcross - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 1;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 230 degree arena updated 10/25/17 define panel structure vector
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_024_2pixelDarktVertBar']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% TWO LIGHT ON bars 90 DEGREES apart each 2 LED wide 
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 12;%9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 NUM_LEDS_BETWEEN_BARS = 24; % 8 LED : 30deg * 3 = 90 degrees
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 24;%18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
 bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix
 bar_pattern( : , NUM_LEDS_BETWEEN_BARS : (NUM_LEDS_BETWEEN_BARS + BAR_WIDTH - 1) ) = 1;
 
 for xpos = 1: LEDdotsAcross
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 230 degree arena updated 10/25/17 define panel structure vector
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_009_2_2pixelBars_90Deg']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% TWO LIGHT ON bars 180 DEGREES apart each 2 LED wide 
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 12; %9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 NUM_LEDS_BETWEEN_BARS = 48; % 8 LED : 30deg * 6 = 180 degrees
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 24; %18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
 bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix
 bar_pattern( : , NUM_LEDS_BETWEEN_BARS : (NUM_LEDS_BETWEEN_BARS + BAR_WIDTH - 1) ) = 1;
 
 for xpos = 1: LEDdotsAcross
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 230 degree arena updated 10/25/17 define panel structure vector
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_010_2_2pixelBars_180Deg']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
  
%% TWO LIGHT ON bars 60 DEGREES apart each 2 LED wide  
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 12; %9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 NUM_LEDS_BETWEEN_BARS = 16; % 8 LED : 30deg * 2 = 60 degrees
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 24; %18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
 bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix
 bar_pattern( : , NUM_LEDS_BETWEEN_BARS : (NUM_LEDS_BETWEEN_BARS + BAR_WIDTH - 1) ) = 1;
 
 for xpos = 1: LEDdotsAcross
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 230 degree arena updated 10/25/17 define panel structure vector
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_011_2_2pixelBars_60Deg']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% THREE LIGHT ON bars 120 DEGREES apart each 2 LED wide  
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 12; %9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 EDGE_POSITION_OF_SECOND_BAR = 33; % 8 LED : 30deg * 6 = 120 degrees
 EDGE_POSITION_OF_THIRD_BAR = 33 + 32;% 8 LED : 30deg * 4 = 120 degree
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 24; %18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
 bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix
 bar_pattern( : , EDGE_POSITION_OF_SECOND_BAR : (EDGE_POSITION_OF_SECOND_BAR + BAR_WIDTH - 1) ) = 1;
 bar_pattern( : , EDGE_POSITION_OF_THIRD_BAR : (EDGE_POSITION_OF_THIRD_BAR + BAR_WIDTH - 1) ) = 1;
 
 for xpos = 1: LEDdotsAcross
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 230 degree arena updated 10/25/17 define panel structure vector
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_013_3_2pixelBars_120Deg']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 

 
%% *MAKING PATTERNS FOR 270 DEGREE WORLD THAT WRAPS AROUND* - same as Seelig et al 2015 *****%%%
 
%% PHASE OFFSET 1: LIGHT ON dots 2 LED wide vertical bar 270 degree world!!
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 INTIAL_BAR_LOCATION = 1;
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross + 1) ;
 bar_pattern( : , INTIAL_BAR_LOCATION : (INTIAL_BAR_LOCATION + BAR_WIDTH - 1) ) = 1; % draw light dot into matrix
 
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_014_2pixelBrightVertBar_270World_phase1']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% PHASE OFFSET 2: LIGHT ON dots 2 LED wide vertical bar 270 degree world!!
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 INTIAL_BAR_LOCATION =  24; % 90 degrees from far left of the screen
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross + 1) ;
 bar_pattern( : , INTIAL_BAR_LOCATION : (INTIAL_BAR_LOCATION + BAR_WIDTH - 1) ) = 1; % draw light dot into matrix
 
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_015_2pixelBrightVertBar_270World_phase2']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% PHASE OFFSET 3: LIGHT ON dots 2 LED wide vertical bar 270 degree world!!
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 INTIAL_BAR_LOCATION =  48; % 180 degrees from far left of the screen
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross + 1) ;
 bar_pattern( : , INTIAL_BAR_LOCATION : (INTIAL_BAR_LOCATION + BAR_WIDTH - 1) ) = 1; % draw light dot into matrix
 
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_016_2pixelBrightVertBar_270World_phase3']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% TWO LIGHT ON bars 90 DEGREES apart each 2 LED wide vertical bar 270 degree world!!
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 NUM_LEDS_BETWEEN_BARS = 24; % 8 LED : 30deg * 3 = 90 degrees
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross + 1) ;
 
 bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix for 1st bar
 bar_pattern( : , NUM_LEDS_BETWEEN_BARS : (NUM_LEDS_BETWEEN_BARS + BAR_WIDTH - 1) ) = 1;% draw second bar
 
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_017_2_2pixelBars_90Deg_270World']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% TWO LIGHT ON bars 60 DEGREES apart each 2 LED wide vertical bar 270 degree world!!
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 NUM_LEDS_BETWEEN_BARS = 16; % 8 LED : 30deg * 2 = 60 degrees
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross + 1) ;
 
 bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix for 1st bar
 bar_pattern( : , NUM_LEDS_BETWEEN_BARS : (NUM_LEDS_BETWEEN_BARS + BAR_WIDTH - 1) ) = 1;% draw second bar
 
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_018_2_2pixelBars_60Deg_270World']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% Building a closed loop stimuli where part of the world is "occluded"
  
%% LEFT 90 deg of the screen is blank
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross + 1) ;
 bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix
 
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 
 FIRST_LED_NUM_TO_BLANK = 1;
 LAST_LED_NUM_TO_BLANK = 24; % 8 LED : 30deg * 3 = 90 degrees
 % make the left 90 deg of all dimentions black
 Pats(:, FIRST_LED_NUM_TO_BLANK : LAST_LED_NUM_TO_BLANK , : , :) = 0;
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_019_2pixelBrightVertBar_270World_left90Blank']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% MIDDLE 90 deg of the screen is blank
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross + 1) ;
 bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix
 
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 
 FIRST_LED_NUM_TO_BLANK = 24;
 LAST_LED_NUM_TO_BLANK = 48; % 8 LED : 30deg * 3 = 90 degrees
 % make the left 90 deg of all dimentions black
 Pats(:, FIRST_LED_NUM_TO_BLANK : LAST_LED_NUM_TO_BLANK , : , :) = 0;
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_020_2pixelBrightVertBar_270World_middle90Blank']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% RIGHT 90 deg of the screen is blank
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross + 1) ;
 bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix
 
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 
 FIRST_LED_NUM_TO_BLANK = 48;
 LAST_LED_NUM_TO_BLANK = 72; % 8 LED : 30deg * 3 = 90 degrees
 % make the left 90 deg of all dimentions black
 Pats(:, FIRST_LED_NUM_TO_BLANK : LAST_LED_NUM_TO_BLANK , : , :) = 0;
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_021_2pixelBrightVertBar_270World_right90Blank']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% DOT and square 2 object enviroment
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 1; % number of LED dots wide
 STARTING_BAR_LOCATION = 24; % 90 degrees from far left of the screen
 
 DOT_WIDTH = 4; % number of LED wide and high
 STARTING_DOT_LOCATION = 1; %
 DOT_HEIGHT_LED = 1; % place dot at the top of the screen
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 
 intialPattern = zeros( LEDdotsVertically , LEDdotsAcross + 1) ;
 % draw bar onto intial pattern
 intialPattern( : , STARTING_BAR_LOCATION : (STARTING_BAR_LOCATION + BAR_WIDTH - 1) ) = 1; % draw light dot into matrix
 
 % draw dot onto intial pattern
 intialPattern( DOT_HEIGHT_LED :(DOT_HEIGHT_LED + DOT_WIDTH - 1), STARTING_DOT_LOCATION : (STARTING_DOT_LOCATION + DOT_WIDTH - 1) ) = 1; % draw light dot into matrix
 
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (intialPattern, (xpos - 1),'r','y'); % place
     
 end
 
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_022_Dot4AndStripe1_270World']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% Pattern for Inverted Gain (-1) closed loop, 270 degree world light bar 1 LEDs wide
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 INTIAL_BAR_LOCATION = 71;
 
 % build intial bar pattern
 bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross + 1) ;
 bar_pattern( : , INTIAL_BAR_LOCATION : (INTIAL_BAR_LOCATION + BAR_WIDTH - 1) ) = 1; % draw light dot into matrix
 
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'l','y'); % place
     
 end
 
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_023_InvertedPattern_2pixelBrightVertBar_270World']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% PHASE OFFSET 1: DARK ON dots 2 LED wide vertical bar 270 degree world!!
 %   The bar's horizontal location is encoded in x dim
 % whether the bar is on or not is encoded in y dim
 %   xpos = 56 and/or y pos = 2 are the full screen dark.
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Construct the dot patterns within each dimention
 % zeros 0 = dark, ones 1 = light
 INTIAL_BAR_LOCATION = 1;
 
 % build intial bar pattern
 bar_pattern = ones( LEDdotsVertically , LEDdotsAcross + 1) ;
 bar_pattern( : , INTIAL_BAR_LOCATION : (INTIAL_BAR_LOCATION + BAR_WIDTH - 1) ) = 0; % draw dark dot into matrix
 
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
     
 end
 
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 
 % Make sure whole matrix is blank when x or y is max  = 0 for a blank
 % screen,
 Pats(:, : , pattern.x_num, pattern.y_num) = 0;
 
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_025_2pixelDarkVertBar_270World_phase1']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% PHASE OFFSET 1: Ofsted pattern 270 deg world
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Matrix of initial pattern: Ofstad 2011 inspried pattern
 initialPattern = [1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0];
 
 PHASE_SHIFT_AMOUNT = 0; % LED pixel number to shift rightward by
 % Shift pattern by desired offset
 initialPattern_shifted = circshift( initialPattern, PHASE_SHIFT_AMOUNT, 2);
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (initialPattern_shifted, (xpos - 1),'r','y'); % place
 end
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_026_OfstadPattern_phase1']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% PHASE OFFSET 2: Ofsted pattern 270 deg world
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Matrix of initial pattern: Ofstad 2011 inspried pattern
 initialPattern = [1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0];
 
 PHASE_SHIFT_AMOUNT = 24; % LED pixel number to shift rightward by
 % Shift pattern by desired offset
 initialPattern_shifted = circshift( initialPattern, PHASE_SHIFT_AMOUNT, 2);
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (initialPattern_shifted, (xpos - 1),'r','y'); % place
 end
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_027_OfstadPattern_phase2']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% PHASE OFFSET 3: Ofsted pattern 270 deg world
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Matrix of initial pattern: Ofstad 2011 inspried pattern
 initialPattern = [1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0];
 
 PHASE_SHIFT_AMOUNT = 48; % LED pixel number to shift rightward by
 % Shift pattern by desired offset
 initialPattern_shifted = circshift( initialPattern, PHASE_SHIFT_AMOUNT, 2);
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (initialPattern_shifted, (xpos - 1),'r','y'); % place
 end
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_028_OfstadPattern_phase3']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% PHASE OFFSET 1: Complex World 270 deg world
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Matrix of initial pattern: Ofstad 2011 inspried pattern
 initialPattern =[1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
 
 
 PHASE_SHIFT_AMOUNT = 0; % LED pixel number to shift rightward by
 % Shift pattern by desired offset
 initialPattern_shifted = circshift( initialPattern, PHASE_SHIFT_AMOUNT, 2);
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (initialPattern_shifted, (xpos - 1),'r','y'); % place
 end
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_029_complexWorld_phase1']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% PHASE OFFSET 2: Complex World 270 deg world
 clear all;
 numOfPanelsAcross = 9;% 7 panels across
 numOfPanelsVertically = 2;%
 LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y.
 
 BAR_WIDTH = 2; % number of LED dots wide
 
 LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; %
 LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up
 
 %Save general infomation about pattern layout
 pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
 pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;
 
 pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
 pattern.gs_val = 2; 	% This pattern gray scale value
 
 %Create a single "ghost" LED column but include an extra column in the
 %pattern and then removing it at the end of the
 Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros
 
 % Matrix of initial pattern: Ofstad 2011 inspried pattern
 initialPattern =[1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
 
 
 PHASE_SHIFT_AMOUNT = 24; % LED pixel number to shift rightward by
 % Shift pattern by desired offset
 initialPattern_shifted = circshift( initialPattern, PHASE_SHIFT_AMOUNT, 2);
 
 for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
     
     % shift dot_pattern to each different location depending on current
     % x pos
     Pats(:, :, xpos , 1) = ShiftMatrix (initialPattern_shifted, (xpos - 1),'r','y'); % place
 end
 % trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
 % the panels system"
 Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
 pattern.Pats = Pats; 		% put data in structure
 
 %pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
 pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
 %pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
 % panels 19-24 are fictive and do not actually exist on hardware!
 
 pattern.BitMapIndex = process_panel_map(pattern);
 pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
 % place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_030_complexWorld_phase2']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
%% PHASE OFFSET 3: Complex World 270 deg world
clear all;
numOfPanelsAcross = 9;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

BAR_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;

pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 2; 	% This pattern gray scale value

%Create a single "ghost" LED column but include an extra column in the
%pattern and then removing it at the end of the 
Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Matrix of initial pattern: Ofstad 2011 inspried pattern
initialPattern =[1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];


PHASE_SHIFT_AMOUNT = 48; % LED pixel number to shift rightward by
% Shift pattern by desired offset
initialPattern_shifted = circshift( initialPattern, PHASE_SHIFT_AMOUNT, 2);

for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
    
    % shift dot_pattern to each different location depending on current
    % x pos
    Pats(:, :, xpos , 1) = ShiftMatrix (initialPattern_shifted, (xpos - 1),'r','y'); % place
end
% trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
% the panels system"
Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
pattern.Pats = Pats; 		% put data in structure 

%pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
%pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
% panels 19-24 are fictive and do not actually exist on hardware!

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 % SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_031_complexWorld_phase3']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');