function [stimStr]=findStimFile(panelNumber,stimType)
% Short helper function for experiment script
% Example: findStimFile(5,'darkObj')
% 10/26/18



lookup(1).stimfile_dark=
lookup(1).stimfile_bright=





    if strcmp(stimType,'darkObj')
        
        stimStr=lookup(panelNumber).stimfile_dark;
        
    elseif strcmp(stimType,'brightObj')
        
        stimStr=lookup(panelNumber).stimfile_bright;
        
    end
    
    
    0+0
    
        

end