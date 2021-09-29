function [Xo] = mycart2cyl(Xi)
% Conversion from cartesian coordinates to cylindrical 
    z = Xi(3, :);
    y = Xi(2, :);
    x = Xi(1, :);
    
    rho = sqrt(x.^2 + y.^2);
    alfa = atan2(y, x);
    Xo = [rho; alfa; z];    
end

