function generateEdgeCloud3D(path)

% Initial input
input = dir(path);
output = 'D:\Coursework\Final-Year-Project-2\MRIs\Edges\';

% Get subfolders
directories = [];
for i = 3:length(input)
    subfolder = strcat(path, '\', string(input(i).name), '\');
    co_ords = [];
    if (input(i).isdir())
        subfolder = dir(subfolder);
        
        for j = 3:length(subfolder)
            filepath = strcat(subfolder(j).folder, '\', subfolder(j).name);
            im = imread(filepath);
            % im = rgb2gray(im);
            [EdgeMag, EdgeDir] = imgradient(im);
            
            % imshowpair(EdgeMag, EdgeDir, 'montage');
            % imshow(EdgeMag, [min(EdgeMag(:)) max(EdgeMag(:))]);
            EdgeMag = mat2gray(EdgeMag, [min(EdgeMag(:)) max(EdgeMag(:))]);
            EdgeMag = (EdgeMag > 0.1);
            
            fileName = erase(input(i).name,'.png');
            % patientName = filename(1:(end-6));

            output_patient = strcat(output, fileName, '\');

            if ~(isfolder(output_patient))
                mkdir(string(output_patient));
            end

            imwrite(EdgeMag,strcat(output_patient,fileName, '_', string(j-2), '.png'));

            % Generate point cloud
            [row, col] = find(EdgeMag);
            co_ords = [co_ords ; [row, col, repmat((j-3)*2.7, size(row,1), 1)]];
        end
        
        pt_cloud = pointCloud(co_ords);
        filename_pc = strcat(output, 'Point clouds\', fileName);
        pcwrite(pt_cloud,filename_pc,'PLYFormat','binary');
    end
    
end