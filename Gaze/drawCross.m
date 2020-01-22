% Draws a cross
function drawCross(xCenter,yCenter)
% xCenter -> integer (pixel value). Horizontal coordinate of the cross center
% yCenter -> integer (pixel value). Vertical coordinate of the cross center

global window;
UnchangingSettingsGaze;

fixCrossDimPix = 24;% height and width of the cross in pixels
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];
barWidth = 4; % width of the bars composing the cross in pixels
Screen('DrawLines',window,allCoords,barWidth,textColor,[xCenter yCenter]);

end