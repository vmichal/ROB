clear all; close all;
load('robot');
d = extract_robot_params(robot);

coord_bounds = -100 : 1.45 : 100;

X = zeros(2, length(coord_bounds)^2);
valid_point_count = 1;
for x = coord_bounds
	for y = coord_bounds
		X(:, valid_point_count) = [x; y];
        valid_point_count = valid_point_count + 1;
	end
end
JC = myikt(robot, X);

valid_J = [];
valid_X = [];

for point = 1 : size(X, 2)
    this_X = X(:, point);

    % Prevent points from showing up multiple times
    if size(valid_X, 2) > 0 && sum(2 == ((valid_X(1,:) == this_X(1)) + valid_X(2,:) == this_X(2))) > 0
        continue;
    end
	for configuration = 1:4
        this_J = JC{configuration}(:, point);
        if any(isnan(this_J))
            continue;
        end
		if cnf(d, JC{configuration}(:, point), this_X) == 1
			valid_J = [valid_J JC{configuration}(:, point)];
            valid_X = [valid_X this_X];
            break;
		end
	end
end
disp(length(valid_X))

J = valid_J;
X = valid_X;

save('data');
hold on;
for col = 1:size(J, 2)
    plot(J(1, col), J(2, col), 'rx')
    plot(X(1, col), X(2, col), 'gx')
end
title('Souřadnice kalibračních bodů v pracovním prostoru robota')
xlabel('x, d_1')
ylabel('y, \theta_2')


        