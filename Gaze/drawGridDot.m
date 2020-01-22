% Draws a grid dot
function [emptyBck] = drawGridDot(height, width, shiftHorizontal, dx, mx, dy, my, ms, randomX, randomY)
% emptyBck -> matrix.
% height -> int. Height of the image in the ellipse.
% width -> int. Width of the image in the ellipse.
% shiftHorizontal -> int.
% dx -> int. Horizontal offset.
% mx -> float. Horizontal position of the gaze.
% dy -> int. Vertical offset.
% my -> float. Vertical position of the gaze.
% ms -> float. Position of the mouse (dummy mode).
% randomX -> int. Horizontal position of the grid dot.
% randomY -> int. Vertical position of the grid dot.

UnchangingSettingsGaze;
global wW;
global wH;

emptyBck = ones(height,width) * backgroundcolor;

%We create the grid dot around the fovea.
ellipseShiftY = wH/2 + decHeightScreen;
ellipseShiftX = wW/2 + shiftHorizontal;
for eltx = randomX:30:height-2
    for elty = randomY:30:width-2
        if (((elty + dx) - mx).^2 + ((eltx + dy) - my).^2) > ms.^2 && inEllipse(eltx+dy,elty+dx,heightEllipse/2,widthEllipse/2,ellipseShiftY,ellipseShiftX) == 1
            emptyBck(eltx,elty) = 0;
            emptyBck(eltx-1,elty) = 0;
            emptyBck(eltx+1,elty) = 0;
            emptyBck(eltx,elty-1) = 0;
            emptyBck(eltx,elty+1) = 0;
        end
    end
end
end