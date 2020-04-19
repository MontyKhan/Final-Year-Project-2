% Threshold_CTs.m
% Description: Loads DICOM files from an absolute address in the expected
%              format, and generates a set of binary masks and a 3D point 
%              cloud representing each mask as a layer.

close all;                                                      % Close open windows and figures to prevent clutter.

% Initialize vectors
imageVector = [];
mask_3d = [];

% Set paths
input1 = dir('D:\Coursework\Final-Year-Project-2\Central slices\Skulls (cropped)\affected');
input2 = dir('D:\Coursework\Final-Year-Project-2\Central slices\Skulls (cropped)\control');
output = 'D:\Coursework\Final-Year-Project-2\Central slices\Masks (skulls)\';
pt_folder = strcat(output, 'pt_clouds\');

% Create list of relevant files.
dataset = [input1(3:end) ; input2(3:end)];

for n = 1:length(dataset)
    %% Generate masks
    filename = dataset(n).name;
    directory = dataset(n).folder;
    image = imread(fullfile(directory,filename));
    image = rgb2gray(image);
    filename = erase(filename, '.png');
    
    mask = (image > 45);                                       % Threshold out values below 300 (i.e. soft tissue)
    
    for i = 1:10
        seOpen = strel('disk',1);                                   % Set dilate
        seClose = strel('disk',1);                                  % Set erode
        cleanMask = imopen(mask, seOpen);                           % Dilate
        cleanMask = imclose(cleanMask,seClose);                     % Erode
    end
    
    % imshow(cleanMask)
    
    %% IF LOOKING TO COMPARE IMAGES
    % imageDisplay = mat2gray(image);                           % Convert original image to grayscale
    % outdisplay = montage({imageDisplay mask cleanMask}  ...   % Create new image of original image, mask and cleaned mask in a row
    %                      , 'Size', [1 3] ...              
    %                      ,'DisplayRange',[]);          
    % filename = strcat(output,'com_',filename,'.png');               % Save
    % saveas(outdisplay,filename);

    %% IF LOOKING TO SAVE MASKS
    filename_mask = strcat(output,'th_',filename,'.png');
    imwrite(cleanMask,filename_mask);
      
    %% Convert to list of coordinates and create point cloud
    [row, col] = find(cleanMask);
    pt_cloud = pointCloud([row, col, repmat(1,length(row),1)]);
    filename_pc = strcat(pt_folder, filename);
    pcwrite(pt_cloud,filename_pc,'PLYFormat','binary');
end