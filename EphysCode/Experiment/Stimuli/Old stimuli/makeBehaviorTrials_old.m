


function makeBehaviorTrials()

stim_event_duration_s=3; % total duration of the stimulus delivery period
pre_post_ISI=1; % pre/post-stimulus time 

% For no odor, set to NaN --
odor_on_s=[1 2]; 
pinch_open_s=[0.1 2.9];

% For no laser pulse, set to NaN --
laser_on_s=nan;   %[1.5 3.5]; 
laser_power_mW=nan;   %[1 1]; %For an 8 mW square pulse: [8 8], for a ramp from 0-8 mW: [0 8]


% Create event traces...
ephysSettings
zeroCommand=zeros(1,settings.sampRate*stim_event_duration_s,1);
[odor_valve_command,pinch_valve_command,laser_command]=deal(zeroCommand);

% Laser command
if ~isnan(laser_on_s)
    
    lasersamples=(laser_on_s(1)*settings.sampRate):(laser_on_s(2)*settings.sampRate);
    lasersamples(end)=[];
    laser_command(lasersamples)=linspace(laser_power_mW(1),laser_power_mW(2),length(lasersamples));
    % Rescale: mW*(5V/13mW)=V
    laser_command=laser_command*(5/13);
    
end

% Odor & pinch valve commands
if ~isnan(odor_on_s)
    
    odorsamples=(odor_on_s(1)*settings.sampRate):(odor_on_s(2)*settings.sampRate);
    odorsamples(end)=[];
    odor_valve_command(odorsamples)=1; % +1V
    
    pinchsamples=(pinch_open_s(1)*settings.sampRate):(pinch_open_s(2)*settings.sampRate);
    pinchsamples(end)=[];
    pinch_valve_command(pinchsamples)=1; % +1V
    
end

% Pad stimulus event w/ISIs
isiPeriod=zeros(settings.sampRate*pre_post_ISI,1)';
odor_valve_command=[isiPeriod odor_valve_command isiPeriod];
pinch_valve_command=[isiPeriod pinch_valve_command isiPeriod];
laser_command=[isiPeriod laser_command isiPeriod];

% Plot
figure; 
xvals=[1:length(odor_valve_command)]/settings.sampRate;
hold on; plot(xvals,odor_valve_command);
hold on; plot(xvals,pinch_valve_command);
hold on; plot(xvals,laser_command);
axis tight

% Save stimulus file
stimulus.type='behavior_trials';
stimulus.stimDur_s=pre_post_ISI+stim_event_duration_s+pre_post_ISI;
stimulus.iclamp_command=zeros(1,stimulus.stimDur_s*settings.sampRate,1); % No current steps
stimulus.odor_valve_command=odor_valve_command;
stimulus.pinch_valve_command=pinch_valve_command;
stimulus.laser_command=laser_command;

stimfilepath=settings.stimfilepath;
stimfilename=['1s_odor.mat'];
cd(stimfilepath);
save(stimfilename,'stimulus');



end