function SealTest(varargin)

global exper pref
persistent ai2 ao2 dio2 DataCh GainCh ModeCh ph pw samples fig curaxes curline curpoint
persistent RunningH RsH RtH aoSampleRate



if nargin > 0
    if isobject(varargin{1})
        action = 'freerun';
    else
        action = lower(varargin{1});
    end
else
    action = lower(get(gcbo,'tag'));
    if isempty(action)
        action = 'freerun';
    end
end

% fprintf('\n%s', action)
set(fig, 'name', ['sealtest: ', action])


switch action
    case 'init'
        ModuleNeeds(me,{'ai','ao','patchpreprocess'});
        SetParam(me,'priority','value', GetParam('patchpreprocess','priority')+1);

        fig = ModuleFigure(me);
        set(fig,'DoubleBuffer','on','Position',[360 460 600 500]);

        v_height=-10;
        InitParam(me,'v_height','value',v_height,...
            'ui','edit','units','normal','pos',[0.1 0.002 0.08 0.04]);
        v_width=30;
        InitParam(me,'v_width','value',v_width,'range',[26 Inf],...
            'ui','edit','units','normal','pos',[0.28 0.002 0.08 0.04],'save',1);

        i_height=-100;
        InitParam(me,'i_height','value',i_height,...
            'ui','edit','units','normal','pos',[0.1 0.042 0.08 0.04]);
        i_width=30;
        InitParam(me,'i_width','value',i_width,'range',[26 Inf],...
            'ui','edit','units','normal','pos',[0.28 0.042 0.08 0.04],'save',1);

        uicontrol('parent',fig,'string','in','tag','zoomin','fontname','Arial',...
            'fontsize',12,'fontweight','bold',...
            'units','normal','position',[0.6 0.08 0.1 0.123],'enable','on',...
            'style','pushbutton','callback',[me ';']);

        uicontrol('parent',fig,'string','out','tag','zoomout','fontname','Arial',...
            'fontsize',12,'fontweight','bold',...
            'units','normal','position',[0.7 0.08 0.1 0.123],'enable','on',...
            'style','pushbutton','callback',[me ';']);

        uicontrol('parent',fig,'string','center','tag','center','fontname','Arial',...
            'fontsize',12,'fontweight','bold',...
            'units','normal','position',[0.8 0.08 0.1 0.123],'enable','on',...
            'style','pushbutton','callback',[me ';']);

        % Boxes for displaying the resistance.
        uicontrol(fig,'tag','Rt text','style','text','fontsize',16,'fontweight','bold',...
            'string','Rt = ','FontName','Arial',...
            'units','normal','pos',[0.1 0.92 0.1 0.06]);
        RtH=uicontrol(fig,'tag','Rt','style','text','fontsize',16,'fontweight','bold',...
            'string',0,'FontName','Arial',...
            'units','normal','pos',[0.2 0.92 0.2 0.06]);
        uicontrol(fig,'tag','Rs text','style','text','fontsize',16,'fontweight','bold',...
            'string','Rs = ','FontName','Arial',...
            'units','normal','pos',[0.6 0.92 0.1 0.06]);
        RsH=uicontrol(fig,'tag','Rs','style','text','fontsize',16,'fontweight','bold',...
            'string',0,'FontName','Arial',...
            'units','normal','pos',[0.7 0.92 0.2 0.06]);

        %create grid checkbox
        n=2;
        InitParam(me,'Grid','string','Grid','value',0,'ui','togglebutton','pref',0,'label',0,'units','normal',...
            'backgroundcolor',[0.2 0.3 0.8],'foregroundcolor',[1 1 1],'fontweight','bold','pos',[0.45 0.002 0.15 0.08]);
        if getparam(me,'grid')
            grid on;
        end

        %create autoscale checkbox
        n=1;
        InitParam(me,'Autoscale','string','Autoscale','value',1,'ui','togglebutton','pref',0,'label',0,'units','normal',...
            'backgroundcolor',[0 1 1],'foregroundcolor',[0 0 1],'fontname','Arial','fontsize',12,'fontweight','bold','pos',[0.45 0.082 0.15 0.123]);

        %create whitenoise checkbox
        InitParam(me,'Whitenoise','string','Whitenoise','value',0,'ui','togglebutton','pref',0,'label',0,'units','normal','enable','off',...
            'backgroundcolor',[0.2 0.3 0.8],'foregroundcolor',[1 1 1],'fontweight','bold','pos',[0.60 0.002 0.15 0.08]);

        % Now get all channels we need
        % NOTE: related channels should correspond to the same indices in
        % related variables, ie DataChannels(1), ModeChannels(1),
        % GainChannels(1), CommandChannels(1), etc.
        % get all the data channels
        dataChannels=GetChannel('ai','datachannel-patch');
        InitParam(me,'DataChannels','value',[dataChannels.number]);
        InitParam(me,'DataChannelNames','value',{dataChannels.name});
        dataChannelColors={dataChannels.color};
        InitParam(me,'DataChannelColors','value',dataChannelColors);
        nChannels=length(dataChannels);
        InitParam(me,'nChannels','value',nChannels);
        modeChannels=GetChannel('ai','modechannel');
        InitParam(me,'ModeChannels','value',[modeChannels.number]);
        gainChannels=GetChannel('ai','gainchannel');
        InitParam(me,'GainChannels','value',[gainChannels.number]);

        % get the command channels
        commandChannels=GetChannel('ao','commandchannel');
        InitParam(me,'CommandChannels','value',[commandChannels.number]);

        % Initialize some DAQ objects for freely running mode.
        oldai=daqfind('type','Analog Input','tag',me);
        if isempty(oldai)
            ai2=InitDAQAI;
        else
            ai2=oldai{1};
        end
        set(ai2,'tag',me);

        oldao=daqfind('type','Analog Output','tag',me);
        if isempty(oldao)
            ao2=InitDAQAO;
        else
            ao2=oldao{1};
        end
        set(ao2,'tag',me);

        olddio=daqfind('type','Digital IO','tag',me);
        if isempty(olddio)
            dio2=InitDAQDIO;
        else
            dio2=olddio{1};
        end
        set(dio2,'tag',me);

        % Axes
        curaxes=axes('units','normal','position',[0.1 0.28 0.8 0.64]);
        ylabel('Response');
        xlabel('Time');

        fig = findobj('type','figure','tag',me);
        h=plot(0,0);
        if getparam(me,'grid')
            grid on;
        end

        curline=zeros(1,nChannels);
        hold on;
        for channel=1:nChannels
            curline(channel)=line([0 1],[0 0],'Color',dataChannelColors{channel},'Parent',curaxes,'Visible','off','LineWidth',1);
            set(curline(channel),'ButtonDownFcn',[me '(''axesbuttondown'');']);
        end
        set(curline(1),'Visible','on');

        % create the run button based on number of channels
        if nChannels>1
            RunningH = uicontrol('style','togglebutton','string','Run',...
                'callback',[me ';'],'tag','run','fontname','Arial',...
                'fontsize',14,'fontweight','bold','backgroundcolor',[0 1 0],...
                'units','normal','pos',[0.1 0.082 0.35 0.123]);
            channelButtons=zeros(1,nChannels);
            bSize=0.35/nChannels;
            for channel=1:nChannels
                bPos=0.1+(channel-1)*bSize;
                channelButtons(channel)=uicontrol('Style','togglebutton','units','normal','tag','channelbutton',...
                    'value',0,'backgroundcolor',dataChannelColors{channel},'pos',[bPos 0.205 bSize 0.04],...
                    'ForegroundColor',[1 1 1],'CallBack',[me '(''channelbutton'');'],'FontWeight','bold');
            end
            set(channelButtons(1),'value',1,'String','On');
            for channel=1:nChannels
                cButtons=channelButtons;
                cButtons(channel)=[];
                set(channelButtons(channel),'userdata',cButtons);
            end
            InitParam(me,'ChannelButtons','value',channelButtons);
        else
            RunningH = uicontrol('style','togglebutton','string','Run',...
                'callback',[me ';'],'tag','run','fontname','Arial',...
                'fontsize',14,'fontweight','bold','backgroundcolor',[0 1 0],...
                'units','normal','pos',[0.1 0.082 0.35 0.123]);
        end

        set(curaxes,'ButtonDownFcn',[me '(''axesbuttondown'');']);


    case 'reset'
        Mode=GetParam('patchpreprocess','mode');

        commandChannels=GetParam(me,'CommandChannels');
        commandChannels=commandChannels(:)';    % make it a row vector
        AOSampleRate=AO('getsamplerate')/1000;

        for oneChannel=1:length(commandChannels)
            switch Mode{oneChannel}
                case {'Track','V-Clamp'}
                    % Because 20 mV/V, divide by 20.
                    ph=GetParam(me,'v_height');
                    pw=GetParam(me,'v_width');
                    phScaled=ph/20;
                case {'I=0','I-Clamp Normal','I-Clamp Fast'}
                    % Because 2/beta nA/V = 2000/beta pA/V, scale.
                    % Assumes beta = 1. Figure out what I should do.
                    ph=GetParam(me,'i_height');
                    pw=GetParam(me,'i_width');
                    phScaled=ph/(2000);
            end

            % Create and send step waveform.
            %     CommandCh=GetChannel('ao','commandchannel');
            %     CommandCh=CommandCh.number;

            % 20041124 - isn't needed anymore
            %         CommandCh=daqfind(exper.ao.daq, 'hwchannel', commandChannels(oneChannel));
            %         CommandCh=CommandCh{1}.Index;
            %         samples=zeros(size(exper.ao.data{1}(:,CommandCh)));
            %         pulseinds=ceil([0.5 1.5]*pw*AOSampleRate);
            %         samples(pulseinds(1):pulseinds(2))=phScaled;
            %         AO('setchandata',CommandCh,samples);
        end

    case 'close'
        if exist('ao2','var') & ~isempty(ao2)
            stop(ao2);
            delete(ao2);
        end
        if exist('ai2','var') & ~isempty(ai2)
            stop(ai2);
            delete(ai2);
        end
        if exist('dio2','var') & ~isempty(dio2)       %modified by Lung-Hao Tai
            stop(dio2);
            delete(dio2);
        end
        SendEvent('esealtestoff',[],me,'all');
        clear ai2 ao2 dio2 DataCh GainCh ModeCh samples ph pw fig curaxes curline RunningH RsH RtH

    case 'getready'
        fig=findobj('type','figure','name',me);
        set(findobj('type','uicontrol','tag','run','parent',fig),'enable','off');
        set(findobj('type','uicontrol','tag','channelbutton','parent',fig),'enable','off');

    case 'trialend'
        fig=findobj('type','figure','name',me);
        set(findobj('type','uicontrol','tag','run','parent',fig),'enable','on');
        set(findobj('type','uicontrol','tag','channelbutton','parent',fig),'enable','on');

        % Now for its own modes.
    case 'run'
        % Set the button to red or green to indicate whether running.
        %     RunningH=findobj('type','uicontrol','tag','run');

        Running=get(RunningH,'value');
        if Running
            eval([ me '(''reset'');' ]);
            set(RunningH,'backgroundcolor',[1 0 0]);
            SendEvent('esealteston',[],me,'all');
            %         if ~isempty(gcbo) & (gcbo==RunningH) ...
            % This run is the first one. Set up some parameters.
            set(RunningH,'string','Running...');
            % Stop other modules.
            ai('pause');
            ao('pause');

            ai2.Channel(:).InputRange=[-10 10];
            ai2.Channel(:).SensorRange=[-10 10];
            ai2.Channel(:).UnitsRange=[-10 10];
            %             ai2.TriggerType = 'HwDigital';
            set(ai2,'TriggerType','HwDigital');
            % Copy the sample rate from the other module.
            %             ai2.SampleRate = GetParam('ai','samplerate');
            set(ai2,'SampleRate',GetParam('ai','samplerate'));
            ai2SampleRate=ai2.SampleRate/1000;
            % Do not let ai use interrupts if DMA is possible.
            % Get possible transfer modes.
            possibs=set(ai2,'TransferMode');
            % Set transfer mode to DualDMA if possible and SingleDMA as alternate.
            if sum(strcmp(possibs,'DualDMA'))
                %                 ai2.TransferMode='DualDMA';
                set(ai2,'TransferMode','DualDMA');
            elseif sum(strcmp(possibs,'SingleDMA'))
                %                 ai2.TransferMode='SingleDMA';
                set(ai2,'TransferMode','SingleDMA');
            end
            % Call this file at the end.
            set(ai2,'StopFcn',[me]); %I think this is how sealtest keeps freerunning
            ao2.Channel(:).OutputRange=[-10 10];
            ao2.Channel(:).UnitsRange=[-10 10];
            % Set trigger.
            set(ao2,'TriggerType','HwDigital');
            %            set(ao2,'TriggerType','Immediate'); %mw 01.09.06
            %             set HwDigitalTriggerSource: PFI6 ?
            % Set sample rate.
            %             ao2.SampleRate = GetParam('ao','samplerate');
            set(ao2,'SampleRate',GetParam('ao','samplerate'));
            ao2SampleRate=ao2.SampleRate/1000; %for ms

            set(ai2,'TriggerType','Immediate'); % find out gain and mode of Axopatch
            Samp=getsample(ai2);
            set(ai2,'TriggerType','HwDigital');

            dataChannels=GetParam(me,'DataChannels');
            gainChannels=GetParam(me,'GainChannels');
            modeChannels=GetParam(me,'ModeChannels');
            nChannels=GetParam(me,'nChannels');

            pw=zeros(1,nChannels);
            ph=zeros(1,nChannels);
            phScaled=zeros(1,nChannels);
            DataCh=zeros(1,nChannels);
            GainCh=zeros(1,nChannels);
            ModeCh=zeros(1,nChannels);

            for channel=1:nChannels
                DCh=daqfind(ai2,'HwChannel',dataChannels(channel));
                DataCh(channel)=DCh{1}.Index;
                GCh=daqfind(ai2,'HwChannel',gainChannels(channel));
                GainCh(channel)=GCh{1}.Index;
                MCh=daqfind(ai2,'HwChannel',modeChannels(channel));
                ModeCh(channel)=MCh{1}.Index;

                Mode=AxonMode(Samp(ModeCh(channel)));

                % Scale for the amplification.
                if iscell(Mode)
                    Mode=Mode{end};
                end
                switch Mode
                    case {'Track','V-Clamp'}
                        ph(channel)=GetParam(me,'v_height');
                        pw(channel)=GetParam(me,'v_width');
                        % Because 20 mV/V, divide by 20.
                        phScaled(channel)=ph(channel)/20;
                    case {'I=0','I-Clamp Normal','I-Clamp Fast'}
                        ph(channel)=GetParam(me,'i_height');
                        pw(channel)=GetParam(me,'i_width');
                        % Because 2/beta nA/V = 2000/beta pA/V, get gain and scale.
                        % Assumes beta = 1. Figure out what I should do.
                        phScaled(channel)=ph(channel)/(2000);
                end
            end

            pwMax=max(pw);
            sampleLength=2*pwMax;   % sample length in ms
            samples=zeros(ceil(sampleLength*ao2SampleRate),nChannels);
            set(ai2,'SamplesPerTrigger',ceil(sampleLength*ai2SampleRate));
            for channel=1:nChannels
                pulseinds=ceil([0.5 1.5]*pw(channel)*ao2SampleRate);
                samples(pulseinds(1):pulseinds(2),channel)=phScaled(channel);
            end

            % Send step waveform.
            putdata(ao2,samples);
            % Trigger.
            start(ai2);
            start(ao2);
            % Flip dio bit to trigger.
            putvalue(dio2,1);
            pause(.02)
            putvalue(dio2,0);

        else % ~Running
            set(RunningH,'enable','off');
            set(RunningH,'string','Run');
            set(RunningH,'backgroundcolor',[0 1 0]);

            if exist('ao2','var') & ~isempty(ao2)
                stop(ao2);
            end
            if exist('ai2','var') & ~isempty(ai2)
                stop(ai2);
            end
            ai('reset');
            ao('really_reset');

            SendEvent('esealtestoff',[],me,'all');
            % 20041124 - foma
            %         eval([ me '(''reset'');' ]);
            set(RunningH,'enable','on');
        end

    case 'freerun'
        %mw 082008 trying to slow down sealtest because it's too fast for Ben
        %pause(.01)

        if (ai2.SamplesAvailable>0) % we might have some data available

            wait(ai2,5);   %            wait(ai2,1);
            wait(ao2,5);   %            wait(ao2,1);

            %             evalc('[data,time]=getdata(ai2);');
            [data,time]=getdata(ai2);
            %really_running check added by mike wehr 9-25-01
            really_running=get(RunningH,'value');
            if really_running
                % Send step waveform.
                putdata(ao2,samples);
                % Trigger.
                start(ai2);
                start(ao2);

                % Flip dio bit to trigger.
                putvalue(dio2,1);
                pause(.02)
                putvalue(dio2,0);

            end

            % Go on with analysis.
            % find out which channel we're plotting
            if GetParam(me,'nChannels')>1
                channelButtons=get(GetParam(me,'ChannelButtons'),'Value');
                activeChannel=find([channelButtons{:}]);
                activeChannel=activeChannel(1);         % just in case we just switched the channels
            else
                activeChannel=1;
            end

            % Scale data.
            RawData=data(:,DataCh(activeChannel));
            GainData=data(:,GainCh(activeChannel));
            ScaledData=1000*RawData./AxonGain(GainData);

            % Get the mode of operation.
            ModeData=data(:,ModeCh(activeChannel));
            Mode=AxonMode(ModeData);
            if iscell(Mode)
                Mode=Mode{end};
            end

            % Display trace.

            set(curline(activeChannel),'XData',time,'YData',ScaledData);
            % autoscaling now handled here
            % scale axes to nearest power of two
            if GetParam(me,'autoscale')
                axlims=[0 length(ScaledData)/GetParam('ai','samplerate') get(findobj(fig,'type','axes'),'ylim')];
                if isempty(get(findobj(fig,'type','axes'),'ylim'))
                    axlims=[axlims(1:2) 0 1];
                end
                if ( max(abs(ScaledData)) == 0 ) | (isempty(axlims(4))) | ( axlims(4) == NaN ) | ...
                        ( axlims(4) == Inf ) | ( axlims(4) == 0 )
                    axlims(4)=1;
                end

                % if this is the first time autoscale runs
                if  strcmp(get(curaxes, 'tag'), 'first-autoscale');
                    set(curaxes, 'tag', '');
                    max2base = abs(max(ScaledData));
                    min2base = abs(min(ScaledData));
                    bs2maxlm = 2^ceil(log2( max2base ));
                    bs2minlm = 2^ceil(log2( min2base ));
                    axlims(4)=   bs2maxlm + bs2minlm/8 ;
                    axlims(3)= - bs2minlm - bs2maxlm/8  ;

                    % if the range of the trace exceeds the current axis
                elseif max(ScaledData)> axlims(4) | min(ScaledData) < axlims(3)
                    max2base = abs(max(ScaledData));
                    min2base = abs(min(ScaledData));
                    bs2maxlm = 2^ceil(log2( max2base ));
                    bs2minlm = 2^ceil(log2( min2base ));
                    axlims(4)=   bs2maxlm + bs2minlm/8 ;
                    axlims(3)= - bs2minlm - bs2maxlm/8 ;

                    % if the range of the trace is smaller than 1 fourth (2^-2 = 1/4) of the axis
                elseif (max(ScaledData)-min(ScaledData))*4 < axlims(4)-axlims(3) & ...
                        min([abs(max(ScaledData)),abs(min(ScaledData))])*2 < max(ScaledData)-min(ScaledData)
                    max2base = abs(max(ScaledData));
                    min2base = abs(min(ScaledData));
                    bs2maxlm = 2^ceil(log2( max2base )-1);
                    bs2minlm = 2^ceil(log2( min2base )-1);
                    axlims(4)=   bs2maxlm + bs2minlm/8 ;
                    axlims(3)= - bs2minlm - bs2maxlm/8 ;
                end
                set(findobj(fig,'type','axes'),'xlim',axlims(1:2));
                set(findobj(fig,'type','axes'),'ylim',axlims(3:4));
            end

            fig = findobj('type','figure','tag',me);
            curaxes = findobj(fig,'type','axes');
            ylh=get(curaxes, 'ylabel');
            xlh=get(curaxes, 'xlabel');
            set(xlh, 'string', 'Time (s)');

            switch Mode
                case {'Track','V-Clamp'}
                    set(ylh, 'string', 'Current (pA)');
                case {'I=0','I-Clamp Normal','I-Clamp Fast'}
                    set(ylh, 'string', 'Voltage (mV)');
            end

            % Extract parameters.
            baseline_region=find(time<(0.45*pw(activeChannel)/1000));
            Baseline=mean(ScaledData(baseline_region));

            switch Mode
                case {'Track','V-Clamp'}
                    phTemp=GetParam(me,'v_height');
                    pwTemp=GetParam(me,'v_width');
                    % Look for peak in +/- 1 ms around pulse onset.
                    peak_region = find( ( time > ((0.5*pwTemp - 1) * (1e-3)) ) & ...
                        ( time < ((0.5*pwTemp + 1) * (1e-3)) ) );
                    Peak = sign(phTemp) * max( sign(phTemp) * ScaledData( peak_region ) );
                    Peak = Peak - Baseline;
                    % Look for tail in last 1 ms of pulse.
                    tail_region = find( ( time > ((1.5*pwTemp - 1) * 1e-3) ) & ...
                        ( time < (1.5*pwTemp * 1e-3) ) );
                    Tail=mean(ScaledData(tail_region));
                    Tail = Tail - Baseline;
                    % ph in mV, current in pA and resistance in MOhm.
                    if (Peak~=0) & (Tail~=0)
                        Rs=(phTemp * 1e-3)/( Peak * 1e-12) / (1e6);
                        Rt=(phTemp * 1e-3)/( Tail * 1e-12) / (1e6);
                        Rin=Rt-Rs;
                    else
                        Rs=inf;Rt=inf;Rin=inf;
                    end

                case {'I=0','I-Clamp Normal','I-Clamp Fast'}
                    phTemp=GetParam(me,'i_height');
                    pwTemp=GetParam(me,'i_width');
                    % Find time index that pulse started and look +/- 1 ms for steepness.
                    start_region = find( ( time > ((0.5*pwTemp - 1) * (1e-3)) ) & ...
                        ( time < ((0.5*pwTemp + 1) * (1e-3)) ) );
                    [dum,onset_index]=max( sign(phTemp)*diff( ScaledData( start_region ) ) );
                    Onset=ScaledData( onset_index + 1 );
                    Onset = Onset - Baseline;
                    % Look for peak charging in +/- 1 ms around pulse termination.
                    peak_region = find( ( time > ((1.5*pwTemp - 1) * (1e-3)) ) & ...
                        ( time < ((1.5*pwTemp + 1) * (1e-3)) ) );
                    Peak = sign(phTemp) * max( sign(phTemp) * ScaledData( peak_region ) );
                    Peak = Peak - Baseline;
                    if phTemp~=0
                        Rs=( Onset * (1e-3 ) ) / ( phTemp * (1e-12) ) / (1e6);
                        Rt=( Peak * (1e-3) ) / ( phTemp * (1e-12) ) / (1e6);
                        Rin=Rt-Rs;
                    else
                        Rs=inf;Rt=inf;Rin=inf;
                    end
            end

            % Display parameters
            % Show Rs
            set(RsH,'String',Rs);
            set(RtH,'string',Rt);

        end %% if (ai2.SamplesAvailable>0) % we might have some data available


        %end        % if (ao2.SamplesOutput>0)  % we have put some data %mw09-21-09
        % if (ai2.SamplesAvailable>0) % we might have some data available




        % Parameter callbacks.

    case 'autoscale'
        if  GetParam(me,'autoscale')
            SetParamUI(me,'Autoscale','backgroundcolor',[0 1 1],'foregroundcolor',[0 0 1]);
            SetParam(me,'zoom',0);
            set(curaxes, 'tag', 'first-autoscale');
        else
            SetParamUI(me,'Autoscale','backgroundcolor',[0.2 0.3 0.8],'foregroundcolor',[1 1 1]);
            SetParam(me,'zoom',1);
        end

    case 'grid'
        if  GetParam(me,'grid')
            SetParamUI(me,'Grid','backgroundcolor',[0 1 1],'foregroundcolor',[0 0 1]);
            grid on;
        else
            SetParamUI(me,'Grid','backgroundcolor',[0.2 0.3 0.8],'foregroundcolor',[1 1 1]);
            grid off;
        end

    case 'zoomin'
        ylim=get(curaxes,'YLim');
        set(curaxes,'YLim',0.8*ylim);

    case 'zoomout'
        ylim=get(curaxes,'YLim');
        set(curaxes,'YLim',1.2*ylim);

    case 'center'
        visible=get(curline,'Visible');
        visible=find(strcmpi(visible,'on'));
        if ~isempty(visible)
            ydata=get(curline(visible),'YData');     % gets y-range of values for all lines
            if iscell(ydata)        % we have more lines
                ydata=[ydata{:}];
            end
            ylim=get(curaxes,'YLim');
            center=mean(ydata);
            range=(ylim(2)-ylim(1))/2;
            set(curaxes,'YLim',[center-range center+range]);
        end

    case 'axesbuttondown'
        curpoint=get(curaxes,'CurrentPoint');
        set(fig,'WindowButtonUpFcn',[me '(''axesbuttonup'');']);
        set(fig,'WindowButtonMotionFcn',[me '(''axesbuttonmotion'');']);

    case 'axesbuttonmotion'
        newpoint=get(curaxes,'CurrentPoint');
        delta=curpoint-newpoint;
        delta=delta(2,2);       % we're interested only in y-axis changes
        ylim=get(curaxes,'YLim');
        curpoint=newpoint;
        set(curaxes,'YLim',[ylim(1)+delta ylim(2)+delta]);

    case 'axesbuttonup'
        set(fig,'WindowButtonMotionFcn','');
        set(fig,'WindowButtonUpFcn','');

    case 'channelbutton'
        activeButton=gco;
        channelButtons=GetParam(me,'ChannelButtons');
        set(get(activeButton,'UserData'),'Value',0,'String','');
        set(activeButton,'Value',1,'String','On');
        values=get(channelButtons,'Value');
        set(curline(logical([values{:}])),'visible','on');
        set(curline(logical(1-[values{:}])),'visible','off');

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newao=InitDAQAO
global exper pref

