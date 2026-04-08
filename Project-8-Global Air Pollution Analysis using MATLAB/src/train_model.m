function model = train_model(data)

disp("Training Model...");

X = data{:, setdiff(data.Properties.VariableNames, {'PM2_5AQIValue'})};
y = data.PM2_5AQIValue;

% Train Linear Regression
model = fitlm(X, y);

disp(model);

end