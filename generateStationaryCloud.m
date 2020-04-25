input = dir('D:\Coursework\Final-Year-Project-2\Central slices\Masks (skulls)\pt_clouds\');
output_folder = 'D:\Coursework\Final-Year-Project-2\Central slices\Skulls (transformed)\';

files = input(3:end);
dataset = [];
num = [];
point_clouds = [];

for i = 1:length(files)
    address = strcat(files(i).folder, '/', files(i).name);
    point_clouds = [point_clouds ; pcread(address)];
    
    num = [num, point_clouds(i).Count];
end

minimum = min(num);

for j = 1:length(point_clouds)
    if (point_clouds(j).Count ~= minimum)
        percentage = minimum/(point_clouds(j).Count);
        ptCloudOut = pcdownsample(point_clouds(j),'random',percentage);
    else
        ptCloudOut = point_clouds(j);
    end
    
    points = ptCloudOut.Location;
    points = sortrows(points, [1 2]);
    
    scatter(points(:,2), points(:,1));
    xlim([0 320])
    ylim([0 320])
    
    dataset(:,:,j) = points;
end

average_cloud = median(dataset,3);

scatter(average_cloud(:,2), average_cloud(:,1));
xlim([0 320])
ylim([0 320])