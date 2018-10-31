function measureStpNoise(dataDir,outfilename)
% Measures noise in ST pulse files. 7/26/18 akm
% example:
%   stpFile=recordSealTest_1s(dataDir);
%   plotSealTestPulses(dataDir,stpFile,'bath'); 
%   measureStpNoise(dataDir,stpFile);




%% Load data, extract pulses

V_per_mV=1/1e3; 
A_per_pA=1/1e12; 
MOhm_per_Ohm=1/1e6; 

cd(dataDir)
load(outfilename)
if ~strcmp(stimulus.type,'record_seal_test'); keyboard; end
current=data.scaledCurrent;
voltage=data.voltage;


% Solve for holding current (in pA)
holdingCurrent=mean(current);
% Subtract holding current
zeroedCurrent=current-holdingCurrent;

% Find out when the voltage is above (1) or below (0)
% the mean value, i.e. where it steps between +2.5 and -2.5 mV
pulseOn=voltage>mean(voltage);
% Extract the indexes where voltage steps Up or Down
voltageStepUpInd=find(diff(pulseOn)==1);
voltageStepDownInd=find(diff(pulseOn)==-1);

% Splice up the trace into 'pulse frames' - step up, then step down:
% Find first step up
if voltageStepDownInd(1) < voltageStepUpInd(1)
    voltageStepDownInd(1)=[];
end

lengthOfShorterArray=min([length(voltageStepUpInd),length(voltageStepDownInd)]);
npulses=lengthOfShorterArray;
npulses=npulses-mod(npulses,10);
voltageStepUpInd=voltageStepUpInd(1:npulses);
voltageStepDownInd=voltageStepDownInd(1:npulses);

% Get expected pulse duration, in samples
% 1/60 seconds/pulse (line freq) * samples/second = samples/pulse
% ...this is the time between positive steps, i.e. 1 full period, so we divide it by 2.
expectedPulseDur=ceil(1/60*stimulus.sampRate);

clear pulseTraces vPulse R_in R_series R_steady
pulsecounter=1;
for i=3:npulses-3 % Skip the first few/last pulses
    traceStart=voltageStepUpInd(i)-100; % pad before the positive step
    traceStop=traceStart+expectedPulseDur;
    thisTrace=zeroedCurrent(traceStart:traceStop);
    thisStep=data.voltage(traceStart:traceStop);
    % Store current trace for each pulse
    pulseTraces(:,pulsecounter)=thisTrace;
    vPulse(:,pulsecounter)=thisStep;
    pulsecounter=pulsecounter+1;
end




%% Measure noise

% • Get samples from the middle of the voltage step
% • Subtract the mean & report the variance

midStep_scaledCurrent=pulseTraces(150:350,:);
midStep_scaledCurrent=[midStep_scaledCurrent(:)];
midStep_scaledCurrent=midStep_scaledCurrent-mean(midStep_scaledCurrent);

midStep_voltage=vPulse(150:350,:);
midStep_voltage=[midStep_voltage(:)];
midStep_voltage=midStep_voltage-mean(midStep_voltage);


fprintf('\n\n Stp file: %s',outfilename)

fprintf('\n\n   rms scaled current = %.2f pA',rms(midStep_scaledCurrent))
fprintf('\n   variance scaled current = %.2f pA\n',var(midStep_scaledCurrent))

fprintf('\n   rms voltage = %.2f mV',rms(midStep_voltage))
fprintf('\n   variance voltage = %.2f mV\n\n',var(midStep_voltage))


end




