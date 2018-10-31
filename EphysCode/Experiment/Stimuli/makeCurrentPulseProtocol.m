function [stimfilepath,stimfilename] = makeCurrentPulseProtocol(pulseAmps,pulseDur,isi,baselineCurrent)
%% [stimfilename]=makeCurrentPulseProtocol(pulseAmps,pulseDur,isi,baselineCurrent)
% Creates a current pulse protocol, saves file to stim folder. 
% akm 6/27/174
%
% INPUT:
% pulseAmps - array of pulse amplitudes, units = pA
% pulseDur - pulse duration (1 value), units = seconds
% isi - interpulse interval (1 value), units = seconds 
% baselineCurrent - one value, units = pA (e.g. 0 to -10 pA)

% OUTPUT:
% stimfilename - string
%
% Example: makeCurrentPulseProtocol([-15:5:15],3,2,0)

clear stimulus

stimfilepath='C:\Users\amoore\akm_matlab\EphysCode\Experiment\Stimuli';


stimfilename=['CurrentPulses_' sprintf('%.0fs_blI_%.0fpA',pulseDur,baselineCurrent)];
for p=1:length(pulseAmps)
    stimfilename=[stimfilename sprintf('_%.1f',pulseAmps(p))];
end
stimfilename=[stimfilename '.mat'];

%% Create stimulus

ephysSettings;
sampRate=settings.sampRate; % 10 kHz

stimTrace=[];
for p=1:length(pulseAmps)
    thisPulse=[repmat(baselineCurrent,1,isi*sampRate) repmat(pulseAmps(p),1,pulseDur*sampRate)];
    stimTrace=[stimTrace thisPulse];
end
stimTrace=[stimTrace repmat(baselineCurrent,1,isi*sampRate)]; % Pad the end of the trial with a final isi period

% Get total recording duration in samples and seconds
stimDur_samples=length(stimTrace);
stimDur_s=stimDur_samples/sampRate;

% Convert pA to "Vout" 
axo_input=stimTrace*(1/settings.axopatch_picoAmps_per_volt);

% Convert "Vout" to "Vin" (AO to deliver from nidaq)
ao_command=axo_input/settings.AO_output_scaling_factor;


%% Plot 

figure;
plot([1:length(stimTrace)]/sampRate,stimTrace,'k');
hold on; plot([1:length(stimTrace)]/sampRate,axo_input,'r');
hold on; plot([1:length(stimTrace)]/sampRate,ao_command,'g');
title('g:aoCommand(V), r:axoInput(V), k:stim(pA)');
xlabel('s');

%% Save

stimulus.pulseAmps=pulseAmps;
stimulus.pulseDur=pulseDur;
stimulus.isi=isi;
stimulus.baselineCurrent=baselineCurrent;
stimulus.sampRate=sampRate;
stimulus.type='currentPulses';
stimulus.stimTrace=stimTrace;
stimulus.axo_input=axo_input;
stimulus.ao_command=ao_command;
stimulus.stimDur_samples=stimDur_samples;
stimulus.stimDur_s=stimDur_s;

cd(stimfilepath);
save(stimfilename,'stimulus');




end


