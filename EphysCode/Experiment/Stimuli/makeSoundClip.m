clear all; close all; clc

% Make tone
if 1
    
freq=300; % Hz
duration=0.5; % in seconds
fs=44100;

t=1:duration*fs;
t=t/fs;
toneClip=sin(2*pi*freq*t);

if 1
    %cosine-squared ramp
    ramp=10; % ms
    omega=(1e3/ramp)*(acos(sqrt(0.1))-acos(sqrt(0.9)));
    tt=0:1/fs:pi/2/omega;
    tt=tt(1:(end-1));
    edge=(cos(omega*tt)).^2;
    toneClip(1:length(edge))=toneClip(1:length(edge)).*fliplr(edge); %add left edge
    toneClip((end-length(edge)+1):end)=toneClip((end-length(edge)+1):end).*edge; %add right edge
end

soundClip(1,:)=toneClip;
soundClip(2,:)=toneClip;


stimfilename=sprintf('tone_%.0f_Hz_%.2f_ms.mat',freq,duration)
cd('C:\Users\amoore\AKM\EphysCode\Experiment\Stimuli\Sounds');
save(stimfilename,'soundClip','fs');

end




% Make noise burst
if 0
     
max_freq=800; 
duration=0.5; % in seconds
duration=duration+0.2; % We'll trim the first & last 100 ms of the clip
fs=44100;

noiseClip=randn(1,round(duration*fs)+1); 

% low pass filter
[b,a]=butter(3,max_freq/(fs/2));
fnoise=filtfilt(b,a,noiseClip);

% rescale
trimDur=fs*0.1;
fnoise(1:trimDur)=[];
fnoise(end-trimDur:end)=[];
fnoise=fnoise-min(fnoise);
fnoise=fnoise/max(fnoise);
fnoise=(fnoise*2)-1;


if 0
    %cosine-squared ramp
    ramp=20; % ms
    omega=(1e3/ramp)*(acos(sqrt(0.1))-acos(sqrt(0.9)));
    tt=0:1/fs:pi/2/omega;
    tt=tt(1:(end-1));
    edge=(cos(omega*tt)).^2;
    fnoise(1:length(edge))=fnoise(1:length(edge)).*fliplr(edge); %add left edge
    fnoise((end-length(edge)+1):end)=fnoise((end-length(edge)+1):end).*edge; %add right edge
end

soundClip=[fnoise;zeros(1,length(fnoise))];
% [min(soundClip(:)); max(soundClip(:))]
sound(soundClip,fs);

stimfilename=sprintf('noise_0-%.0f_Hz_%.2f_ms.mat',max_freq,length(soundClip)/fs);
cd('C:\Users\amoore\AKM\EphysCode\Experiment\Stimuli\Sounds');
save(stimfilename,'soundClip','fs');




% Plot spectrogram & power spectrum
% y=noiseClip';
% figure
% spectrogram(y(:,1),[],[],[],fs);
% spectrogram(y(:,1),[],[],[],fs,'yaxis');
% [s,f,t,P]=spectrogram(y(:,1),[],[],[],fs);
% pcolor(P)
% pcolor(log(abs(P)))
% shading flat
% xlabel('time index')
% ylabel('frequency index')
% xt=get(gca,'xtick');
% yt=get(gca,'ytick');
% set(gca,'xticklabel',t(xt))
% set(gca,'yticklabel',f(yt))
% % shg
% figure
% [Pxx,F]=pwelch(y);
% plot(F,Pxx)
% [Pxx,F]=pwelch(y,[],[],[],fs);
% plot(F,Pxx)
% set(gca,'yscale','log')

% y=fnoise';
% figure
% spectrogram(y(:,1),[],[],[],fs);
% spectrogram(y(:,1),[],[],[],fs,'yaxis');
% [s,f,t,P]=spectrogram(y(:,1),[],[],[],fs);
% pcolor(P)
% pcolor(log(abs(P)))
% shading flat
% xlabel('time index')
% ylabel('frequency index')
% xt=get(gca,'xtick');
% yt=get(gca,'ytick');
% set(gca,'xticklabel',t(xt))
% set(gca,'yticklabel',f(yt))
% shg
% figure
% [Pxx,F]=pwelch(y);
% plot(F,Pxx)
% [Pxx,F]=pwelch(y,[],[],[],fs);
% plot(F,Pxx)
% set(gca,'yscale','log')
% axis tight

end


