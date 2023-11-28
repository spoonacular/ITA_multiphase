function angle = calAngleWith3Coords(xy1,xy2,xyc)
% give the angle made by xy1 and xy2 at xyc, measured counter-clockwise
% from xy1 to xy2

v1 = xy1-xyc;
v2 = xy2-xyc;

angle1 = atan2d(v1(:,2),v1(:,1)); 
angle2 = atan2d(v2(:,2),v2(:,1));
angle = mod(angle2 - angle1,360);
