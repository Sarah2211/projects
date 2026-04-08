function [dataTrain, dataTest, target_mu, target_sigma] = preprocess(data)

disp("Preprocessing & Splitting Data...");

% Remove missing values
data = rmmissing(data);

% Keep only relevant columns (Swapped AQI for O3)
vars = data.Properties.VariableNames;
selected = intersect(vars, {'COAQIValue','OzoneAQIValue','NO2AQIValue','PM2_5AQIValue'});
data = data(:, selected);

% Split 80% train, 20% test.
splitIdx = floor(0.8 * height(data));
dataTrain = data(1:splitIdx, :);
dataTest = data(splitIdx+1:end, :);

% Find numeric columns
numericCols = varfun(@isnumeric, dataTrain, 'OutputFormat', 'uniform');

% Convert to arrays
trainArr = table2array(dataTrain(:, numericCols));
testArr = table2array(dataTest(:, numericCols));

% Calculate Mean (C) and Std Dev (S) from training data
[trainArrNorm, C, S] = normalize(trainArr);

% Apply to testing data
testArrNorm = (testArr - C) ./ S;

% Replace columns
dataTrain{:, numericCols} = trainArrNorm;
dataTest{:, numericCols} = testArrNorm;

% Extract PM2_5 parameters for the LSTM un-normalizing step
colNames = dataTrain.Properties.VariableNames(numericCols);
target_idx = find(strcmp(colNames, 'PM2_5AQIValue'));
target_mu = C(target_idx);
target_sigma = S(target_idx);

disp("Preprocessing Done.");

end