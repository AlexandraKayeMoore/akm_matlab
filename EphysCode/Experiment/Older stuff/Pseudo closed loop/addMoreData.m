
function addMoreData(src,event)

global fileID laserStatus outputData pxRegion movementThreshold opticFlowObj
 
    files=dir('fc2_*');
    nextFrame=imread(files(end).name,'PixelRegion',pxRegion);
    currentFlowValue=estimateFlow(opticFlowObj,nextFrame); % Get next optic flow measurement
    flowMag=sum(currentFlowValue.Magnitude(:));
    if flowMag<movementThreshold
        laserStatus=laserStatus+1;
    else
        laserStatus=0;
    end
    if laserStatus>3
        src.queueOutputData(outputData.laserON)
    else
        src.queueOutputData(outputData.laserOFF)
    end
    
    fprintf(fileID,' fileNum=%.0f fileName=%s flowMag=%.3f laserStatus=%.0f #',...
        length(files),files(end).name,flowMag,laserStatus);



% src.ScansQueued

end