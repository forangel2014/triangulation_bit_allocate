clc,clear all,close all;
%%
%points
global Np Nc B
Np = 1000;
points_3d = [100 0 0; 0 100 0; 0 0 100]*rand(3,Np) + [-50;-50;50];
center = [0;0;100];
for i = 1:Np
    points3d(i) = Point3D(i,points_3d(:,i));
end
%cameras
Nc = 100;
W1 = 500;
W2 = 400;
K = [568.996140852000,0,W1/2;
    0,568.988362396000,W2/2;
    0,0,1];
B = 0;
init_bit = 6;
for j = 1:Nc
    [R,X] = generate_random_camera_pose(center);
    camera(j) = Camera(j,X,R,K,W1,W2);
    initialize(camera(j),points3d,init_bit);
    B = B + 2*length(camera(j).idset)*init_bit;
end
for i = 1:Np
    points3d(i).set(camera);
end
%% 均匀分配量化比特
[triangle_points_ref,id_ref] = my_triangulation(camera);
MSPE_ref = mean(sum((points_3d(:,id_ref)-triangle_points_ref).^2,1));
calculate_C(points3d,camera);
eps_ref = calculate_eps(points3d,camera);
%% 优化比特分配
N = 50;
lambda = 1;
mu = 0.5;
for n = 1:N
    eps(n) = calculate_eps(points3d,camera);
    [db,dlambda] = sqp(points3d,camera,lambda);
    update_b(points3d,camera,db,mu);
    lambda = lambda + mu/sqrt(n)*dlambda;
    for j = 1:Nc
        camera(j).project_all(points3d);
        camera(j).quantify;
    end
    [triangle_points,id] = my_triangulation(camera);
    MSPE(n) = mean(sum((points_3d(:,id)-triangle_points).^2,1));
end
figure;
plot(0:N-1,eps_ref*ones(1,N),'r');
hold on
plot(0:N-1,eps,'b');
%title("损失函数关于迭代次数曲线");
xlabel("迭代次数n");
ylabel("损失函数epsilon");
legend("均匀分配比特","优化比特分配");
figure;
plot(0:N-1,MSPE_ref*ones(1,N),'r');
hold on
plot(0:N-1,MSPE,'b');
%title("平均重建误差关于迭代次数曲线");
xlabel("迭代次数n");
ylabel("平均重建误差MSPE");
legend("均匀分配比特","优化比特分配");