function vid=ptgreycam_selectROI(vid)

originalROI=get(vid,'ROIposition');
userResponse='r';

while strcmp(userResponse,'r')
    
    % Acquire one frame w/original ROI
    
    vid.ROIPosition=originalROI;
    triggerconfig(vid,'manual');
    vid.FramesPerTrigger=1;
    start(vid);
    trigger(vid);
    data=getdata(vid,1);
    figure
    [BW,xi,yi]=roipoly(data);
    close
    
    
    % Acquire frame with new ROI
    
    minX=min(xi);
    minY=min(yi);
    lengthX=range(xi);
    lengthY=range(yi);
    vid.ROIPosition=[minX minY lengthX lengthY];
    triggerconfig(vid,'manual');
    vid.FramesPerTrigger=1;
    start(vid);
    trigger(vid);
    data=getdata(vid,1);
    imshow(data)
    
    % Get user input
    userResponse=input('\nAccept (a) or redraw (r)?\n  ','s');
    close
end

end