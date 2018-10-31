
%% ephysSettings
% Specifies hard-coded parameters for ephys acquisition including data
% directory path and axopatch parameters. 
% AKM 3/7/18, last updated 7/27/18

settings=struct();

% Set paths
comptype=computer; % String describing computer type
settings.mainDataDir='D:\data_main';
settings.stimfilepath='C:\Users\amoore\akm_matlab\EphysCode\Experiment\Stimuli';

% Devices and sampling rates
settings.devID='Dev1';
settings.sampRate=10e3; 
settings.betaProduct=1; % beta front x beta rear (hardcoded!)

settings.camRate=80;
settings.camTempDir='C:\tmp\';

%% NI breakout board channel assignment
settings.bob.currCh=0; % I (x10 on conditioner)
settings.bob.voltCh=1; % 10*V (x10 on conditioner)
settings.bob.scalCh=2; % Scaled output -- units = gain knob x 1 (alpha x beta)
settings.bob.modeCh=3;
settings.bob.gainCh=4;
settings.bob.freqCh=5;
% 7/27/18: Adding channels to record the X-pos and Y-pos signals (0-10V) 
% from the visual panels ("DAC0" and "DAC1" on the controller enclosure)
settings.bob.panelDAC0X = 6;
settings.bob.panelDAC1Y = 7;

settings.bob.inChannelsUsed =[0:7];
settings.bob.aiType='SingleEnded'; % As opposed to 'differential' on the BOB - keep singleEnded.

%% Current and voltage signal settings

% ---------------- Current & voltage input settings ----------------

mV_per_volt=1000; pA_per_nA=1000; % Conversion factors 

settings.current.sigCond.Ch=1; % "A"
settings.current.sigCond.gain=5;
settings.current.sigCond.freq=5000;
settings.current.gainFactor=mV_per_volt * settings.betaProduct * (1/settings.current.sigCond.gain);

% raw signal * settings.current.gainFactor=actual value

% Sanity check: In I-clamp mode, I'm delivering 
% Icmd=-100pA (axopatch display). The output of the LPF-202a 
% is set to 10X, so the raw current recorded by the computer=-1V. 
% Working backwards: -1V * { 1000mV/V * 1pA/mV * 1/10 }=-100pA

settings.voltage.sigCond.Ch=2; % "B"
settings.voltage.sigCond.gain=5;
settings.voltage.sigCond.freq=5000;
settings.voltage.gainFactor=(mV_per_volt/10) * settings.betaProduct * (1/settings.voltage.sigCond.gain); % To get voltage in mV

% Sanity check: In v-clamp mode, I'm delivering Vcmd=+10 mV (axopatch display).
% The output of the LPF-202A is set to a gain of 5X, so the raw voltage
% (V10) recorded by the computer=+500mV
% Working backwards: +0.5V * { (1000mV/V / 10) * 1mV/mV * 1/5 }=+10mV



%% External command settings
settings.bob.outChannelsUsed=[0 1]; % Specify analog output channels (0='DAC0OUT', 1='DAC1OUT')



% External commands to Axopatch ("front switched")

% Scaling factors with *no* voltage divider:

% voltage clamp mode -
%   "20 mV/V", +1 V input produces +20 mV
%   input voltage range of -10 to +10 V produces -1000 to +1000 mV
settings.axopatch_mV_per_volt=20/1; % 20 mV / 1 V 

% current clamp mode -
%    "2 / (beta nA/V)" & beta = 1 nA/V
%    +1 V produces 2 nA (2000 pA)
%    input voltage range of -10 to +10 V produces -20 to +20 nA (-20,000 to +20,000 pA) 
settings.axopatch_picoAmps_per_volt=2000/1;


% If want to use -10 to +10 V (AO command) to inject -100 to +100 pA of current, 
% we need to scale the output of the daq board by a factor of 100/20,000=0.0050.
% voltage divider configuration is here:
% http://www.falstad.com/circuit/circuitjs.html?cct=$+1+0.000005+10.20027730826997+63+10+62%0Ar+288+336+288+256+0+4700%0Aw+288+256+368+160+0%0Aw+288+256+288+160+0%0Aw+288+96+288+64+0%0Aw+160+336+160+272+0%0Ag+432+96+464+64+0%0Aw+288+160+288+96+0%0AR+160+272+160+224+0+0+40+1+0+0+0.5%0Aw+160+336+160+400+0%0Aw+160+400+288+400+0%0Ar+288+400+288+336+0+4700%0Ar+368+160+400+128+0+22%0Ar+400+128+432+96+0+22%0A
settings.AO_output_scaling_factor=0.00466;


% ...
% required_V=maxCurrent*volts_per_picoamp=50*(1/2000)=0.025V; % axopatch should recieve -0.05 to +0.05 V 
% 10V*(1/400)=0.02V 

% Vout={R2/(R1+R2)}*Vin
% R2=390; %Ohm
% R1=180e3; %Ohm
% settings.AO_voltage_divider=R2/(R1+R2); % 0.0022, range = +/-43 pA






















%% AB's settings (BNC-2090 with conditioning)
if 0

% Samp Rate
settings.sampRate.out=40E3;
settings.sampRate.in=10E3;

% Camera frame rate 
settings.camRate=30; 

