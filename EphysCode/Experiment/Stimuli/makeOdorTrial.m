
function makeOdorTrial()

trial_duration_s=6+3+6; %  total duration of the trial
odor_on_s=[6 9]; % odor start/stop time
odorId='odor_A'; % string - 'odor_A' or 'odor_B'

dbstop if error
ephysSettings

% Create empty traces
zeroCommand=zeros(1,settings.sampRate*trial_duration_s,1);
A_valve_command=zeroCommand;
B_valve_command=zeroCommand;
odorsamples=(odor_on_s(1)*settings.sampRate):(odor_on_s(2)*settings.sampRate);
odorsamples(end)=[];

% Make odor valve command
if strcmp(odorId,'odor_A')
    A_valve_command(odorsamples)=1; % +1V
elseif strcmp(odorId,'odor_B')
    B_valve_command(odorsamples)=1;  
else
    keyboard
end

% Plot
figure; 
xvals=[1:length(B_valve_command)]/settings.sampRate;
hold on; plot(xvals,B_valve_command);
hold on; plot(xvals,A_valve_command);
axis tight

% Save stimulus file
stimulus.type='behavior_trials';
stimulus.stimDur_s=trial_duration_s;
stimulus.A_valve_command=A_valve_command;
stimulus.B_valve_command=B_valve_command;
stimulus.iclamp_command=zeroCommand; % No current steps
stimulus.laser_command=zeroCommand; % No IR laser

stimfilepath=settings.stimfilepath;
stimfilename=sprintf('%s_%.1f_s.mat',...
    odorId,odor_on_s(2)-odor_on_s(1));
cd(stimfilepath);
save(stimfilename,'stimulus');



end