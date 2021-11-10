function [T] = dh_transform(theta, d, a, alfa)
    translate = @(vec) [eye(3), vec;0 0 0 1];
    rotateZ = @(alfa) [cos(alfa) -sin(alfa) 0 0; sin(alfa) cos(alfa) 0 0; 0 0 1 0; 0 0 0 1];
    rotateX = @(alfa) [1 0 0 0; 0 cos(alfa) -sin(alfa) 0; 0 sin(alfa) cos(alfa) 0; 0 0 0 1];
    rotateY = @(alfa) [cos(alfa) 0 sin(alfa) 0; 0 1 0 0; -sin(alfa) 0 cos(alfa) 0; 0 0 0 1];

    T = rotateZ(theta) * translate([0;0; d]) * translate([a;0;0]) * rotateX(alfa);
end

