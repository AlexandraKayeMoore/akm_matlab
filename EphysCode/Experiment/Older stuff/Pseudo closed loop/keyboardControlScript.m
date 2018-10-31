ephysSettings;
daqreset % Reset DAC object
devID='Dev1'; % Set device ID
niOI=daq.createSession('ni');
niOI.Rate=settings.sampRate;
aO=addAnalogOutputChannel(niOI,devID,0:1,'Voltage');


% Enter => pinch opens for 3s
if 1
    
    clear outputData
    outputData(:,1)=zeros(1,settings.sampRate*3.02);
    outputData(:,2)=zeros(1,settings.sampRate*3.02);

    startSample=settings.sampRate*0.01; % 10 ms
    endSample=settings.sampRate*3.01; % end-10 ms
    
    outputData(startSample:endSample,2)=5;
            
    keyboardInput='';
    while ~strcmp(keyboardInput,'stop')
        keyboardInput=input('Enter when ready: ','s');
        niOI.queueOutputData(outputData); 
        niOI.startForeground();
    end
    outputSingleScan(niOI,[0 0]);
    fprintf('\n  ----- user input loop stopped ----- \n')

end



% Enter => 100 ms air puffs x 5 
if 0
    
    singlePulse=zeros(settings.sampRate*.3,1); % 300 ms total: 10 ms pre, 150 ms puff, 140 ms post
    startSample=settings.sampRate*0.01;  
    endSample=settings.sampRate*0.16;  
    singlePulse(startSample:endSample)=5; 
    
    
    clear outputData
    outputData(:,2)=[singlePulse];
    outputData(:,1)=outputData(:,2)*0;
            
    keyboardInput='';
    while ~strcmp(keyboardInput,'stop')
        keyboardInput=input('Enter when ready: ','s');
        niOI.queueOutputData(outputData); 
        niOI.startForeground();
    end
    outputSingleScan(niOI,[0 0]);
    fprintf('\n  ----- user input loop stopped ----- \n')

end
    




% Enter => pulse on/off
if 0   
aO=addAnalogOutputChannel(niOI,devID,0:1,'Voltage');


keyboardInput='';
lightON=0;
while ~strcmp(keyboardInput,'stop')
    if lightON==1;
        outputSingleScan(niOI,[0 0]);
        lightON=0;
        keyboardInput=input('OFF ','s');
    else
        outputSingleScan(niOI,[0 3]); % 3V=9mW
        lightON=1;
        keyboardInput=input('ON ','s');
    end
end
fprintf('\n  ----- user input loop stopped ----- \n')


end




if 0
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_001');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_002');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_003');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_004');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_005');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_006');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_007');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_008');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_009');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_010');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_011');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_012');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_013');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_014');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_015');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_016');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_017');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_018');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_019');
mkdir('C:\Users\amoore\AKM\Data\011718_002\011718_002_020');
end
