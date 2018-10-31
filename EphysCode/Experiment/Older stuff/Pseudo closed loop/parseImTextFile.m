
dbstop if error

clear imData 
fileID=fopen('tiffDataFile.txt','r');
A=fscanf(fileID,['%s'],inf);
fclose(fileID);
fileStrings=strsplit(A,'#');

for fnum=1:length(fileStrings)-1
    
    thisFileString=strrep(fileStrings{fnum},'fileNum=','');
    thisFileString=strrep(thisFileString,'fileName','');
    thisFileString=strrep(thisFileString,'flowMag','');
    thisFileString=strrep(thisFileString,'laserStatus','');
    subStrings=strsplit(thisFileString,'=');
    
    imData(fnum).imageNum=str2num(subStrings{1});
    imData(fnum).fileName=subStrings(2);
    imData(fnum).flowMag=str2num(subStrings{3});
    imData(fnum).laserStatus=str2num(subStrings{4});
    
    
end

figure; plot([imData(:).flowMag])
figure; plot([imData(:).laserStatus])
    