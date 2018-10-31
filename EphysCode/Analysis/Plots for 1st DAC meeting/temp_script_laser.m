dbstop if error

fpath='C:\Users\A. K. Moore\Desktop\ALL MATLAB\103117_001';
cd(fpath)
vidfiles=dir('vidout*');

for f=1:length(vidfiles)
   
    fname=strrep(vidfiles(f).name,'vid','daq');
    load(fname);
    
    clear snippets
    if strcmp(stimulus.type,'laser_pulses')
        fileduration=floor(length(data.voltage)/settings.sampRate);
        fprintf('\n %s duration %.1f sec   \n',fname,fileduration);
        spts=1:floor(fileduration/4):fileduration;
        for s=2:length(spts)
           snippets(s).sec=[spts(s-1) spts(s)];
        end
        snippets(1)=[];
        plotTraceSnippets(fpath,fname,snippets,-50)
        
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperSize', [11 8.5]);
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperPosition', [0 0 11 8.5]);
        set(gcf, 'renderer', 'painters');
        pdfname=strrep(fname,'.mat','.pdf');
        print(gcf, '-dpdf', pdfname);
        close
        
    end
    

    
    
    
end

%  daqout_103117_001_015 duration 155.5 sec   
% 
%  daqout_103117_001_016 duration 155.5 sec   
% 
%  daqout_103117_001_019 duration 62.5 sec   
% 
%  daqout_103117_001_025 duration 112.0 sec   
% 
%  daqout_103117_001_026 duration 112.0 sec  