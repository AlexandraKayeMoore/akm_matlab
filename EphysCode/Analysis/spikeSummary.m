function [isi_sec,FR_Hz,Icmd,medV,Vcmd,medI]=spikeSummary(dataDir,spikeFile)

cd(dataDir)

% Load spike file
load(spikeFile);
spikes_in=out;
clear out;

% Load data file
daq_in=load(strrep(spikeFile,'spiketimes','daqout'));

% Median membrane potential or holding current

[medV,medI,Vcmd,Icmd]=deal(nan);

if isnan(daq_in.data.scaledVoltage) % in iclamp mode
    medI=median(daq_in.data.current);
    Vcmd=median(daq_in.data.voltage);
end

if isnan(daq_in.data.scaledCurrent); % in vclamp mode
    medV=median(daq_in.data.voltage);
    Icmd=median(daq_in.data.current);
end

% Get ISI in ms
isi_samples=diff(spikes_in.spiketimes_samples);
all_isi_sec=isi_samples*(1/daq_in.settings.sampRate);
isi_sec.median=median(all_isi_sec);
isi_sec.iqr=[prctile(all_isi_sec,25) prctile(all_isi_sec,75)];
% figure;
% histogram(all_isi_sec,[0:0.001:1])
% set(gcf,'position',[290 100 860 540]);


% Get Hz (spikes in file / file duration in sec)
file_dir_sec=length(daq_in.data.voltage)*(1/daq_in.settings.sampRate);
FR_Hz=length(spikes_in.spiketimes_samples)/file_dir_sec;






end