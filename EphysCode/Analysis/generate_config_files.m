
cd('C:\Users\amoore\Desktop\041018_001') % Update
maskFileName='041018_001_mask.jpg'; % Update
tFileString='vidout_041018_001_001'; % Update

% Update
fstring{1}='vidout_041018_001_001';
fstring{2}='vidout_041018_001_002';
fstring{3}='vidout_041018_001_003';
fstring{4}='vidout_041018_001_004';
% fstring{5}='vidout_041018_001_006';
% fstring{6}='vidout_041018_001_007';
% fstring{7}='vidout_041018_001_008';
% fstring{8}='vidout_041018_001_009';


for f=1:length(fstring)
    
thisTxtFile=['config_' fstring{f} '.txt'];
fileID=fopen(thisTxtFile,'w');

fprintf(fileID,'\nmask_fn          ./%s',maskFileName);
fprintf(fileID,'\ninput_vid_fn     ./%s.avi',fstring{f});
fprintf(fileID,'\ntransform_fn     ./%s-transform.dat',tFileString);
fprintf(fileID,'\ntemplate_fn      ./%s-template.jpg',tFileString);
fprintf(fileID,'\nload_template    1');
fprintf(fileID,'\n');
fprintf(fileID,'\ndo_config           0');
fprintf(fileID,'\nfisheye             0');
fprintf(fileID,'\ncam_input           0');
fprintf(fileID,'\ncam_index           0');
fprintf(fileID,'\nvfov                17');
fprintf(fileID,'\n');
fprintf(fileID,'\nframe_skip          0');
fprintf(fileID,'\nframe_step          1');
fprintf(fileID,'\ndo_display          1');
fprintf(fileID,'\nno_prompts          1');
fprintf(fileID,'\nfps                 80');
fprintf(fileID,'\ndo_led_display      0');
fprintf(fileID,'\n');
fprintf(fileID,'\ndo_search           0');
fprintf(fileID,'\nuse_ball_colour     0');
fprintf(fileID,'\nquality_factor      6');
fprintf(fileID,'\nnlopt_ftol          1e-4');
fprintf(fileID,'\nnlopt_max_eval      100');
fprintf(fileID,'\nerror_thresh        10000');
fprintf(fileID,'\nthresh_win          0.3');
fprintf(fileID,'\nthresh_ratio        1');
fprintf(fileID,'\nmax_bad_frames      2');
fprintf(fileID,'\n');
fprintf(fileID,'\ndo_update           1');
fprintf(fileID,'\nsave_video          0');
fprintf(fileID,'\nsave_input_video    0');
fprintf(fileID,'\ndo_serial_out       0');
fprintf(fileID,'\nserial_baud         115200');
fprintf(fileID,'\nserial_port         /dev/ttyS0');
fprintf(fileID,'\ndo_socket_out       0');

fclose(fileID);

end



fileID=fopen('commands.txt','w');

for f=1:length(fstring)
fprintf(fileID,'\n')
fprintf(fileID,'../FicTrac_ubuntu16.04_64bit ./%s',['config_' fstring{f} '.txt']);
end

fclose(fileID);
