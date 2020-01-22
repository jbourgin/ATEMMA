function [ellipseBck] = drawEllipse(height, width, dx, dy, shiftHorizontal)
% ellipseBck -> matrix.
% height -> int. Height of the image in the ellipse.
% width -> int. Width of the image in the ellipse.
% dx -> int. Horizontal offset.
% dy -> int. Vertical offset.
% shiftHorizontal -> int.

UnchangingSettingsGaze;
global wH;
global wW;

ellipseBck = ones(height,width,-2);
ellipseShiftY = wH/2 + decHeightScreen;
ellipseShiftX = wW/2 + shiftHorizontal;
%We draw a white frame.
for eltx = 1:height
    for elty = 1:width
        if inEllipse(eltx+dy,elty+dx,heightEllipse/2,widthEllipse/2,ellipseShiftY,ellipseShiftX) == 0 && inEllipse(eltx+dy,elty+dx,heightEllipse/2+decHeightScreen,widthEllipse/2+decHeightScreen,ellipseShiftY,ellipseShiftX) == 1
            ellipseBck(eltx,elty,1) = 255;
            ellipseBck(eltx,elty,2) = 255;
            ellipseBck(eltx,elty,3) = 255;
            ellipseBck(eltx,elty,4) = 255;
        else
            ellipseBck(eltx,elty,1) = 0;
            ellipseBck(eltx,elty,2) = 0;
            ellipseBck(eltx,elty,3) = 0;
            ellipseBck(eltx,elty,4) = 0;
        end
    end
end