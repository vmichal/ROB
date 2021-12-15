% Evaluates bond equations with parameters d, measured joint coordinates J
% and measured end effector coordinates Xm
function r = error_function(Xm, J, d)
    l21 = d(1);
    l22 = d(2);
    
    r = zeros(2 * size(Xm, 2), 1);
    for point = 1:size(Xm, 2)
        this_X = Xm(:, point);
        this_J = J(:, point);
        
        [o1, o2] = calculateO(d, this_J);
        o1x = o1(1); o1y = o1(2);
        o2x = o2(1); o2y = o2(2);
        xx = this_X(1); xy = this_X(2);
        
        f1 = (xx - o1x)^2 + (xy - o1y)^2 - l21^2;
        f2 = (xx - o2x)^2 + (xy - o2y)^2 - l22^2;
        
        r(2 * point - 1: 2 * point) = [f1; f2];
    end    
end