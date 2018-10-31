function [gain,freq,mode]=getAmpState(in)
% getAmpState:
% Get a single sample from all ai channels & decode telegraph output. 
% Returns current gain, freq, and mode 
% akm 7/5/17

daqreset % Reset DAC object
devID='Dev1'; % Set device ID
niOI=daq.createSession('ni');
niOI.Rate=10e3;
niOI.DurationInSeconds=1;
aI2=addAnalogInputChannel(niOI,devID,in.inChannelsUsed,'Voltage');
for i=1:length(aI2); aI2(i).InputType=in.aiType; end

singleSample=niOI.inputSingleScan;
niOI.stop
delete(niOI)

gainIndex = find(in.inChannelsUsed == in.gainCh); % get index of gain Ch.
freqIndex = find(in.inChannelsUsed == in.freqCh); % get index of freq Ch.
modeIndex = find(in.inChannelsUsed == in.modeCh); % get index of Mode Ch.

[gain,freq,mode]=decodeTelegraphedOutput(singleSample,gainIndex,freqIndex,modeIndex);

clear singleSample


end

