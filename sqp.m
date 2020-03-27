function [db,dlambda] = sqp(points3d,camera,lambda)
    global Np B
    diag_element = [];
    nnL = [];
    bsum = 0;
    for i = 1:Np
        Ki = points3d(i).cameraset;
        if (length(Ki) > 1)
            for j = 1:length(Ki)
                index = find(camera(Ki(j)).idset == i);
                for k = 1:2
                    Cijkn = camera(Ki(j)).Cset(k,index);
                    bijkn = camera(Ki(j)).bitset(k,index);
                    diag_element = [diag_element 2*log(2)^2*Cijkn*(2^(2*bijkn+1)+2^bijkn)/(2^bijkn-1)^4];
                    nnL = [nnL; -2*log(2)*Cijkn*2^bijkn/(2^bijkn-1)^3 + lambda];
                    bsum = bsum + bijkn;
                end
            end
        end
    end
    len = length(diag_element);
    Bmat = [diag(diag_element) ones(len,1); ones(1,len) 0];
    nnL = [nnL;bsum-B];
    delta = -inv(Bmat)*nnL;
    db = delta(1:end-1);
    dlambda = delta(end);
end