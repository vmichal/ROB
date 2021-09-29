function [Xo] = mycyl2cart(Xi)
% Conversion from cartesian coordinates to cylindrical 
    z = Xi(3, :);
    alfa = Xi(2, :);
    rho = Xi(1, :);
    
    x = rho.*cos(alfa);
    y = rho.*sin(alfa);
    Xo = [x;y;z];    
end