stopandstartao=isfield(exper,'ao') & isfield(exper.ao,'daq') & isobject(exper.ao.daq) & ...
    strcmp(get(exper.ao.daq,'Running'),'On');
% If the 'main' AO is running, first stop it...
if stopandstartao
    stop(exper.ao.daq);
end

CommandCh=GetParam(me,'CommandChannels');

boardn=daqhwinfo('nidaq', 'BoardNames');
v=ver('daq'); %daq toolbox version number
%mw 08.28.08  new version of matlab refers to devices differently
if str2num(v.Version) >= 2.12
    newao=analogoutput('nidaq','Dev1'); %mw 12.16.05
else %assume old version of matlab
    switch boardn{1} %mw 04.18.06
        case 'PCI-6052E'
            newao=analogoutput('nidaq',1);
        case 'PCI-6289'
            newao=analogoutput('nidaq','Dev1'); %mw 12.16.05
    end
end

addchannel(newao,[CommandCh]);
newao.Channel(:).OutputRange=[-10 10];
newao.Channel(:).UnitsRange=[-10 10];
% Set trigger.
newao.TriggerType = 'HwDigital'; %%mw 12.16.05
% Set sample rate.
newao.SampleRate = GetParam('ao','samplerate');

% ...and then refresh it
if stopandstartao
    ao('putdata');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newai=InitDAQAI
