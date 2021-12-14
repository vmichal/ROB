function d = extract_robot_params(robot)
d = [
    robot.links(2,1); % l21
    robot.links(2,2); % l22
    robot.links(1,2); % l12
    robot.rotations(1); % gamma1
    0;                  % gamma2
    robot.origins(:,1); % [p1x;p1y]
    robot.origins(:,2)  % [p2x;p2y]
    ];
end

