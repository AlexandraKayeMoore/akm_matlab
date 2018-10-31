function [outfile_fullpath]=runTrial_panels(dataDir,stimfilename)
%% [outfile_fullpath]=runTrial_panels(dataDir,stimfilename)
% Same as runTrial() except that data is acquired in the background
% so that 'start' and 'stop' commands can be sent to the panel controller
% during acquisition. 

dbstop if error;
clc;

% Load settings & stim file  
ephysSettings;
stimfilepath=settings.stimfilepath;
load([stimfilepath '\' stimfilename]);

% Create save directory, if it doesn't already exist
if ~isdir(dataDir); 
    mkdir(dataDir); 
end

cd(dataDir);


%% Configure nidaq session & add AI channels

fprintf('\n   Preparing NIdaq session...\n');

daqreset % Reset DAC object
devID='Dev1'; 
niOI=daq.createSession('ni');
niOI.Rate=settings.sampRate;
% niOI.DurationInSeconds=stimulus.stimDur_s; 

aI=addAnalogInputChannel(niOI,devID,settings.bob.inChannelsUsed,'Voltage'); % Defaults
for i=1:length(settings.bob.inChannelsUsed)
    aI(i).InputType=settings.bob.aiType;
end 

% A DataAvailable EVENT occurs when a specific amount of data is available 
% to the session. A listener can respond to that event and initiate a 
% specified function.

% Create the file log.bin and open it. You will write the acquired 
% data to this file in binary format. Save the file identifier in the 
% variable fid1.

fid1 = fopen('log.bin','w');

% Use addlistener to add an anonymous function to the session.
% This function is called every time the DataAvailable event occurs, 
% and logs the acquired data to a file. By default this listener is
% called 10 times per second.

lh = addlistener(niOI,'DataAvailable',@(src, event)logData(src, event, fid1));

% You can change how often the listener is called by modifying the 
% NotifyWhenDataAvailableExceeds property. The listener will be called 
% when the number of points accumulated exceeds this value. We'll change
% it to 1 second.

niOI.NotifyWhenDataAvailableExceeds = settings.sampRate;


%% Prepare panels

if strcmp(stimulus.type,'visual_stim')
    
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
    pause(0.3); Panel_com('set_position', [72 16]);%init_pos); % offset the position functions.
    
end

%% Run session

niOI.IsContinuous=true; % Acquire data continuously in the background until you explicity call 'stop'

% Start acquisition
niOI.startBackground;
fprintf('\n    -- Session has started --\n')

% Start panels
pause(0.3); 
Panel_com('start'); 

pause(stimulus.stimDur_s); 

% Stop panels
Panel_com('stop'); 
pause(0.3); 

% Stop acquisition
niOI.stop;
delete(lh);
delete(niOI);
fclose(fid1); 
Panel_com('all_off'); 
fprintf('\n    -- Session has stopped --\n')


%% Read in data from the log file

fprintf('\n    Saving data... --\n')

fid2 = fopen('log.bin','r');
[loggedData,count] = fread(fid2,[length(aI)+1,inf],'double');
fclose(fid2);

t_seconds=loggedData(1,:);
rawData=loggedData(2:end,:);
rawData=rawData';
clear loggedData



%% Process ephys data

data.t_s=t_seconds;

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




%% Save to .mat file

% Determine outfilename - this'll be the name of the data folder
% plus the next available outfile number.

cd(dataDir);
folderName=strsplit(dataDir,'\');
folderName=folderName{end};
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

% Save new data file
outfilename=sprintf('daqout_%s_%03.f.mat',folderName,nextFileNum);
save(outfilename,'settings','stimulus','rawData','data','trialMeta');
fprintf('\n\n    ''%s'' was successfully saved.\n',outfilename);
delete 'log.bin'; % Delete binary log file
outfile_fullpath=[dataDir '\' outfilename];



end