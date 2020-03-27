function [R,t] = generate_random_camera_pose(center)
    t = rand(3,1)*800-400;
    while (in_pc(t))
        t = rand(3,1)*400-200;
    end
    z_target = center - t + rand(3,1)*200-100;
    z_target = z_target/norm(z_target);
    % z_target = R*[0;0;1]
    phi = acos(z_target(3));
    sin_theta = z_target(1)/sin(phi);
    cos_theta = -z_target(2)/sin(phi);
    R = [cos_theta -sin_theta*cos(phi) sin_theta*sin(phi);
        sin_theta cos_theta*cos(phi) -cos_theta*sin(phi);
        0 sin(phi) cos(phi)];
end