clear all; close all; clc

%% 071917
% datafolder='C:\Users\A. K. Moore\Desktop\ALL MATLAB\071917_001';
% mVLineAt=0;
% 
% filename='daqout_071917_001_004.mat'
% snippets(1).sec=[10 20];
% snippets(1).sec=[30 60];


% 
% filename='daqout_071917_001_005.mat'
% snippets(1).sec=[1 30];
% snippets(2).sec=[30 60];

% 
% filename='daqout_071917_001_006.mat'
% snippets(1).sec=[1 30];
% snippets(2).sec=[30 60];

% filename='daqout_071917_001_007.mat'
% snippets(1).sec=[1 30];
% snippets(2).sec=[30 60];

% filename='daqout_071917_001_011.mat'
% snippets(1).sec=[1 30];
% snippets(2).sec=[30 60];

%% 103117_001 - done 

% datafolder='C:\Users\A. K. Moore\Desktop\ALL MATLAB\103117';
% mVLineAt=-50;

% filename='daqout_103117_001_012.mat'
% snippets(1).sec=[10 30];
% snippets(2).sec=[35 55];

% filename='daqout_103117_001_014.mat'
% snippets(1).sec=[1 30];
% snippets(2).sec=[30 60];

% filename='daqout_103117_001_023.mat'
% snippets(1).sec=[1 20];
% snippets(2).sec=[25 50];

%% 100917_001        
datafolder='C:\Users\A. K. Moore\Desktop\1009';
mVLineAt=0;

filename='daqout_100917_001_026.mat'
snippets(1).sec=[1 30];
snippets(2).sec=[31 60];

%% 080717_001 - done

% datafolder='C:\Users\A. K. Moore\Desktop\ALL MATLAB\080717';
% mVLineAt=0;

% filename='daqout_080717_001_011.mat'
% snippets(1).sec=[15 45];
% 
% filename='daqout_080717_001_015.mat'
% snippets(1).sec=[7 57];
% 
% filename='daqout_080717_001_018.mat'
% snippets(1).sec=[10 60];


%% 

cd(datafolder)
plotTraceSnippets(datafolder,filename,snippets,mVLineAt)
% plotTraceSnippets_CA(datafolder,filename,snippets,mVLineAt)


set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [11 8.5]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 11 8.5]);
set(gcf, 'renderer', 'painters');
pdfname=strrep(filename,'.mat','.pdf');
print(gcf, '-dpdf', pdfname);
% close