% Break out box 
settings.bob.currCh=0;
settings.bob.voltCh=1;
settings.bob.scalCh=2;
settings.bob.gainCh=3;
settings.bob.freqCh=4;
settings.bob.modeCh=5;
settings.bob.speakerCommandCh=6;
settings.bob.piezoSGReading=7;
settings.bob.aiType='SingleEnded';
settings.bob.inChannelsUsed =[0:7];

% Current input settings
settings.current.betaRear=1; % Rear switch for current output set to beta=100mV/pA
settings.current.betaFront=1; % Front swtich for current output set to beta=.1mV/pA
settings.current.sigCond.Ch=1;
settings.current.sigCond.gain=10;
settings.current.sigCond.freq=5;
settings.current.softGain=1000/(settings.current.betaRear * settings.current.betaFront * settings.current.sigCond.gain);

% Voltage input settings
settings.voltage.sigCond.Ch=2;
settings.voltage.sigCond.gain=10;
settings.voltage.sigCond.freq=5;
settings.voltage.softGain=1000/(settings.voltage.sigCond.gain * 10); % To get voltage in mV

% Pulse settings
settings.sampRate.out=40E3;
settings.pulse.Amp=0.0394/2; % Made pulse a bit smaller 
settings.pulse.Dur=1;
settings.pulse.Start=1*settings.sampRate.out + 1;
settings.pulse.End=2*settings.sampRate.out;

end

%% YF's settings (BNC-2090a without conditioning)
if 0
    

% Break out box 
% Panel channels added 2/2017 channels to record the X-pos and Y-pos coming from the Panel
% - DAC0: voltage proportional to current frame number (in the unit of volt) in mode 1, 2, 3, 4, and PC dumping mode of channel x, update analog output in mode 5 (debugging function generator) of channel x;
% - DAC1: voltage proportional to current frame number (in the unit of volt) in mode 1,2,3, 4, and PC dumping mode of channel y , update analog output in mode 5 (debugging function generator) of channel y;
settings.bob.currCh=0;
settings.bob.voltCh=1;
settings.bob.scalCh=2;
settings.bob.gainCh=3;
settings.bob.freqCh=5;
settings.bob.modeCh=6;
settings.bob.panelDAC0X=7;
settings.bob.panelDAC1Y=8;
settings.bob.aiType='SingleEnded'; % as opposed to 'differential' on the BOB, keep singleEnded.
settings.bob.inChannelsUsed =[0:3,5:8];
    
% Current input settings - no signalCond at the moment:
settings.current.betaRear=1; % Rear switch for current output set to beta=1 mV/pA
settings.current.betaFront=1; % Front switch (CONFIG) for current output set to beta=1 mV/pA
%settings.current.sigCond.Ch=1;
%settings.current.sigCond.gain=1;
%settings.current.sigCond.freq=5; %kHz
settings.current.softGain=MiliVOLTS_PER_VOLT/(settings.current.betaRear * settings.current.betaFront); % converted into pA and mV since 1pA/mV

% Voltage input settings - I am not using the signal conditioner currently:
%settings.voltage.sigCond.Ch=2;
%settings.voltage.sigCond.gain=1;
%settings.voltage.sigCond.freq=5; %kHz
settings.voltage.amplifierGain=10; % set to 10 mV for scaled output coming out of the back of the amplifier
settings.voltage.softGain=MiliVOLTS_PER_VOLT/(settings.voltage.amplifierGain); % To get voltage in mV

% Pulse settings
settings.sealTest.Dur=2; % Pipette, seal, access Resistance measurement period (s)
settings.cellAttached.Dur=60; % Cell attached V-clamp mesurements (s)
% For I-clamp:
settings.pulse.Amp= -3; %5 % changed from pA 0.0394/2 on 9/2/16
settings.pulse.Dur=0.8; % seconds, DO NOT MAKE LARGER THAN spacerDur (changed from 0.5 to 0.8 on 11/2/16)
settings.pulse.spacerDur=2; %seconds
%settings.pulse.Start=1*settings.sampRate.out+1;
%settings.pulse.End=2*settings.sampRate.out;
% For V-clamp:
settings.voltagePulse.Amp=5; %mv
settings.voltagePulse.Dur=0.5; %seconds
settings.voltagePulse.spacerDur=2; %seconds

% Digital Voltage output settings -- not sure why 
%settings.daq.voltageDividerScaling=0.0598; % voltage divider conversion factor, voltage divider cuts the voltage by a factor of 0.0598
settings.daq.voltageDividerScaling=1; % voltage divider removed from back of amplifier on 11/2
settings.daq.currentConversionFactor=1 / (2000 * settings.current.betaFront * settings.daq.voltageDividerScaling); % V/pA   1 volt goes to 2 nA aka 2000 pA  
settings.daq.frontExtScale=20 / 1000; %20mV/ 1000mV (1V) amplifier cuts the voltage down by this factor, every 1volt from the DAQ is 20mV into the Axopatch
settings.daq.voltageConversionFactor= 1 / (settings.daq.frontExtScale * settings.daq.voltageDividerScaling * MiliVOLTS_PER_VOLT); % use this for votlage clamp experiment commands 
%1 Volt=2nA * Beta (1 normally)




end








