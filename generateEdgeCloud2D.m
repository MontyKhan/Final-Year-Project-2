function generateEdgeCloud2D(path)

% Initial input
input = dir(path);
output = 'D:\Coursework\Final-Year-Project-2\Central slices\Skulls (edges)\';

% Get subfolders
directories = [];
for i = 3:length(input)
    subfolder = strcat(path, string(input(i).name));
    if (input(i).isdir())
        subfolder = strcat(subfolder, '\');
        generateEdgeCloud(subfolder);
    else
        im = imread(subfolder);
        im = rgb2gray(im);
        [EdgeMag, EdgeDir] = imgradient(im);
        
        % imshowpair(EdgeMag, EdgeDir, 'montage');
        % imshow(EdgeMag, [min(EdgeMag(:)) max(EdgeMag(:))]);
        EdgeMag = mat2gray(EdgeMag, [min(EdgeMag(:)) max(EdgeMag(:))]);
        EdgeMag = (EdgeMag > 0.1);
        
        patientName = erase(input(i).name,'.png');
        imwrite(EdgeMag,strcat(output,patientName,'.png'));
        
        % Generate point cloud
        [row, col] = find(EdgeMag);
        pt_cloud = pointCloud([row, col, repmat(1,length(row),1)]);
        filename_pc = strcat(output, 'Point clouds\', patientName);
        pcwrite(pt_cloud,filename_pc,'PLYFormat','binary');
    end
    
end