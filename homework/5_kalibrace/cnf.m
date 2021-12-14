function cnf = cnf(d, coords, X)
    [O1, O2] = calculateO(d, coords);
    
    x = @(vec) vec(1);
    y = @(vec) vec(2);
    
    K = (y(O2) - y(O1)) * x(X) - (x(O2) - x(O1)) * y(X) + y(O1)*(x(O2)-x(O1)) - x(O1)*(y(O2)-y(O1));    
    cnf = sign(K);
end