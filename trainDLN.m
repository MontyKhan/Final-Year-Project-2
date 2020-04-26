function [accuracy] = trainDLN(DLN,inputSize,dataset)
% trainDLN - Trains a DLN modified through bottleneck feature extraction to
%            process a new dataset.
% Arguments: DLN - Modified DLN
%            inputSize - Dimensions of expected images
%            dataset - Filepath to image dataset
% Returns:   accuracy - Accuracy of the network as a decimal value.

% Identify location of dataset (e.g. cropped images)
% Categories are taken from the names of the subfolders
imds = imageDatastore(dataset, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

% Split dataset into training and testing sets.
% We're using leave-one-out cross-validation, so testing set will contain
% only one sample.
size = length(imds.Files);

% Initialise vector
accuracy_array = [];
true_labels = [];
predict_labels = [];
certainty = [];

% Try using different image from dataset to test each time, then average
% probabilities
for n = 1:(size)
    % Partition test set and training set, using leaving one out cross
    % validation
    imdsTest = imageDatastore(imds.Files(n), ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames');
    train_data = [[1:n-1], [n+1:size]];
    imdsTrain = imageDatastore(imds.Files(train_data), ...
        'IncludeSubfolders',true, ...
        'Labels',imds.Labels(train_data));
    
    % Partition validation set in addition to training set.
    [imdsValidation, imdsTrain] = splitEachLabel(imdsTrain,1,'randomized');
    
    % Training set identified
    augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);
    augimdsValidation = augmentedImageDatastore(inputSize(1:2), imdsValidation);
    augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain);
    
    % Assign charateristics of training model.
    miniBatchSize = 5;
    valFrequency = floor(numel(augimdsTrain.Files)/miniBatchSize);
    options = trainingOptions('sgdm', ...
        'MiniBatchSize',miniBatchSize, ...
        'MaxEpochs',3, ...
        'InitialLearnRate',3e-4, ...
        'Shuffle','every-epoch', ...
        'ValidationData',augimdsValidation, ...
        'ValidationFrequency',3, ...
        'Verbose',false, ...
        'Plots','training-progress', ...
        'OutputFcn',@(info)saveIfDone(info, n));
    
    % Train network
    net = trainNetwork(augimdsTrain,DLN,options);
    
    close all hidden;
    
    % Test network and obtain accuracy readings.
    [YPred,probs] = classify(net,augimdsTest);
    certainty = [certainty ; probs];
    predict_labels = [predict_labels ; YPred];
    iter_accuracy = mean(YPred == imdsTest.Labels);
    classification.actual = imdsTest.Labels;
    true_labels = [true_labels ; imdsTest.Labels];
    classification.calculated = YPred;
    accuracy_array = [accuracy_array; [imdsTest.Labels, YPred]];
    
    % Obtain CAM
    classes = net.Layers(end).Classes;
    layerName = 'relu5_4';
    
    im = imread(string(augimdsTest.Files(1)));
    imResized = imresize(im,[inputSize(1),NaN]);
    imageActivations = activations(net,imResized,layerName);
    
    h = figure('Units','normalized','Position',[0.05 0.05 0.9 0.8],'Visible','on');
    
    imResized = imresize(im,[inputSize(1), NaN]);
    imageActivations = activations(net,imResized,layerName);
    
    scores = squeeze(mean(imageActivations,[1 2]));
    
    [~,classIds] = maxk(scores,3);
    CAM = imageActivations(:,:,classIds(1));
    
    im = imresize(im,[224,224]);
    subplot(1,2,1)
    imshow(im)
    
    subplot(1,2,2)
    % CAMshow(im,classActivationMap)
    
    CAM = imresize(CAM,inputSize(1:2));
    
    minimum = min(CAM(:));
    maximum = max(CAM(:));
    CAM = (CAM-minimum)/(maximum-minimum);
    
    CAM(CAM<0.2) = 0;
    cmap = jet(255).*linspace(0,1,255)';
    CAM = ind2rgb(uint8(CAM*255),cmap)*255;
    
    combinedImage = double(rgb2gray(im))/2 + CAM;
    % combinedImage = normalizeImage(combinedImage)*255;
    
    minimum = min(combinedImage(:));
    maximum = max(combinedImage(:));
    combinedImage = (combinedImage-minimum)/(maximum-minimum);
    combinedImage = combinedImage*255;
    
    imshow(uint8(combinedImage));
    
    [filepath,patientName,ext] = fileparts(string(augimdsTest.Files(1)));
    title(patientName);
    
    drawnow
    
    saveas(h, strcat('D:\Coursework\Final-Year-Project-2\Data\CAMs\', patientName, '.png'));
end

% Calculate overall accuracy.
% accuracy = mean(accuracy_array)
accuracy = mean(accuracy_array(:,1) == accuracy_array(:,2));

% Create table of results
table(true_labels(:),predict_labels(:),certainty(:, 1),certainty(:,2),'VariableNames',...
    {'TrueLabel','PredictedLabel','Affected Score','Control score'})

