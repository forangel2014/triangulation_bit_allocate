function [triangle_points,id] = my_triangulation(camera)
    global Np Nc
    n = 1;
    for i = 1:Np
        A = [];
        for j = 1:Nc
            arr = camera(j).idset == i;
            if (any(arr))
                index = find(arr);
                pixel = camera(j).pixelset(:,index);
                P = camera(j).P;
                A = [A;pixel(2)*P(3,:)-P(2,:);P(1,:)-pixel(1)*P(3,:)]; 
            end
        end
        if (size(A,1) >= 4)
            [~,~,v] = svd(A);
            triangle_points(:,n) = v(1:3,end)/v(end,end);
            id(n) = i;
            n = n+1;
        end
    end
end