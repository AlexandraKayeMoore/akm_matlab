%% make_azimuth_color_code_72 - 10/23/18

clear all
close all
clc



contra_CC=cbrewer('seq', 'Blues', 80); clc
figure % Plot this color sequence
for c=1:80
    hold on; plot([1:10],repmat(c,1,10),'color',contra_CC(c,:),'linew',5)
end

ipsi_CC=cbrewer('seq', 'Oranges', 80); clc
figure % Plot this color sequence
for c=1:80
    hold on; plot([1:10],repmat(c,1,10),'color',ipsi_CC(c,:),'linew',5)
end





clear azimuthColorCode

cCount=1;
for c=45:80
    azimuthColorCode(cCount).RGB=contra_CC(c,:);
    cCount=cCount+1;
end

for c=80:-1:45
    azimuthColorCode(cCount).RGB=ipsi_CC(c,:);
    cCount=cCount+1;
end
    




% Plot color code (72 values)
figure;
for c=1:length(azimuthColorCode)
     hold on; plot([1:10],repmat(c,1,10),'color',azimuthColorCode(c).RGB,'linew',5)
end


% Save color code
cd('C:\Users\amoore\akm_matlab\EphysCode\Analysis')
save('azimuth_CC_72.mat','azimuthColorCode')