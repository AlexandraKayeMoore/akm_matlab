%% Make panel look-up table, 10/26/18
% Look-up table for position functions 45 and 46 (flash each location 8x8)
% Converts xpos,ypos values --> panel #s

panelInfo(1).xpos_ypos=[4 4];
panelInfo(2).xpos_ypos=[4 12];

panelInfo(3).xpos_ypos=[12 4];
panelInfo(4).xpos_ypos=[12 12];

panelInfo(5).xpos_ypos=[20 4];
panelInfo(6).xpos_ypos=[20 12];

panelInfo(7).xpos_ypos=[28 4];
panelInfo(8).xpos_ypos=[28 12];

panelInfo(9).xpos_ypos=[36 4];
panelInfo(10).xpos_ypos=[36 12];

panelInfo(11).xpos_ypos=[44 4];
panelInfo(12).xpos_ypos=[44 12];

panelInfo(13).xpos_ypos=[52 4];
panelInfo(14).xpos_ypos=[52 12];

panelInfo(15).xpos_ypos=[60 4];
panelInfo(16).xpos_ypos=[60 12];

panelInfo(17).xpos_ypos=[68 4];
panelInfo(18).xpos_ypos=[68 12];

cd('C:\Users\amoore\akm_matlab\EphysCode\Analysis')
save('panelLookUp','panelInfo');

