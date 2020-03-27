classdef Point3D < handle
    properties
        id;
        X;
        cameraset;
    end
    methods
        function point3d = Point3D(id1,x)
            point3d.id = id1;
            point3d.X = x;
        end
        function set(point3d,camera)
            set = [];
            for j = 1:length(camera)
                if (any(point3d.id == camera(j).idset))
                    set = [set j];
                end
            end
            point3d.cameraset = set;
        end
    end
end