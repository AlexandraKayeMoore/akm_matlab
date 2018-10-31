%% Script for denoising the rig -- 072618 akm
% Goal: as good as, or better than...
% rms scaled current = 5.33 pA (10/31/17, 9.5 mohm)
% rms scaled current = 5.82 pA (04/02/18, 8.8 mohm)

clear all; close all; clc
dataDir='D:\data_main\072618_001';
stimFolder='C:\Users\amoore\akm_matlab\EphysCode\Experiment\Stimuli';
imDir_temp='C:\tmp';
try cd(dataDir); catch; mkdir(dataDir); cd(dataDir); end

stpFile=recordSealTest_1s(dataDir);
% plotSealTestPulses(dataDir,stpFile,'bath');
% clc; 
measureStpNoise(dataDir,stpFile);

%% Notes 

% 005 = nothing on, cage not grounded, r_pipette = 15 mohm
% rms scaled current = 5.45 pA
% variance scaled current = 29.69 pA
% rms voltage = 0.03 mV

% 009 = arena power on, cage not grounded
% rms scaled current = 2021.54 pA
% variance scaled current = 4087066.90 pA
% rms voltage = 0.03 mV

% cage grounded to base plate
% 6.70 pA

% cage grounded to base plate
% wire sheild grounded to rack
% 6.55 pA

% cage grounded to base plate
% wire sheild grounded to power supply case
% 6.43 pA

% cage grounded to base plate
% power supply plugged in to *top* power strip 
% 6.42 pA

% cage grounded to base plate
% power supply plugged in to *bottom* power strip
% 6.37 pA

%% Notes, cont. 
% 
% >>> power supply grounding doesn't matter...
% >>> wiresheild grounded to axopatch / main ground
% 
% 
% arena powered off
% 5.22 pA
% 
% arena powerd *ON* 
% 6.30 +/- 0.10 pA
% 
% arena connected to controller enclosure (power off)
% 5.88 pA
% 
% controller power on, all LEDs off (or on)
% 4.90 pA +/- 0.10 pA
% 






















if 0 % past experiments
    
    dataDir='D:\data_main\040218_001';
    stpFile='daqout_040218_001_001.mat';
    measureStpNoise(dataDir,stpFile)
    plotSealTestPulses(dataDir,stpFile,'bath')
    
end

















