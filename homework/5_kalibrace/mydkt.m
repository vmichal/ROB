function [XC] = mydkt(robot, J)
    P1 = robot.origins(:, 1);
    P2 = robot.origins(:, 2);
    
    alfa1 = robot.rotations(1);
    assert(isnan(robot.rotations(2)));
    assert(all(robot.struct == [1 2])); % first translation and second rotation
    
    l = robot.links;
    l21 = l(2,1);
    l22 = l(2,2);
    l12 = l(1,2);
    assert(isnan(l(1,1)));
    
    % anonymous functions to simplify the notation
    rotate2D = @(angle) [cos(angle), -sin(angle); sin(angle), cos(angle)];
    translate = @(vec) [rotate2D(0), vec; 0 0 1];
    rotate = @(angle) [rotate2D(angle), [0;0]; 0 0 1];
    hom2cart = @(vec) vec(1:2) / vec(3);

    n = size(J, 2);
    XC = {zeros(2, n), zeros(2,n)};
    for column = 1 : n
        d1 = J(1, column);
        theta2 = J(2, column);
        T_world_to_A = translate(P1) * rotate(alfa1) * translate([d1 ; 0]);
        T_world_to_B = translate(P2) * rotate(theta2) * translate([l12 ; 0]);
        A = hom2cart(T_world_to_A * [0;0;1]);
        B = hom2cart(T_world_to_B * [0;0;1]);
        
        % convert homogenous corrdinates to cartesian
        % two options for X
                
        AB = norm(A - B);
        
        AB_angle = atan2(B(2) - A(2), B(1) - A(1));
        
        % we know three sides of a triangle. For the angle located at A:
        fi = acos((l22^2 - l21^2 - AB^2) / (-2 * l21 * AB));
        
        T_A_to_X2 = rotate(- alfa1) * rotate(AB_angle - fi) * translate([l21;0]);
        T_A_to_X1 = rotate(- alfa1) * rotate(AB_angle + fi) * translate([l21;0]);
        X1 = hom2cart(T_world_to_A * T_A_to_X1 * [0;0;1]);
        X2 = hom2cart(T_world_to_A * T_A_to_X2 * [0;0;1]);
        
        if any(imag(X1) ~= 0)
           X1 = [NaN; NaN]; 
        end
        if any(imag(X2) ~= 0)
           X2 = [NaN; NaN]; 
        end
        
        XC{1}(:, column) = X1;
        XC{2}(:, column) = X2;
    end
end

