clear all
close all
clc

ephysSettings
patternsDir='C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\Patterns\';
makeFunctionsDir='C:\Users\amoore\akm_matlab\Panels\panels-matlab_071618\functions\make_function_files\';

%brightPatterns=37:54;
darkPatterns=55:72;


for panelNum=1:18
    
    panelParams=struct();
    stimulus=struct();
    
    %stimfilename=sprintf('two_bright_objects_panel_%.0f.mat',panelNum)
    stimfilename=sprintf('two_dark_objects_panel_%.0f.mat',panelNum)
    
    %panelParams.patternNum=brightPatterns(panelNum);
    panelParams.patternNum=darkPatterns(panelNum);
    
    %panelParams.path2patternfile=[ patternsDir sprintf('Pattern_%03d_two_bright_objects_panel_%.0f.mat',panelParams.patternNum,panelNum) ];
    panelParams.path2patternfile=[ patternsDir sprintf('Pattern_%03d_two_bright_objects_panel_%.0f.mat',panelParams.patternNum,panelNum) ];
    
    panelParams.positionFunctionX=45;
    panelParams.positionFunctionY=46;
    panelParams.path2fInfo=[makeFunctionsDir ...
        sprintf('fInfo_0%.0f_0%.0f.mat',panelParams.positionFunctionX,panelParams.positionFunctionY)];
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    %% Make main stimulus structure
    pre_stim_s=0.5; % time before the controller is triggered
    post_stim_s=0.5; % time after visual stimulus has ended
    
    %panelParams.initPanelPosition=[0,0];
    panelParams.initPanelPosition=[71,15];
    
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
