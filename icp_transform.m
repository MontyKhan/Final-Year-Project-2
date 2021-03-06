function [output] = icp_transform(input)

    input = dir('D:\Coursework\Final-Year-Project-2\Central slices\Skulls (edges)\Point clouds');
    base_mask = 'D:\Coursework\Final-Year-Project-2\Central slices\Skulls (edges)\base.png';
    output_folder = 'D:\Coursework\Final-Year-Project-2\Central slices\Skull edges (transformed)\';

    point_clouds = input(3:end);
    for n = 1:length(point_clouds)
        if (strcmp(point_clouds(n).name,'base.ply'))
            point_clouds(n) = [];
            break;
        end
    end

    image = imread(base_mask);
    [row, col] = find(image);
    base_cloud = pointCloud([row, col, repmat(1,length(row),1)]);
    filename_pc = strcat('D:\Coursework\Final-Year-Project-2\Central slices\Skulls (edges)\Point clouds', 'base');
    pcwrite(base_cloud,filename_pc,'PLYFormat','binary');

    output = [];

    for i = 1:length(point_clouds)
        address = strcat(point_clouds(i).folder, '/', point_clouds(i).name);
        point_cloud = pcread(address);
        [tform,movingreg,rmse] = pcregistericp(point_cloud,base_cloud,'Extrapolate',true);
        
        tform_2D = tform.T;
        
        % Convert to 2D
        tform_2D(4,:) = [];
        tform_2D(:,4) = [];
        tform_2D(3,2) = 0;
        tform_2D(2,3) = 0;

        info.name = point_clouds(i).name;
        info.class = '';
        info.tform2D = tform_2D;
        info.tform3D = tform.T;
        info.rmse = rmse;
        
        % Classify data based on filename.
        if (contains(info.name, 'affected'))
            info.class = 'affected';
        elseif (contains(info.name, 'control'))
            info.class = 'control';
        else
            info.class = 'error';
        end
        
        tform_2D(tform_2D < 0.0001) = 0;
        image_transform = affine2d(tform_2D);
        filename = erase(point_clouds(i).name, '.ply');
        
        subject = strcat('D:\Coursework\Final-Year-Project-2\Central slices\Skulls (edges)\', filename, '.png');
        if ~(isfile(subject))
            subject = strcat('D:\Coursework\Final-Year-Project-2\Central slices\Skulls (edges)\', filename, '.png');
        end
        
        output_name = strcat(output_folder, filename, '.png');
        
        image = imread(subject);
        new_image = imwarp(image, image_transform);
        imwrite(new_image, output_name);
    
        output = [output ; info];
    end
end