function makeLaserPulseTrain()

% Make laser pulse train

trial_duration_s=15+3+25; % total duration of the trial
laser_on_s=[15.75 17.75]; % [start stop] for pulse train
pulse_width_s=0.150;
IPI_s=0.200;


dbstop if error
ephysSettings

% Create blank command
zeroCommand=zeros(1,settings.sampRate*trial_duration_s,1);
laser_command=zeroCommand;

% Make the pulse train
pulseTrain=zeros(1,settings.sampRate*diff(laser_on_s),1);
pulse_period_samples=settings.sampRate*(pulse_width_s+IPI_s);
pulse_onsets=1:pulse_period_samples:length(pulseTrain);

for p=1:length(pulse_onsets)
    % first pulse starts @ sample 1
    % next pulse starts @ "pulse_width+IPI" samples
    % etc.
    pulseStart=pulse_onsets(p);
    pulseStop=pulseStart+(settings.sampRate*pulse_width_s);
    pulseTrain(round([pulseStart:pulseStop]))=5;
end

laser_on_samples=(laser_on_s(1)*settings.sampRate):(laser_on_s(2)*settings.sampRate);
try
    laser_command(laser_on_samples)=pulseTrain;
catch
    laser_on_samples(end)=[];
    laser_command(laser_on_samples)=pulseTrain;
end

% Plot
figure;
xvals=[1:length(laser_command)]/settings.sampRate;
hold on; plot(xvals,laser_command);
axis tight
set(gcf,'Position',[15 50 600 600])


% Save stimulus file
stimulus.type='behavior_trials';
stimulus.stimDur_s=trial_duration_s;
stimulus.A_valve_command=zeroCommand; % No odor
stimulus.B_valve_command=zeroCommand;
stimulus.iclamp_command=zeroCommand; % No current steps
stimulus.laser_command=laser_command;


stimfilepath=settings.stimfilepath;
stimfilename=sprintf('IR_pulses_%.0f_ms_%.0f_ms.mat',...
    pulse_width_s*1000,IPI_s*1000);
cd(stimfilepath);
existingFile=dir(stimfilename);

if ~isempty(existingFile)
    confirmationStr=input('\n\n   -- File name already exists -- \n\n','s');
else
    save(stimfilename,'stimulus');
end




end

