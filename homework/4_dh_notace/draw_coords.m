function draw_coords(transformace, index)
extract = @(vec) vec(1:3) / vec(4); % convert from homogenous coordinates to cartesian

% transform basis vectors to given coordinate system
O = extract(transformace * [0;0;0;1]);
x = extract(transformace * [1;0;0;1]);
y = extract(transformace * [0;1;0;1]);
z = extract(transformace * [0;0;1;1]);

dx = [O x];
dy = [O y];
dz = [O z];

% plot basis vectors
plot3(dx(1, :), dx(2, :), dx(3, :), 'r');
plot3(dy(1, :), dy(2, :), dy(3, :), 'g');
plot3(dz(1, :), dz(2, :), dz(3, :), 'b');

% label vectors and origin
text(x(1), x(2), x(3),strcat(' x', index));
text(y(1), y(2), y(3),strcat(' y', index));
text(z(1), z(2), z(3),strcat(' z', index));
text(O(1), O(2), O(3),strcat('    O', index));
end