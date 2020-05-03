% Initial input
input = dir('D:\Coursework\Final-Year-Project-2\Central slices\Skulls (edges)\');
output = 'D:\Coursework\Final-Year-Project-2\Central slices\Skulls (edges)\';

im_array = [];
count = 0;

% Get subfolders
for i = 3:length(input)
    if contains(input(i).name, 'control')
        count = count + 1;
        im = imread(strcat(input(i).folder, '\', input(i).name));
        im = imresize(im, [320 320]);
        im_array(:,:,count) = im;
    end   
end

av = mean(im_array, 3);
av = av>0;
imshow(av);

% Generate image
filename = strcat(output, 'base.png');
imwrite(av, filename);

% Generate point cloud
[row, col] = find(av);
points = [row, col, repmat(1,length(row),1)];
pt_cloud = pointCloud(points);
filename_pc = strcat(output, 'Point clouds\base');
pcwrite(pt_cloud,filename_pc,'PLYFormat','binary');

pcshow(pt_cloud);