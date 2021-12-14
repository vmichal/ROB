function [JC] = myikt(robot, Xarray)
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
    
    % four unique solutions (two possible values of d1 and two possible values of theta2)
    n = size(Xarray, 2);
    JC = {zeros(2, n), zeros(2, n), zeros(2, n), zeros(2, n)};
    for column = 1 : n
        Xx = Xarray(1, column);
        Xy = Xarray(2, column);
        X = [Xx;Xy];
        
        % Calculate d1:
        beta = atan2(Xy - P1(2), Xx - P1(1));
        beta_compl = alfa1 - beta;
        b = -2 * norm(X - P1) * cos(beta_compl);
        c = norm(X - P1)^2 - l21^2;
        
        if b^2-4*c < 0
            % imaginary length? probably not. This configuration has no solutions.
            for row = 0 : 3
               JC{row + 1}(:, column) = [NaN; NaN]; 
            end
            continue;
        end
        d1 = (-b + [1;-1]*sqrt(b^2-4*c))/2;
        
        % Calculate theta2:
        gamma = atan2(Xy - P2(2), Xx - P2(1));
        gamma_compl = acos((l22^2 - norm(P2-X)^2 - l12^2) / (-2 * l12 * norm(P2-X)));
        gamma_compl = gamma_compl * [1;-1];
        theta2 = gamma - gamma_compl;
        
        for row = 0 : 3
            theta_index = int16(idivide(row, int16(2))) + 1;
            d_index = int16(mod(row, 2) + 1);
            new_column = [d1(d_index); theta2(theta_index)];
            if any(imag(new_column) ~= 0)
                new_column = [NaN; NaN];
            end
            JC{row + 1}(:, column) = new_column;
        end
        
        % Calculate values of d:
        %{
        deltaX = P1(1) - Xx;
        deltaY = P1(2) - Xy;
        c = cos(alfa1);
        s = sin(alfa1);
        e = c^2 + s^2;
        f = 2*deltaX*c + 2*deltaY*s;
        g = deltaX^2 + deltaY^2 - l21^2;
        assert(abs(e-1) < 10e-8);
        
        D = f^2 - 4 * e * g;
        d = (-f + sqrt(D) * [1;-1]) / (2*e);
        %}
        
    end    
end