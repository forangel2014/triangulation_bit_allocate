classdef Camera < handle
    properties
        id;
        X;
        R;
        K;
        P;
        W1;
        W2;
        idset;
        pixelset;
        bitset;
        Cset;
    end
    methods
        function camera = Camera(id1,x,r,k,w1,w2)
            camera.id = id1;            
            camera.X = x;
            camera.R = r;
            camera.K = k;
            camera.W1 = w1;
            camera.W2 = w2;
            camera.P = k*[r' -r'*x];
        end
        function select_points(camera,points3d)
            camera.idset = [];
            for i = 1:length(points3d)
                pixel = project(camera,points3d(i));
                if (0<pixel(1) && pixel(1)<camera.W1...
                    && 0<pixel(2) && pixel(2)<camera.W2)
                    camera.idset = [camera.idset i];
                end
                len = length(camera.idset);
            end
            if (len > 50)
                order = randperm(len);
                camera.idset = camera.idset(order(1:25+unidrnd(25)));
            end
        end
        function pixel = project(camera,point3d)
            pixel = camera.P*[point3d.X;1];
            pixel = pixel(1:2)/pixel(3) + rand(2,1)*2-1;
        end
        function project_all(camera,points3d)
            for i = 1:length(camera.idset)
                camera.pixelset(:,i) = project(camera,points3d(camera.idset(i)));
            end
        end
        function quantify(camera)
            for i = 1:length(camera.idset)
                delta1 = 2*camera.W1/(2^camera.bitset(1,i)-1);
                delta2 = 2*camera.W2/(2^camera.bitset(2,i)-1);
                x = camera.pixelset(1,i);
                y = camera.pixelset(2,i);
                n1 = round(x/delta1);
                n2 = round(y/delta2);
                temp = unifrnd(0,1);
                if (temp < (x-n1*delta1)/delta1)
                    camera.pixelset(1,i) = (n1+1)*delta1;
                else
                    camera.pixelset(1,i) = n1*delta1;
                end
                if (temp < (y-n2*delta2)/delta2)
                    camera.pixelset(2,i) = (n2+1)*delta2;
                else
                    camera.pixelset(2,i) = n2*delta2;
                end
            end
        end
        function bit_allocate(camera,bit)
            camera.bitset = bit;
        end
        function initialize(camera,points3d,init_bit)
            camera.select_points(points3d);
            camera.project_all(points3d);
            camera.bit_allocate(ones(size(camera.pixelset))*init_bit);
            camera.quantify;
        end
        function set_C(camera,C,index)
            camera.Cset(:,index) = C;
        end
    end
end