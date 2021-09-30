function [E] = myR2EA(R)
% Convert rotation matrix to euler angles
    % E(2) can be calculated from R(3,1) and R(3,3)
    epsilon = eps();
    
    % use 1 equation to find pos theta2
    cos2 = -R(3,3);    
    
    degenerate2 = abs(abs(cos2) - 1) < epsilon;
    if degenerate2
        % cos2 is +/- one, there is only one option for theta2
        if cos2 > 0
            theta2 = 0;
            theta1 = atan2(R(2,1), R(1,1));
            theta3 = 0;
        else
            theta2 = pi;
            theta1 = atan2(-R(2,1), -R(1,1));
            theta3 = 0;
        end
    else
        % there are two options for theta2        
        pos2 = [acos(cos2), -acos(cos2)];
        %fprintf('theta2 may be %d or %d\n', pos2);
        
        % use 2 equations to find pos theta1
        cos1 = R(1,3) ./ sin(pos2);
        sin1 = R(2,3) ./ sin(pos2);
        pos1 = atan2(sin1, cos1);
        %fprintf('theta1 may be %d or %d\n', pos1);
    
        % use 2 euqations to find pos theta3
        sin3 = -R(3,2) ./ sin(pos2);
        cos3 = R(3,1) ./ sin(pos2);    
        pos3 = atan2(sin3, cos3);
        %fprintf('theta3 may be %d or %d\n', pos3);
    
        % 4 equations remaining to verify solution
        %cos(pos1) .* cos(pos2) .* cos(pos3) + sin(pos1) .* sin(pos3)
        %sin(pos1) .* cos(pos2) .* cos(pos3) - cos(pos1) .* sin(pos3)
    
        %cos(pos3).*sin(pos1) - cos(pos1) .* cos(pos2) .* sin(pos3)
        %-cos(pos3).*cos(pos1) - sin(pos1) .* cos(pos2) .* sin(pos3)
    
        % choose the first suitable solution
        theta1 = pos1(1);
        theta2 = pos2(1);
        theta3 = pos3(1);
        
    end        

    E = [theta1;theta2;theta3];      
end

