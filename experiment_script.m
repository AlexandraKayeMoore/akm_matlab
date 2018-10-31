
clc
dataDir='D:\data_main\103018_002';
stimFolder='C:\Users\amoore\akm_matlab\EphysCode\Experiment\Stimuli';
imDir_temp='C:\tmp';
try cd(dataDir); catch; mkdir(dataDir); cd(dataDir); end



%% Seal test pulses
if 1
    
    bfig=figure;
    set(bfig,'position',[2190 1190 335 135])
    
    % Wait until start button is pressed...
    GB=uicontrol('Style','PushButton','String','Start ST','Callback',...
        'delete(GB)');
    set(GB,'fontsize',12,'position',[37 36 258 65],'backgroundcolor',...
        rgb('seagreen'),'foregroundcolor',[1 1 1]);
    waitfor(GB);
    
    % Then rec. seal test pulses until stopped
    SB=uicontrol('Style','PushButton','String','Stop ST','Callback',...
        'delete(SB)');
    set(SB,'fontsize',12,'position',[37 36 258 65],'backgroundcolor',...
        rgb('firebrick'),'foregroundcolor',[1 1 1]);
    while (ishandle(SB))
        stpFile=recordSealTest_500ms(dataDir); % stpFile=recordSealTest_1s(dataDir);
        try plotSealTestPulses(dataDir,stpFile,'bath'); catch; close; end
    end
    close(bfig)
    fprintf('\n\n\n\n  --- ST finished ---\n\n\n\n')

    % clear_ST_files(dataDir)

end


%% No stimulus, just recording spont. activity
if 0
    
    %stimfilename='no_stimulus_120s.mat';
    stimfilename='no_stimulus_60s.mat';
    %stimfilename='no_stimulus_3s.mat';
    runTrial(dataDir,stimfilename,0);
    
end

 
%% Current Injection
if 0  
    
    % Confirm that:
    %  * MODE=i-clamp
    %  * EXTCMD=on
    %  * LP=5kHz
    
    stimfilename='CurrentPulses_1s_blI_0pA_-3.0_-2.0_-1.0_1.0_2.0_3.0.mat'
    runTrial(dataDir,stimfilename,0);
    
    
    % Old stimuli for big cells:
    %stimfilename='CurrentPulses_1s_blI_0pA_-25.0_-20.0_-15.0_-10.0_-5.0_0.0_5.0_10.0_15.0_20.0_25.0.mat'
    %stimfilename='CurrentPulses_1s_blI_0pA_10.0_20.0_30.0_40.0_50.0.mat';
    %stimfilename='CurrentPulses_3s_blI_0pA_10.0_20.0_30.0_40.0.mat'
    
end


%% Visual stimuli
if 0
    
    % stimfilename='bright_bar_2px.mat'; % (3 reps/stim, 1 minute)
    % stimfilename='bright_bar_4px.mat';
    % stimfilename='dark_bar_4px.mat';
    
    % stimfilename='FF_flashes_200ms_1000ms.mat'; % (4 reps/duration, 1 minute)

     %stimfilename='flash_locations_8x8_bright.mat'; % (4 reps/location, 4 minutes)
     %stimfilename='flash_locations_8x8_dark.mat';
    if 0
        dfile=dir('daqout*'); dfile=dfile(end).name;
        efile=strrep(dfile,'daqout','events');
        plotScaledData(dataDir,dfile,[]); close;
        plotEventResponses_flashLocations(dataDir,dfile,efile,-25,3);
    end
    
    % stimfilename='two_bright_objects_panel_11.mat';
    % stimfilename='two_dark_objects_panel_11.mat';
    
    % stimfilename='elevation_scan_4x4_bright.mat'; % (3 reps/stim, 4 minutes)
    % stimfilename='elevation_scan_4x4_dark.mat';
    
    % stimfilename='bright_obj_looming_50fps.mat'; %  (3 reps/stim, 1 minute)
    % stimfilename='dark_obj_looming_50fps.mat';
    

    runTrial_panels(dataDir,stimfilename); 
    pause(3);
    
    
    


    
    
    
    
 
    
    
    
    %Panel_com('stop');
    %pause(1);
    %Panel_com('all_off');
    
    
end






