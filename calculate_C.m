function calculate_C(points3d,camera)
    global Np
    for i = 1:Np
        X1 = [points3d(i).X;1];
        p21 = [];
        mat = [];
        for j = 1:length(points3d(i).cameraset)
            p = camera(points3d(i).cameraset(j)).P;
            p21 = [p21;p(2,:);p(1,:)];          
        end
        if (size(p21,1) >= 4)
            mat = inv(p21'*p21);
        else
            mat = zeros(4,4);
        end
        for j = 1:length(points3d(i).cameraset)
            c = camera(points3d(i).cameraset(j));
            p = c.P;
            index = find(i == c.idset);
            C1 = c.W1^2*sum((mat*p(1,:)'*p(3,:)*X1).^2);
            C2 = c.W2^2*sum((mat*p(2,:)'*p(3,:)*X1).^2);
            c.set_C([C1;C2],index);
        end
    end
end