global exper pref

stopandstartai=isfield(exper,'ai') & isfield(exper.ai,'daq') & isobject(exper.ai.daq) & ...
    strcmp(get(exper.ai.daq,'Running'),'On');
if stopandstartai
    stop(exper.ai.daq);
end

RawCh=GetParam(me,'DataChannels');
GainCh=GetParam(me,'GainChannels');
ModeCh=GetParam(me,'ModeChannels');
% Create ai.
boardn=daqhwinfo('nidaq', 'BoardNames');

v=ver('daq'); %daq toolbox version number
%mw 08.28.08  new version of matlab refers to devices differently
if str2num(v.Version) >= 2.12
    newai=analoginput('nidaq','Dev1');
else %assume old version of matlab
    switch boardn{1} %mw 04.18.06
        case 'PCI-6052E'
            newai=analoginput('nidaq',1);
        case 'PCI-6289'
            newai=analoginput('nidaq','Dev1'); %mw 12.16.05
    end
end

% NOTE: originally sealtest used differential inputs for nidaq, which,
% in our case meant up to 8 channels. With single ended inputs, as in
% case of AI, we can use 16 channels
%get the type of input types the board likes
% 	inputs=propinfo(newai,'InputType');
%if its possible to set the InputType to SingleEnded, then do it
% 2004/11/10 - foma - I talked to Mike Wehr, and decided to switch to
% differential
% We're going to use differential inputs
% see also open_ai above
% 	if ~isempty(find(strcmpi(inputs.ConstraintValue, 'SingleEnded')))
% 		ai.InputType='SingleEnded';
% 	end

