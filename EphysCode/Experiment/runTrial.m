function [outfile_fullpath]=runTrial(dataDir,stimfilename,flyCam)
%% [outfilename]=runTrial(dataDir,stimfilename,flyCam)
% Basic aquisition function. Loads and delivers a stimulus file.
% Records, rescales, and saves data from the analog input channels 
% specified in ephysSettings. 4/10/17 akm
%   INPUT:
%     dataDir - data folder for this fly, e.g. 'C:\Users\AKM\MATLAB_AKM\Data\062517_001' (6/25/17, fly #1)
%     stimfilename - stimulus file to load; directory=settings.stimfilepath
%     flyCam - record fly camera video (0/1)
%   OUTPUT:
%     outfile_fullpath - full path to outfile '062517_001_00X'

dbstop if error;

% Load settings  
ephysSettings;

% Load stim file
stimfilepath=settings.stimfilepath;
cd(stimfilepath);
load(stimfilename);

% Create save directory, if it doesn't already exist
if ~isdir(dataDir); mkdir(dataDir); end
cd(dataDir);


%% Configure nidaq session

fprintf('\n   Preparing NIdaq session...\n');

daqreset % Reset DAC object
devID='Dev1'; % Set device ID
niOI=daq.createSession('ni');
niOI.Rate=settings.sampRate;
niOI.DurationInSeconds=stimulus.stimDur_s; % Record for a few more seconds than we actually need to...

% Add AI channels
aI=addAnalogInputChannel(niOI,devID,settings.bob.inChannelsUsed,'Voltage'); % Defaults
for i=1:length(settings.bob.inChannelsUsed)
    aI(i).InputType=settings.bob.aiType;
end



clear outputData

% Add AO channels and outputData
%  — axopatch commands will be delivered from channel 0 ('DAC0OUT')
%  — panel trigger (previously laser pulses) will be delivered from channel 1 ('DAC1OUT')
aO=addAnalogOutputChannel(niOI,devID,0:1,'Voltage');
try
    outputData(:,1)=stimulus.iclamp_command;
    outputData(:,2)=stimulus.laser_command;
catch % If these fields don't exist, just deliver zeros
    outputData(:,1)=stimulus.ao_command;
    outputData(:,2)=zeros(1,length(stimulus.ao_command));
end

if 0 % strcmp(stimulus.type,'visual_stim') < Now using a separate function (runTrial_panels) for acquision with visual stimuli
    % Panel controller trigger (+5 V)
    if max(stimulus.controller_start_trigger)==1
        stimulus.controller_start_trigger=stimulus.controller_start_trigger*5;
    end
    outputData(:,2)=stimulus.controller_start_trigger;
    % Note — INT3 on the controller board corresponds to 
    % pin 18 on the back of the enclosure:
    %  +lead = 6th pin on the bottom row, counting from the left 
    %  -lead = last pin on the bottom row, counting from the left
end

% Add DO channels and outputData
if strcmp(stimulus.type,'behavior_trials')
    % dio 0=odor valve A
    % dio 1=odor valve B
    niOI.addDigitalChannel(devID,'port0/line0','OutputOnly');
    niOI.addDigitalChannel(devID,'port0/line1','OutputOnly');
    outputData(:,3)=stimulus.A_valve_command;
    outputData(:,4)=stimulus.B_valve_command;
end




%% Set up fly/ball camera, if requested
if flyCam 
    
    fprintf('   Preparing flyCam...\n');

    % First make sure there are no image files in the temp folder
      cd(settings.camTempDir)
      existingFiles=dir('fc2_save*');
      if ~isempty(existingFiles);
          keyboard
      end
    
    % Set up camera trigger output
    cameraTrigOut=zeros(1,length(stimulus.iclamp_command));
    triggerInterval=round(settings.sampRate / settings.camRate);
    cameraTrigOut(1:triggerInterval:end)=1;   % Trigger the camera once every "triggerInterval" seconds
    
    % Set up digital output channel (dio 3) for camera trigger
    niOI.addDigitalChannel(devID, 'port0/line2', 'OutputOnly');
    outputData(:,size(outputData,2)+1)=cameraTrigOut;
    settings.cameraTrigOut=cameraTrigOut; % Save a copy of the command to the settings structure
    
end




%% Prepare to start trial

% Queue data
niOI.queueOutputData(outputData); 


if 0 % strcmp(stimulus.type,'visual_stim') < Now using a separate function (runTrial_panels) for acquision with visual stim 
    
    fprintf('   Preparing panels...\n');
    
    panelParams=stimulus.panelParams;
    
    Freq = 50; % There is a report that Freq should be multiple of 50 to avoid freezing.
    xfid = panelParams.positionFunctionX; % id of x position function
    yfid = panelParams.positionFunctionY; %  id of y position function
    Pattern_id = panelParams.patternNum; % pattern id
    init_pos = panelParams.initPanelPosition; % [71 15];
    
    pause(0.3); Panel_com('set_funcx_freq' , Freq);
    pause(0.3); Panel_com('set_posfunc_id', [1, xfid]);
    pause(0.3); Panel_com('set_funcy_freq' , Freq);
    pause(0.3); Panel_com('set_posfunc_id', [2, yfid]);
    pause(0.3); Panel_com('set_mode', [4 4]); % both x and y are using mode 4
    pause(0.3); Panel_com('send_gain_bias', [0 0 0 0]);
    
    pause(0.3); Panel_com('set_pattern_id', Pattern_id);
    pause(0.3); Panel_com('set_position', init_pos); % offset the position functions.
    pause(0.3); Panel_com('enable_extern_trig'); % Tell the system to wait for an external trigger before starting
    
end


%% Start trial

trialMeta.trialStartTime=datestr(now,'HH:MM:SS');

fprintf('\n\n Starting trial (%.1f s)...',stimulus.stimDur_s);

rawData=niOI.startForeground(); % Start session. Aaquire data for trialDur_s of time...

niOI.stop; % ...and then stop the session.

if 0 % strcmp(stimulus.type,'visual_stim') 
    pause(0.3); Panel_com('stop'); % Stop the panels
    pause(0.3); Panel_com('all_off'); 
end

outputSingleScan(niOI,outputData(1,:)*0); % Re-zero output voltages

delete(niOI);

fprintf('\n\n Trial complete. Saving data...')

%% Save ephys data file

gainIndex=find(settings.bob.inChannelsUsed == settings.bob.gainCh); % get index of gain Ch.
freqIndex=find(settings.bob.inChannelsUsed == settings.bob.freqCh); % get index of freq Ch.
modeIndex=find(settings.bob.inChannelsUsed == settings.bob.modeCh); % get index of Mode Ch.

% Current and voltage channels
data.voltage=settings.voltage.gainFactor .* rawData(:,settings.bob.voltCh + 1); % mV
data.current=settings.current.gainFactor .* rawData(:,settings.bob.currCh + 1); % pA

% Scaled output channel
[trialMeta.scaledOutput.gain,trialMeta.scaledOutput.freq,trialMeta.mode]=...
    decodeTelegraphedOutput(rawData,gainIndex,freqIndex,modeIndex);
data.scaledCurrent=nan;
data.scaledVoltage=nan;
switch trialMeta.mode % (scaled output)
    % Voltage Clamp
    case {'Track','V-Clamp'}
        trialMeta.scaledOutput.softGain=1000 / (trialMeta.scaledOutput.gain * settings.betaProduct);
        data.scaledCurrent=trialMeta.scaledOutput.softGain .* rawData(:, settings.bob.scalCh + 1);  %mV
        % Current Clamp
    case {'I=0','I-Clamp Normal','I-Clamp Fast'}
        trialMeta.scaledOutput.softGain=1000 / ( trialMeta.scaledOutput.gain);
        data.scaledVoltage=trialMeta.scaledOutput.softGain .* rawData(:, settings.bob.scalCh + 1);  %pA
end

% Time trace, in s and ms
data.t_ms=[1:length(data.current)]/settings.sampRate;
data.t_s=data.t_ms/1000;


% Determine outfilename - this'll be the name of the data folder
% plus the next available outfile number.
cd(dataDir)
% Get folder name
folderName=strsplit(dataDir,'\');
folderName=folderName{end};
% Get next file number
existingFiles=dir('daqout_*');
if isempty(existingFiles);
    nextFileNum=1;
else
    for f=1:length(existingFiles)
        fName=existingFiles(f).name;
        fName=strsplit(fName(1:end-4),'_'); % last 4 characters=".mat"
        existingfilenumbers(f)=str2num(fName{end});
        nextFileNum=max(existingfilenumbers)+1;
    end
end

outfilename=sprintf('daqout_%s_%03.f.mat',folderName,nextFileNum);
save(outfilename,'settings','stimulus','rawData','data','trialMeta');
fprintf('\n\n    ''%s'' was successfully saved.\n',outfilename)
outfile_fullpath=[dataDir '\' outfilename];


%% Move image files from temp directory to data directory

if flyCam==1
           
    imageOutFolder=strrep(outfilename(1:end-4),'daqout','vidout');
    
    cd(settings.camTempDir)
    framesRequested=length(find(cameraTrigOut>0.5)); % Check to make sure the camera saved the expected number of pictures
    framesSaved=length(dir('*.tif'));
    imFiles=dir('*.tif');
    
    if framesRequested~=framesSaved
        
        fprintf('\n\nWarning! Number of frames saved')
        fprintf('\ndoes not match number requested!')
        fprintf('\n********************',framesRequested,framesSaved)
        fprintf('\nFrames requested: %.0f\nFrames saved: %.0f\n\n',framesRequested,framesSaved)       
        
    end
        
    % Move any images in the temp directory to a 
    % new folder in dataDir:
    
    mkdir(dataDir,imageOutFolder)
    
    for f=1:length(imFiles);
        movefile(imFiles(f).name,[dataDir '\' imageOutFolder]);
    end
    
    fprintf('\n\n    %.0f frames were successfully saved.\n\n',framesSaved)
    
end

cd(dataDir)


end

