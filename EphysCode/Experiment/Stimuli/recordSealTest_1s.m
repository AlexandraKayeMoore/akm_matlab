function [outfilename]=recordSealTest_1s(dataDir)
%% [outfilename]=recordSealTest(dataDir)
% akm, 7/3/17
% ***Add description!***
% INPUT:
%   dataDir - data folder for this fly, e.g. 'C:\Users\AKM\MATLAB_AKM\Data\062517_001' (6/25/17, fly #1)
% OUTPUT:
%   outfilepath - full path to data file


dbstop if error;


% Load settings file
ephysSettings; 

% Create save directory, if it doesn't already exist
if ~isdir(dataDir); mkdir(dataDir); end

% Check to make sure the LPF is set to 100kHz:
[amp_gain,amp_freq,amp_mode]=getAmpState(settings.bob);
if amp_freq~=10
    fprintf('\n\n      ***Open filter to 10 kHz! Hit enter to continue.***\n\n')
    anystring=input('');
end

stimulus.type='record_seal_test';
stimulus.sampRate=40e3;
stimulus.duration_s=1; 
stimulus.duration_samples=stimulus.duration_s*stimulus.sampRate;
fprintf('\n\n      Starting sealtest (%.1f s)...',stimulus.duration_s)


%% Configure nidaq session

daqreset % Reset DAC object
devID='Dev1'; % Set device ID
niOI=daq.createSession('ni');
niOI.Rate=stimulus.sampRate;
niOI.DurationInSeconds=stimulus.duration_s;

% Add analog input channel (scaled output)
aI=addAnalogInputChannel(niOI,devID,...
    [settings.bob.voltCh settings.bob.scalCh],'Voltage');
for i=1:length(aI)
    aI(i).InputType=settings.bob.aiType;
end



%% Start trial

rawData=niOI.startForeground(); % Aquire AI data for trialDur_s of time
trialMeta.trialStartTime = datestr(now,'HH:MM:SS');
niOI.stop
fprintf('\n      Done.')
delete(niOI)


%% Scale data and save ephys data file
% Assumes voltage is rawData(:,1) and scaled current is rawdata(:,2)

% Check amplifier state again
[trialMeta.scaledOutput.gain,trialMeta.scaledOutput.freq,trialMeta.mode]...
    =getAmpState(settings.bob);

% V pulse channel
data.voltage = settings.voltage.gainFactor .* rawData(:,1); % mV

% Scaled output channel
data.scaledCurrent=nan;
data.scaledVoltage=nan;
switch trialMeta.mode % (scaled output)
    % Voltage Clamp
    case {'Track','V-Clamp'}
        trialMeta.scaledOutput.softGain = 1000 / (trialMeta.scaledOutput.gain * settings.betaProduct);
        data.scaledCurrent = trialMeta.scaledOutput.softGain .* rawData(:,2); % mV
    % Current Clamp
    case {'I=0','I-Clamp Normal','I-Clamp Fast'}
        trialMeta.scaledOutput.softGain = 1000 / ( trialMeta.scaledOutput.gain);
        data.scaledVoltage = trialMeta.scaledOutput.softGain .* rawData(:,2); % pA   
end




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
        fName=strsplit(fName(1:end-4),'_'); % last 4 characters = ".mat"
        existingfilenumbers(f)=str2num(fName{end});
        nextFileNum=max(existingfilenumbers)+1;
    end
end
    
outfilename=sprintf('daqout_%s_%03.f.mat',folderName,nextFileNum);
save(outfilename,'stimulus','rawData','data','trialMeta');
fprintf('\n      Saved file ''%s''\n\n',outfilename)
outfile_fullpath=[dataDir '\' outfilename];

% Plot a snippet
% figure; 
% title(outfilename);
% plot([data.scaledCurrent(1:5e3)]);
% yl=get(gca,'ylim');
% axis tight
% set(gca,'ylim',yl)
% grid on




end
