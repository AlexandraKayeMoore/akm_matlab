function [croppedMovie_left,croppedMovie_center,croppedMovie_right]=animate_expanding_object()
%% animate_expanding_object()
% For use with 'expanding_object_LRC_v2.m' 
% akm 9/12/18

allFrames=zeros(216,272,72);
startingImage=zeros(216,272);

thisImage=startingImage;
allFrames(:,:,1)=thisImage; % frame 1 = dark

thisImage(108,136)=1;
allFrames(:,:,2)=thisImage; % frame 2 = dot

%imwrite(thisImage,'myMultipageFile.tif');

for fr=3:72 % frames 3-72 = expanding

thisImage=imdilate(thisImage,strel('sphere',3));
thisImage=imerode(thisImage,strel('sphere',2));

allFrames(:,:,fr)=thisImage;

%imwrite(thisImage,'myMultipageFile.tif','WriteMode','append')

end


% expansion from center -- ypos: 6
croppedMovie_center=allFrames(100:115,99:170,:);

% expansion from left -- ypos: 3
croppedMovie_left=allFrames(100:115,124:195,:);

% expansion from right -- ypos: 9
croppedMovie_right=allFrames(100:115,77:148,:);


end