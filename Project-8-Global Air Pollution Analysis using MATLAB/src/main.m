clc; clear; close all;

% Load data
data = readtable('../data/GlobalAirPollutionDataset.csv');

disp("Original Data Preview:");
disp(head(data));
disp("Column names:");
disp(data.Properties.VariableNames);
 
% Preprocess AND Split the data
[dataTrain, dataTest, target_mu, target_sigma] = preprocess(data);
 
% Figures 1, 2, 3 — pass both normalized train data AND raw data
visualize_data(dataTrain, data);
 
% Figure 4: Average PM2.5 AQI per City (replaces linear regression)
% Pass raw data so values are on the original scale
evaluate_model([], data);
 
% Figure 5: Pollution Category Breakdown (replaces LSTM)
% Pass raw data so AQI breakpoints are on the original scale
lstm_forecast(data, [], [], []);
 