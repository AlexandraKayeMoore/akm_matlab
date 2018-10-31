
dataDir='D:\data_main\041018_002'
csvFile='vidout_033018_001_005.dat'
infile=load('daqout_033018_001_005.mat')
stimulus=[];
cameraTriggers=infile.settings.cameraTrigOut;



analyze_FT_data(dataDir,csvFile,80,stimulus,cameraTriggers)

set(gcf,'paperorientation','landscape')
print(gcf,strrep(csvFile,'.dat','_2.pdf'),'-dpdf','-fillpage'); 
close

set(gcf,'paperorientation','landscape')
print(gcf,strrep(csvFile,'.dat','_1.pdf'),'-dpdf','-fillpage'); 
close