addchannel(newai,[RawCh GainCh ModeCh]);
newai.Channel(:).InputRange=[-10 10];
newai.Channel(:).SensorRange=[-10 10];
newai.Channel(:).UnitsRange=[-10 10];
% Set trigger.
newai.TriggerType='HwDigital';
% Copy the sample rate from the other module.
newai.SampleRate=GetParam('ai','samplerate');
% Set length to be twice the pulse length.
newai.SamplesPerTrigger=ceil(newai.SampleRate);
% Call this file at the end.

if stopandstartai
    start(exper.ai.daq);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newdio=InitDAQDIO
boardn=daqhwinfo('nidaq', 'BoardNames');

v=ver('daq'); %daq toolbox version number
%mw 08.28.08  new version of matlab refers to devices differently
if str2num(v.Version) >= 2.12
    newdio=digitalio('nidaq','Dev1');
else %assume old version of matlab
    switch boardn{1} %mw 04.18.06
        case 'PCI-6052E'
            newdio=digitalio('nidaq',1);
        case 'PCI-6289'
            newdio=digitalio('nidaq','Dev1'); %mw 12.16.05
    end
end
trigchan=GetParam('dio','trigchan');
if ischar(trigchan)
    trigchan=str2double(trigchan);
end
addline(newdio,trigchan,'out');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Mode = AxonMode(Readings)
% Discover the operating mode of the Axon 200B.
% Modes
% 1		Track
% 2		V-Clamp
% 3		I=0
% 4		I-Clamp Normal
% 6		I-Clamp Fast

