function plotSealTestPulses(dataDir,outfilename,calcStr)
% Loads data file and calculates pipette reistance. akm 6/27/17
% calcStr:'bath', 'seal', or 'wholecell'
%
% -example-
%     dataDir='C:\Users\A. K. Moore\Desktop\akmLabTemp\Data\...'
%     outfilename='10x_10kHz_40kHz_capComped.mat'
%     plotSealTestPulses(dataDir,outfilename,'wholecell')

V_per_mV=1/1e3; 
A_per_pA=1/1e12; 
MOhm_per_Ohm=1/1e6; 

cd(dataDir)
load(outfilename)
if ~strcmp(stimulus.type,'record_seal_test'); keyboard; end
current=data.scaledCurrent;
voltage=data.voltage;

if strcmp(trialMeta.mode,'V-Clamp')
    
fprintf('\n      %s',outfilename) 
fprintf('\n      V = %.1f mV',mean(data.voltage))
 
    
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

clear pulseTraces pulseTraces_upsampled vPulse R_in R_series R_steady
pulsecounter=1;

for i=3:npulses-3 % Skip the first few/last pulses
    
    traceStart=voltageStepUpInd(i)-100; % pad before the positive step
    traceStop=traceStart+expectedPulseDur;
    
    thisTrace=zeroedCurrent(traceStart:traceStop);
    thisStep=data.voltage(traceStart:traceStop);
    
    % Store traces for each pulse
    vPulse(:,pulsecounter)=thisStep;
    pulseTraces(:,pulsecounter)=thisTrace;
    pulseTraces_upsampled(:,pulsecounter)=interp(thisTrace,10);  
    
    pulsecounter=pulsecounter+1;
    
end

meanPulseResponse=median(pulseTraces_upsampled,2); % Changed from mean to median, 9/21/18
meanPulseResponse=resample(meanPulseResponse,1,10);
meanVPulse=mean(vPulse,2);

% Trim traces
meanPulseResponse=meanPulseResponse(20:end-20);
meanVPulse=meanVPulse(20:end-20);
pulseTraces=pulseTraces(20:end-20,:);

figure
for p=1:size(pulseTraces,2)
    hold on; plot(pulseTraces(:,p),'color',rgb('slategray'));
end
hold on; line([0 length(meanPulseResponse)],[0 0],'linestyle',':','color','k')
hold on; plot(meanPulseResponse,'color',rgb('crimson'),'linewidth',1.5);


if strcmp(calcStr,'wholecell')
    % Calculate:
    %   R_series (MOhms): inst. V/I, calc. using the transient
    %   (charging) current through Rpipette + Raccess immediately
    %   after the voltage step. R_series is equal to the sum of
    %   R_pipette & R_access.
    %   R_t (MOhms): total resistance, deltaV/deltaI, @ steady
    %   state. R_t is equal to the sum of R_in & R_s.
    %   R_in (MOhms): input resistance of the cell, from Rin=R_t-R_s
    %   This determines how much the cell depolarizes in response
    %   to a steady current, or, how much current is required to
    %   maintain a certain voltage @ ss.
    
    [maxI,max_tp]=max(meanPulseResponse);
    temp=meanPulseResponse;
    temp(1:max_tp)=nan;
    [minI,min_tp]=min(temp);
    clear temp
    
    % I/R values
    ssEnd=min_tp-10;
    ssStart=ssEnd-round((min_tp-max_tp)*0.25);
    Iss=median(meanPulseResponse(ssStart:ssEnd));
    Ipeak=maxI;
    Ipre=median(meanPulseResponse(5:max_tp-5));
    deltaV=5; % height of v pulse, in mV
    R_series=([deltaV*V_per_mV]/[(Ipeak-Ipre)*A_per_pA])*MOhm_per_Ohm; % MOhms
    R_in=([deltaV*V_per_mV]/[(Iss-Ipre)*A_per_pA])*MOhm_per_Ohm; % MOhms
   fprintf('\n      R_series = %.1f MOhm',R_series);
   fprintf('\n      R_in = %.1f MOhm',R_in);
    
    axis tight
    axis square
    set(gca,'xlim',[1 min_tp+max_tp],...
        'xtick',[])
    ylabel('pA')
    title(outfilename,'interpreter','none','fontsize',11,'FontAngle','italic','FontWeight','normal')
    text(ssStart,Ipeak*.75,sprintf('R_{series} %.1f MOhm',R_series))
    text(ssStart,Ipeak*.5,sprintf('R_{in} %.1f MOhm',R_in))
    text(ssStart,Ipeak*.25,sprintf('V %.1f mV',mean(data.voltage)))
    
    
elseif strcmp(calcStr,'seal') || strcmp(calcStr,'bath')
    
    [maxI,max_tp]=max(meanPulseResponse);
    temp=meanPulseResponse;
    temp(1:max_tp)=nan;
    [minI,min_tp]=min(temp);
    clear temp
    
    % Get R_steady from steady state I
    ssEnd=min_tp-10;
    ssStart=ssEnd-round((min_tp-max_tp)*0.25);
    Iss=median(meanPulseResponse(ssStart:ssEnd));
    Ipre=median(meanPulseResponse(5:max_tp-5));
    Ipeak=maxI;
    deltaV=5; % height of voltage pulse in mV
    
    R_peak=([deltaV*V_per_mV]/[(Ipeak-Ipre)*A_per_pA])*MOhm_per_Ohm; % MOhms
    R_steady=([deltaV*V_per_mV]/[(Iss-Ipre)*A_per_pA])*MOhm_per_Ohm; % MOhms
    fprintf('\n      R_peak = %.1f MOhm\n\n',R_peak);
    fprintf('\n      R_steady = %.1f MOhm\n\n',R_steady);
    
    axis tight
    box off
    ylabel('pA, minus I_{hold}')
    set(gca,'xtick',[],'fontsize',11)
    yl=max(get(gca,'ylim'));
    title(outfilename,'interpreter','none','FontAngle','italic','FontWeight','normal')
    
    text(max_tp+40,yl*.5,sprintf('R_peak   %.1f MOhm',R_peak),'interpreter','none','fontsize',11);
    text(max_tp+40,yl*.4,sprintf('R_steady   %.1f MOhm',R_steady),'interpreter','none','fontsize',11);
    text(max_tp+40,yl*.25,sprintf('V_cmd   %.1f mV',mean(data.voltage)),'interpreter','none','fontsize',11);
    text(max_tp+40,yl*.15,sprintf('I_hold   %.1f pA',holdingCurrent),'interpreter','none','fontsize',11);

end


hold on; plot(max_tp,meanPulseResponse(max_tp),'ro')
hold on; plot(min_tp,meanPulseResponse(min_tp),'ro')
axis tight

set(gcf,'color',[1 1 1],'position',[1890 550 660,520]); 

set(gca,'xlim',[(max_tp-80) (min_tp+80)],'position',[0.095 0.1 0.88 0.8])


% figName=['sealtest_' strrep(outfilename,'.mat','')];
% savefig(figName);



else % If mode ~= v-clamp...
    fprintf('\n      >>>>> No voltage pulses to plot! <<<<<\n')
end



end



