function [stimfilepath,stimfilename] = makeLaserPulseProtocol(laserPulseAmps,currentPulseAmps,pulseDur,isi)

%% [stimfilename]=makeLaserPulseProtocol(currentPulseAmps,pulseDur,isi)

% Creates a laser pulse protocol & saves stim file to
% C:\Users\AKM\MATLAB_AKM\EphysCode\Experiment\Stimuli.
% 
% INPUT:
%   laserPulseAmps - array of laser pulse amplitudes, in mW. 
%   currentPulseAmps - array of current pulse amplitudes, units = pA. (For no
%   current pulses, just enter zeros.)
%   pulseDur - pulse duration (1 value), units = seconds
%   isi - interpulse interval (1 value), units = seconds 
% OUTPUT:
%   stimfilename - string
% Example: makeLaserPulseProtocol([5 5 5],[0 10 0],3,6)



if length(laserPulseAmps)~=length(currentPulseAmps)
   fprintf('/n Number of pulse amps does not match number of current amps. /n')
   dbstop
end

clear stimulus
stimfilepath='C:\Users\AKM\MATLAB_AKM\EphysCode\Experiment\Stimuli';
stimfilename=['laserPulses_' sprintf('dur%.0fs_isi%.0fs_',pulseDur,isi) sprintf('%.0f_',laserPulseAmps) 'mW_'...
    sprintf('%.0f_',currentPulseAmps) 'pA.mat'];

ephysSettings;
sampRate=settings.sampRate; % 10 kHz


%% Create laser pulse stimulus


laserTrace=[];
for p=1:length(laserPulseAmps)
    thisPulse=[repmat(0,1,isi*sampRate) repmat(laserPulseAmps(p),1,pulseDur*sampRate)];
    laserTrace=[laserTrace thisPulse];
end
laserTrace=[laserTrace repmat(0,1,isi*sampRate)]; % Pad the end of the trial with a final isi period

% Convert mW to output voltage
V_per_mW=5/15; % +5V command = max power (15 mW)
laser_command=laserTrace*V_per_mW;


%% Create i-clamp stimulus

currentTrace=[];
for p=1:length(currentPulseAmps)
    thisPulse=[repmat(0,1,isi*sampRate) repmat(currentPulseAmps(p),1,pulseDur*sampRate)];
    currentTrace=[currentTrace thisPulse];
end
currentTrace=[currentTrace repmat(0,1,isi*sampRate)]; % Pad the end of the trial with a final isi period

% Get total recording duration in samples and seconds
stimDur_samples=length(currentTrace);
stimDur_s=stimDur_samples/sampRate;

% Convert pA to "Vout" 
axo_input=currentTrace*(1/settings.axopatch_picoAmps_per_volt);

% Convert "Vout" to "Vin" (AO to deliver from nidaq)
ao_command=axo_input/settings.AO_output_scaling_factor;


%% Plot 

figure;
plot([1:length(currentTrace)]/sampRate,currentTrace,'k');
plot([1:length(laserTrace)]/sampRate,laserTrace,'r');
title('k=current(pA) r=laser(mW)');
xlabel('s');

%% Save
stimulus.laserPulseAmps=laserPulseAmps;
stimulus.currentPulseAmps=currentPulseAmps;
stimulus.pulseDur=pulseDur;
stimulus.isi=isi;
stimulus.sampRate=sampRate;
stimulus.type='laser_pulses';
stimulus.laserTrace=laserTrace;
stimulus.currentTrace=currentTrace;
stimulus.axo_input=axo_input;
stimulus.ao_command=ao_command;
stimulus.laser_command=laser_command;
stimulus.stimDur_samples=stimDur_samples;
stimulus.stimDur_s=stimDur_s;

cd(stimfilepath);
save(stimfilename,'stimulus');




end


