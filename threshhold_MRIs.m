% Threshold_CTs.m
% Description: Loads DICOM files from an absolute address in the expected
%              format, and generates a set of binary masks and a 3D point 
%              cloud representing each mask as a layer.

close all;                                                      % Close open windows and figures to prevent clutter.

% Initialize vectors
imageVector = [];
mask_3d = [];

% Set paths
input = 'D:\Coursework\Final-Year-Project-2\Central slices\Images (cropped)';
output = 'D:\Coursework\Final-Year-Project-2\Central slices\Masks';

dataset = dir(input)

for n = 3:length(dataset)
    %% Generate masks
    filename = dataset(n).name;
    image = imread(fullfile(input,filename));
    image = rgb2gray(image);
    [count,x] = imhist(image);
    
    plot(x, count);
    
    mask = (image > 70);                                       % Threshold out values below 300 (i.e. soft tissue)
    imshow(mask);
    seOpen = strel('disk',2);                                   % Set dilate
    seClose = strel('disk',2);                                  % Set erode
    cleanMask = imopen(mask, seOpen);                           % Dilate
    cleanMask = imclose(cleanMask,seClose);                     % Erode
    
    %% IF LOOKING TO COMPARE IMAGES
    % imageDisplay = mat2gray(image);                           % Convert original image to grayscale
    % outdisplay = montage({imageDisplay mask cleanMask}  ...   % Create new image of original image, mask and cleaned mask in a row
    %                      , 'Size', [1 3] ...              
    %                      ,'DisplayRange',[]);
    % cd 'D:\Final Year Project\threshholds2';                  % Change working directory             
    % filename = strcat('th_',num2str(n),'.png');               % Save
    % saveas(outdisplay,filename);

    %% IF LOOKING TO SAVE MASKS
    cd 'D:\Coursework\Final Year Project\threshholds4';
    filename = strcat('th_',num2str(n),'.png');
    imwrite(cleanMask,filename);
      
    %% Convert to list of coordinates
    [row, col] = find(cleanMask);
    mask_3d = [mask_3d ; [row, col, repmat(n*1.3,length(row),1)]];
end

% Create point cloud
ptCloud = pointCloud(mask_3d);

% Show point cloud
pcshow(ptCloud)