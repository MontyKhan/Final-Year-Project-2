function [lgraph] = modifyDLN(net,numClasses)
% modifyDLN - Takes a pre-existing known DLN and through bottleneck feature
%             extraction adapts it to suit new dataset.
% Arguments:  net (pretrained DLN, as a MATLAB variable)
%             numbclasses (the number of classes into which to sort the data)
% Returns:    lgraph, a LayerGraph containing the modified network

% Create MATLAB compatible layer graph
if isa(net,'SeriesNetwork') 
  lgraph = layerGraph(net.Layers); 
else
  lgraph = layerGraph(net);
end 

% Identify layers we need to replace in the bottleneck
[learnableLayer,classLayer] = findLayersToReplace(lgraph);

% Change number of classes to the input, and increate weights to expedite
% learning of new subject
if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);

% Add in our own classification layer for the new system
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

% Freeze earlier layers to prevent overspecialisation due to small dataset
layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:10) = freezeWeights(layers(1:10));
lgraph = createLgraphUsingConnections(layers,connections);

% lgraph is returned

end

