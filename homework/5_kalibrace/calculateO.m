function [O1, O2] = calculateO(d, coords)
    P1 = d(6:7);
    P2 = d(8:9);
    
    alfa1 = d(4);
    
    l21 = d(1);
    l22 = d(2);
    l12 = d(3);
    
    
    d1 = coords(1);
    theta2 = coords(2);
    
    % anonymous functions to simplify the notation
    rotate2D = @(angle) [cos(angle), -sin(angle); sin(angle), cos(angle)];
    translate = @(vec) [rotate2D(0), vec; 0 0 1];
    rotate = @(angle) [rotate2D(angle), [0;0]; 0 0 1];
    hom2cart = @(vec) vec(1:2) / vec(3);
      
    T_world_to_A = translate(P1) * rotate(alfa1) * translate([d1 ; 0]);
    T_world_to_B = translate(P2) * rotate(theta2) * translate([l12 ; 0]);
    A = hom2cart(T_world_to_A * [0;0;1]);
    B = hom2cart(T_world_to_B * [0;0;1]);
    
    O1 = A;
    O2 = B;
end

