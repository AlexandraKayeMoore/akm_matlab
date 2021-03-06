Our internal matlab code to run the panels system, retains core functions from the original sources:
- https://bitbucket.org/iorodeo/panels/
- https://bitbucket.org/mreiser/panels/

TODO:
- tidy up: remove log files, duplicates, obsolete tests
- consolidate code into valid tests, example, pattern/function/configuration utilities, controller interface
- remove extra pop-up windows

Documentation temporarily here:
```
Patterns are arranged in a straightforward, but involved way.

In Matlab, patterns are made up as Matrices of numeric data. 
Suppose we want to display stripes that are 2 pixels wide on one panel.
The binary data would be - 

1 1 0 0 1 1 0 0			0 0 0 0 0 0 0 0 
1 1 0 0 1 1 0 0			0 0 0 0 0 0 0 0 
1 1 0 0 1 1 0 0			1 1 1 1 1 1 1 1
1 1 0 0 1 1 0 0		or 	1 1 1 1 1 1 1 1	
1 1 0 0 1 1 0 0			0 0 0 0 0 0 0 0
1 1 0 0 1 1 0 0			0 0 0 0 0 0 0 0
1 1 0 0 1 1 0 0			1 1 1 1 1 1 1 1	
1 1 0 0 1 1 0 0			1 1 1 1 1 1 1 1

where 1 is an on pixel and 0 is an off pixel. The panels are expecting this data to be encoded columwise. 
We then turn each column in a decimal value, so the first pattern is [255 255 0 0 255 255 0 0], and the second pattern is
[204 204 204 204 204 204 204 204]. Each column is 0*1 + 0*2 + 1*4 + 1*8 + 0*16 + 0*32 + 1*64 + 1*128 =  204.

If there are multiple frames, say Pattern 1 above is being shifted to the right by 1 column - 
then we need 4 frames to complete this pattern - because frame 5 would be the same as frame 1. The frames are:
[255 255 0 0 255 255 0 0], [0 255 255 0 0 255 255 0], [0 0 255 255 0 0 255 255], [255 0 0 255 255 0 0 255].

In Matlab, we make this one big matrix - 

M =[	255 255 0 0 255 255 0 0;
	0 255 255 0 0 255 255 0;
	0 0 255 255 0 0 255 255;
	255 0 0 255 255 0 0 255; ]

To make this the pattern data we then take the trasnpose and turn into one long column - 

m = M';
pattern.data = m(:);

So pattern.data = [255 255 0 0 255 255 0 0 0 255 255 0 0 255 255 0 0 0 255 255 0 0 255 255 255 0 0 255 255 0 0 255]'

If there are multiple panels, then each panel's data goes into each frame. So F1 = [P1; P2; P3;...PN_p] and then 
M = [F1; F2; F3; F4...FN_f], where N_p is the number of panels and N_f is the number of frames.

If the patterns are greyscale, then there are 3 bits per pixel - 
And each panel's pattern is encoded by a 24 byte vector - 3 bytes per column.
The next pattern is all of encoding of an 8x8 pattern where the columns go from off to brightest:
M_temp = [0 0 0, 0 0 255, 0 255 0, 0 255 255, 255 0 0, 255 0 255, 255 255 0, 255 255 255];
