clear all; close all;
load('robot');

Theta = pi*[1/6 1/4 1/3 1/2 2/3 3/4 5/6];
Theta = [0 Theta -Theta pi];
D = 1:2:21;

J = zeros(2, length(D) * length(Theta));
for i = 1:length(Theta)
    for j = D
        J(:,1 + (i-1)*length(D) + (j-1)/2) = [j; Theta(i)];
    end
end        
%save('data');
load('data');

% assert(size(J, 2) == 99);
d = extract_robot_params(robot);

XC = mydkt(robot, J);
Xm = zeros(2, size(J, 2));
    
for point = 1:size(J, 2)
    this_J = J(:, point);
    this_dktX1 = XC{1}(:, point);
    this_dktX2 = XC{2}(:, point);
    
    cnf1 = cnf(d, this_J, this_dktX1);
    cnf2 = cnf(d, this_J, this_dktX2);
        
    assert(cnf1 ~= cnf2);
    % assert(cnf1 == 1 || cnf2 == 1);
        
    if cnf1 == max([cnf1 cnf2])
        this_dktX = this_dktX1;
    else
        this_dktX = this_dktX2;
    end
    Xm(:, point) = this_dktX;
end   

hold on;
for col = 1:size(J, 2)
    plot(Xm(1, col), Xm(2, col), 'rx')
end
title('Souřadnice kalibračních bodů v pracovním prostoru robota')
xlabel('souřadnice x')
ylabel('souřadnice y')

Xm = Xm + 0.01 * randn(size(Xm));

calib = mycalib(robot, J, Xm);

        