% Returns true if a given point is in a given ellipse, else false.
function bool = inEllipse(x,y,a,b,c1,c2)
% bool -> boolean. True if the point is in the ellipse, else false.
% x -> double. Horizontal coordinate of the point.
% y -> double. Vertical coordinate of the point.
% a -> double. Large radius length.
% b -> double. Small radius length.
% c1 -> double. Horizontal coordinate of the ellipse center.
% c2 -> double. Vertical coordinate of the ellipse center.

if (x - c1).^2/a.^2 + (y - c2).^2/b.^2 <= 1
    bool = 1;
else
    bool = 0;
end

end