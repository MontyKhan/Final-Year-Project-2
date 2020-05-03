% Establish n as the length of the dataset.
n = length(data);

% Declare matrices.
true_labels = [];
predict_labels = [];
accuracy = [];

values = [];
for i = 1:n
    values = [values ; data(i).tform3D(:)'];
end

coeff = pca(values');

% Start for loop for leave-one-out cross validation.
for i = 1:n

    % Declare matrices.
    training_data = [];
    labels = [];
    results = [];
    
    affected_points = [];
    control_points = [];

    % Add data to training set, while leaving one out to test with.
    for j = 1:n
        if (j == i)
            % Leave one out
            true_labels = [true_labels ; string(data(j).class)];
            continue;
        else
            % Add to dataset
            training_data = [training_data ; coeff(j,[1:3])];
            labels = [labels ; string(data(j).class)];
            if (strcmp(string(data(j).class), 'affected'))
                affected_points = [affected_points ; coeff(j,[1:3])];
            elseif (strcmp(string(data(j).class), 'control'))
                control_points = [control_points ; coeff(j,[1:3])];
            end
        end
    end

    % Fit line for SVM
    % [Mdl, FitInfo] = fitclinear(training_data,labels, 'ClassNames',{'control','affected'});
    Mdl = fitcsvm(training_data,labels, 'ClassNames',{'control','affected'}, 'OptimizeHyperparameters', 'auto');

    % Set test data from data earlier excluded.
    test_data = coeff(i,[1:3]);
    test_label = string(data(i).class);

    % Test SVM.
    [label,score] = predict(Mdl,test_data);
    
    % Record results
    predict_labels = [predict_labels ; label];
    accuracy = [accuracy ; score];
    
end

% Create table of results
table(true_labels(:),predict_labels(:),accuracy(:,2),'VariableNames',...
    {'TrueLabel','PredictedLabel','Score'})