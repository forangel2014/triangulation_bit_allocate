function update_b(points3d,camera,db,mu)
    global Np
    n = 1;
    for i = 1:Np
        Ki = points3d(i).cameraset;
        if (length(Ki) > 1)
            for j = 1:length(Ki)
                index = find(camera(Ki(j)).idset == i);
                for k = 1:2
                    camera(Ki(j)).bitset(k,index) = camera(Ki(j)).bitset(k,index) + mu*db(n);
                    n = n+1;
                end
            end
        end
    end
end