close all; clear all;
plot3([0 0], [0 0], [0 0], 'b'); % initialize 3D plot
hold on;
xlabel('x'); ylabel('y'); zlabel('z');

translate = @(vec) [eye(3), vec;0 0 0 1];
rotateZ = @(alfa) [cos(alfa) -sin(alfa) 0 0; sin(alfa) cos(alfa) 0 0; 0 0 1 0; 0 0 0 1];
rotateX = @(alfa) [1 0 0 0; 0 cos(alfa) -sin(alfa) 0; 0 sin(alfa) cos(alfa) 0; 0 0 0 1];

draw_coords(translate([0;0;0]), '0');
draw_coords(translate(0.5*[1;1;1]) * rotateZ(pi/2), '1');
draw_coords(rotateX(pi/2) * rotateZ(pi/2), '2');

