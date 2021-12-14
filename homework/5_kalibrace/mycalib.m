function calib = mycalib(robot,J,Xm)
%
% calib = mycalib(robot,J,Xm) - kinematics calibration
%
% Input parameters: 
%   robot: struct  ... description of the manipulator. You can ignore and use 
%                      description and parameters from your variant.
%   J: [2 x n]     ... joint coordinates. Each column of J(:,i) contains 2 joint 
%                      coordinates (angles and or displacements). Configuration
%                      is defined by assignment.
%   Xm: [2 x n]    ... end position of manipulator mesured by calibration
%                      measurement tool. Each column coresponds to same
%                      column in matrix J (joint coordinates).
%
% Output parameters: 		
%	calib: struct  ... description of calibrated manipulator. The structure
%	                   is similar to structure robot but updated by
%	                   calibration.
%
% All angles are  in radians !

% Filter out all NaN columns
width = size(Xm, 2);
cols_to_erase = 0;
cols_to_erase_vec = zeros(1, width);

for column = 1:width
    if isnan(Xm(1, column)) || isnan(Xm(2, column))
        cols_to_erase = cols_to_erase + 1;
        cols_to_erase_vec(cols_to_erase) = column;
    end    
end
cols_to_erase_vec = cols_to_erase_vec(1:cols_to_erase);
Xm(:, cols_to_erase_vec) = [];
J(:, cols_to_erase_vec) = [];

% Preset of callibration parameters
calib.struct    = robot.struct;
calib.links     = robot.links;
calib.origins   = robot.origins;
calib.rotations = robot.rotations;
calib.rotations(isnan(calib.rotations)) = 0;

% Initial guess of calibrated parameters is based on current robot parameters
d = extract_robot_params(robot);
iterations = 1:25;
err_vector = zeros(size(iterations));
for iteration = iterations
   %fprintf("Iteration %d:\n", iteration);
   jacob = calculate_jacobian(Xm, J, d);
   %fprintf('Jacobian condition number %.2f\n', cond(jacob * jacob'));
   err = error_function(Xm, J, d);
   err_vector(iteration) = norm(err);
   %fprintf("r = %.4f\n", norm(err));
   
   delta_d = jacob' * ((jacob * jacob') \ err);
   d = d - delta_d;
end

% semilogy(iterations, err_vector);
% title('Celková chyba jako funkce iterace')
% xlabel('Pořadové číslo iterace')
% ylabel('Norma chybového vektoru')

% Calibration finished, store results
calib.links(2,1) = d(1);
calib.links(2,2) = d(2);
calib.links(1,2) = d(3);

calib.rotations = d(4:5)';
calib.origins = [d(6:7) d(8:9)];
end

function jacobian = calculate_jacobian(X, J, d)
    jacobian = zeros(2, length(d));
    for point = 1:size(X, 2)
        jacobian = jacobian + calculate_jacobian_one(X(:, point), J(:, point), d);
    end
end

function jacobian = calculate_jacobian_one(X, joint_coords, d)
    l21 = d(1);
    l22 = d(2);
    l12 = d(3);
    gamma1 = d(4);
    gamma2 = d(5);
    p1x = d(6);
    p1y = d(7);
    p2x = d(8);
    p2y = d(9);
    
    xx = X(1);
    xy = X(2);
    
    d1 = joint_coords(1);
    theta2 = joint_coords(2);
    
    o1x = p1x + d1 * cos(gamma1);
    o1y = p1y + d1 * sin(gamma1);
    
    o2x = p2x + l12 * cos(theta2 + gamma2);
    o2y = p2y + l12 * sin(theta2 + gamma2);
    
    
    f1_p1x = -2*(xx - o1x);
    f1_p1y = -2*(xy - o1y);
    
    f1_p2x = 0;
    f1_p2y = 0;
    
    f1_gamma1 = -2*(xx - o1x)*d1*(-sin(gamma1));
    f1_gamma2 = 0;
    
    f1_l21 = -2*l21;
    f1_l22 = 0;
    f1_l12 = 0;
    
    
    f2_p1x = 0;
    f2_p1y = 0;
    
    f2_p2x = -2*(xx-o2x);
    f2_p2y = -2*(xy-o2y);
   
    f2_gamma1 = 0;
    f2_gamma2 = -2*(xx-o2x)*l12*(-sin(theta2+gamma2)) - 2*(xy-o2y)*l12*cos(theta2+gamma2);
    
    f2_l21 = 0;
    f2_l22 = -2*l22;
    f2_l12 = -2*(xx - o2x)*cos(theta2 + gamma2) - 2*(xy - o2y)*sin(theta2 + gamma2);
    
    jacobian = [f1_l21 f1_l22 f1_l12 f1_gamma1 f1_gamma2 f1_p1x f1_p1y f1_p2x f1_p2y;
                f2_l21 f2_l22 f2_l12 f2_gamma1 f2_gamma2 f2_p1x f2_p1y f2_p2x f2_p2y];
end



