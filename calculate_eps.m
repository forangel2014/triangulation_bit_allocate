function eps = calculate_eps(points3d,camera)
    global Np
    eps = 0;
    for i = 1:Np
        Ki = points3d(i).cameraset;
        if (length(Ki) > 1)
            for j = 1:length(Ki)
                index = find(camera(Ki(j)).idset == i);
                for k = 1:2
                    eps = eps + camera(Ki(j)).Cset(k,index)/(2^(camera(Ki(j)).bitset(k,index))-1)^2;
                end
            end
        end
    end
end