% Preserve input matrix size for output later.
sizeout=size(Readings);

PossibleReadings=[1 2 3 4 6];
PossibleModes={'I-Clamp Fast','I-Clamp Normal','I=0','Track','V-Clamp'};

% To get look up indices, make ndgrid of readings and possible readings.
% The find minimum differences and use them to index the possible gains.
[Readings,PossibleReadings]=ndgrid(Readings,PossibleReadings);
[dum,inds]=min(abs(Readings-PossibleReadings),[],2);

% If all modes/indices were the same, return a single string.
if (prod(size(unique(inds)))==1)
    Mode=PossibleModes(inds(1));
else
    % Otherwise, reshape to match the input matrix shape.
    Mode=PossibleModes(inds);
    Mode=reshape(Mode,sizeout);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Gain=AxonGain(Readings)
% Discover the gain setting of the Axon 200B.
%	Telegraph Reading (V):		0.5		1	1.5	2.0	2.5	3.0	3.5	4.0	4.5	5.0	5.5	6.0	6.5
%	Gain (mV/mV) or (mV/pA):	0.05	0.1	0.2	0.5	1	2	5	10	20	50	100	200	500

% Preserve input matrix size for output later.
sizeout=size(Readings);

% Make matrices of the possible telegraph readings and corresponding gains.
PossibleReadings=[0.5:0.5:6.5];
PossibleGains=[0.05 0.1 0.2 0.5 1 2 5 10 20 50 100 200 500];

% To get look up indices, make ndgrid of readings and possible readings.
% The find minimum differences and use them to index the possible gains.
[Readings,PossibleReadings]=ndgrid(Readings,PossibleReadings);
[dum,inds]=min(abs(Readings-PossibleReadings),[],2);
Gain=PossibleGains(inds);

% Reshape to match the input matrix shape.
Gain=reshape(Gain,sizeout);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return the name of this file/module.
function out=me
out=lower(mfilename);