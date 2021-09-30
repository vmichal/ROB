function [R] = myEA2R(E)
% Converts euler angles to rotation matrix

% Simply rewrite the formulae given in the problem statement.
    
    col1 = [cos(E(1))*cos(E(2))*cos(E(3)) + sin(E(1))*sin(E(3));
            cos(E(2))*cos(E(3))*sin(E(1)) - cos(E(1))*sin(E(3));
            cos(E(3))*sin(E(2))];
    col2 = [cos(E(3))*sin(E(1)) - cos(E(1))*cos(E(2))*sin(E(3));
            -cos(E(1))*cos(E(3)) - cos(E(2))*sin(E(1))*sin(E(3));
            -sin(E(2))*sin(E(3))];

    col3 = [cos(E(1))* sin(E(2));
            sin(E(1)) * sin(E(2));
            -cos(E(2))];
        
    R = [col1 col2 col3];
end

