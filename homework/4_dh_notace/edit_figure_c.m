close all;clear all;
load('DH_97_scheme_c');
beta = robot.rotations;
l = robot.translations;
openfig('DH_97_scheme_c.fig');
hold on;

trans_joint = dh_transform(0, 10, 0,0); % ten units of translation along z as placeholder for translational joints
rot_joint = dh_transform(25 / 180 * pi,0,0,0); % 25 ° rotation around z for rotational joints


% řešení DH notací:
% bázový systém
draw_coords(eye(4), 'b');

% SS0:
TB0 = dh_transform(pi/2, -l(1), 0, -pi/2);
T = TB0;
draw_coords(T, '0');

% SS1
T01 = dh_transform(pi/2, 0, l(2), pi);
T = T * rot_joint * T01;
draw_coords(T, '1');

% SS2
T12 = dh_transform(0,0,0,pi);
T = T * rot_joint * T12;
draw_coords(T , '2');

% SS3
T23 = dh_transform(pi/2, 0, l(4), pi);
T = T * trans_joint * T23;
draw_coords(T, '3');

% SS4
T34 = dh_transform(-pi/2, 0, l(5), pi);
T = T * rot_joint * T34;
draw_coords(T, '4');

% SS5
T45 = dh_transform(pi/2, 0, l(6), pi/2);
T = T * rot_joint * T45;
draw_coords(T, '5');

% SS6
T56 = dh_transform(0, 0, l(7), pi);
T = T * rot_joint * T56;
draw_coords(T, '6');

% SSW
T6W = dh_transform(0,0,0,0);
T = T * T6W;
draw_coords(T, '''');




