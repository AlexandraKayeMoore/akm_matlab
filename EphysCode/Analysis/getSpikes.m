function outfilename=getSpikes(filepath,filename,detect_thresh,exclude_thresh,monitor)
% getSpikes(), akm 6/21/17
% Input:
%    filepath, filename -- location & name of daqout file
%    detect_thresh, exclude_thresh -- threshold in |mV| for spike detection & exclusion; detect_thresh must be < exclude_thresh
%    monitor -- display plots, y/n
% Output:
%    outfilename -- name of outfile w/spiketimes
% e.g. getSpikeData('...\062717_001','daqout_062717_001_007',0.2,0.9,1)

cd(filepath)
in=load(filename);
samprate=in.settings.sampRate;

if strcmp(in.trialMeta.mode,'V-Clamp') 
    % Presumably in cell-attached mode...
    scaledtrace=in.data.current;
    fprintf('\nExtracting spikes from current trace: %s', filename);
    fprintf('\n-----------------------------');
    unitString='pA';
    
    % High pass filter
    high_pass_cutoff=10; % Hz
    fprintf('\nHigh-pass filtering at %d Hz', high_pass_cutoff);
    [b,a]=butter(1,high_pass_cutoff/(samprate/2), 'high');
    filteredtrace=filtfilt(b,a,scaledtrace);
    
else
    scaledtrace=in.data.voltage; % presumably in current clamp or i=0
    fprintf('\nExtracting spikes from voltage trace: %s', filename);
    fprintf('\n-----------------------------');
    unitString='mV';
    
    % High pass filter
    high_pass_cutoff=10; % Hz
    fprintf('\nHigh-pass filtering at %d Hz', high_pass_cutoff);
    [b,a]=butter(1,high_pass_cutoff/(samprate/2), 'high');
    filteredtrace=filtfilt(b,a,scaledtrace);
    
end

t_sec=[1:length(in.data.voltage)]/in.settings.sampRate;
refract_sec=0.005; % ms refractory period, for now (based on DANs in mammals)
refract_samples=refract_sec*samprate;


%% Extract spikes

% Apply inclusion threshold
nstd=abs(detect_thresh/std(filteredtrace));
fprintf('\nUsing detection threshold of %.2f mV (%.2f SD)',...
    detect_thresh,nstd(1));
spikes=find(abs(filteredtrace)>detect_thresh); % in samples


% Apply refractory period
fprintf('\nUsing refractory period of %.1f ms (%d samples)',1000*refract_sec,refract_samples);
dspikes=spikes(1+find(diff(spikes)>refract_samples));
try dspikes=[spikes(1) dspikes'];
catch
    fprintf('\n***dspikes is empty; either the cell never spiked or the nstd is set too high.***n'); return
end
dspikes(1)=[]; dspikes(end)=[]; % exclude first and last spikes


% Get spike snippets & apply exclusion threshold
spike_snippets=zeros(length(dspikes),2*refract_samples);
exspikes=[];
for d=1:length(dspikes)
    t_snippet=[1+dspikes(d)-refract_samples : dspikes(d)+refract_samples];
    thisSpike=filteredtrace(t_snippet);
    if max(abs(thisSpike))>=exclude_thresh % Exclude if > exclusion voltage
        exspikes=[exspikes d];
    elseif length( find(abs(thisSpike)>detect_thresh) ) < 3 % Exclude if <3 samples in duration
        exspikes=[exspikes d];
    else % Save trace snippet
        spike_snippets(d,:)=thisSpike;
    end
end
dspikes(exspikes)=[]; % Remove excluded events
spike_snippets(exspikes,:)=[];
fprintf('\nnspikes=%.0f\n\n',length(dspikes))

spiketimes_samples=dspikes; % Function output

%% Plot, if requested

if monitor
    
    figure
    
    % 1. overlaid snippets
    subplot(2,1,2)
    for sp=1:size(spike_snippets,1)
        hold on; plot(squeeze(spike_snippets(sp,:)),'k')
    end
    hold on; line([1 refract_samples*2],[detect_thresh detect_thresh])
    hold on; line([1 refract_samples*2],[-detect_thresh -detect_thresh])
    axis tight; axis square; grid on
    xlabel('samples')
    ylabel(unitString)
    set(gca,'fontname','Franklin Gothic Book')
    
    % 2. filtered trace, thresh lines, symbols for spikes/exspikes/dspikes
    subplot(2,1,1)
    plot(filteredtrace,'k')
    hold on; plot(detect_thresh+zeros(size(filteredtrace)),'--')
    hold on; plot(spikes,detect_thresh*ones(size(spikes)),'g*','color',rgb('slategrey'))
    hold on; plot(dspikes,detect_thresh*ones(size(dspikes)),'r*')
    axis tight; grid on
    xlabel('samples')
    ylabel(unitString)
    set(gca,'fontname','Franklin Gothic Book')
    h=title(sprintf('%s - %.0f spikes (%.3f mV, %.1f SD)',...
        filename,length(dspikes),detect_thresh,nstd),...
        'interpreter','none');
    set(h,'fontname','Franklin Gothic Book','fontweight','normal','fontangle','italic')
    set(gcf,'color',[1 1 1]);
    
end

%% Save outfile
out.detect_thresh=detect_thresh;
out.exclude_thresh=exclude_thresh;
out.spiketimes_samples=spiketimes_samples;
out.high_pass_cutoff=high_pass_cutoff;
out.refract_samples=refract_samples;
out.t_sec=t_sec;

outfilename=strrep(filename,'daqout','spiketimes');
save(outfilename,'out');


end