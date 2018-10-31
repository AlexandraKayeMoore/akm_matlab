
function makePanelStimulus()

clc; dbstop if error

ephysSettings
patternsDir='C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns\';
makeFunctionsDir='C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\functions\make_function_files\';

panelParams=struct();
stimulus=struct();

% ************************ Variables to specify ***************************

stimfilename='inverted_FF_flashes_200ms_1000ms.mat';

panelParams.patternNum=31;
panelParams.path2patternfile=[ patternsDir 'Pattern_031_flash_whole_screen.mat' ];

panelParams.positionFunctionX=49;
panelParams.positionFunctionY=50;
panelParams.path2fInfo=[makeFunctionsDir sprintf('fInfo_0%.0f_0%.0f.mat',panelParams.positionFunctionX,panelParams.positionFunctionY)];

% *************************************************************************





pre_stim_s=0.5; % time before the controller is triggered
post_stim_s=0.5; % time after visual stimulus has ended

%panelParams.initPanelPosition=[0,0];
panelParams.initPanelPosition=[71,15]; 

%% Make main stimulus structure

stimulus.type='visual_stim';
stimulus.panelParams=panelParams;

% Compute the total duration of the trial
load(panelParams.path2fInfo); 
stimulus.stimDur_s=ceil(fInfo.totalDur_s); 

% No current steps or laser pulses...
zeroCommand=zeros(1,settings.sampRate*stimulus.stimDur_s,1);
stimulus.iclamp_command=zeroCommand; 
stimulus.laser_command=zeroCommand; 

% Make trigger pulse for the controller 
stimulus.controller_start_trigger=nan; 


%% Save file

stimfilepath=settings.stimfilepath;
cd(stimfilepath);
save(stimfilename,'stimulus');
fprintf('\n     Done!')
fprintf('\n     Saved stimulus file ''%s'' to directory:',stimfilename)
fprintf('\n    ''%s''\n',stimfilepath)





end







