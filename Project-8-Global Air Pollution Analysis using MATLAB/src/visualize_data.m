function visualize_data(dataTrain, data_raw)
% VISUALIZE_DATA  Generates 4 exploratory figures.
%
%   Figure 1 — PM2.5 AQI distribution histogram
%   Figure 2 — Feature correlation heatmap
%   Figure 3 — Top 15 most polluted countries (avg PM2.5)
%   Figure 4 — Global AQI category breakdown (pie chart)

disp("Generating Visualizations...");

% ------------------------------------------------------------------
% FIGURE 1 — PM2.5 Distribution
% ------------------------------------------------------------------
figure('Name','PM2.5 Distribution','NumberTitle','off', ...
       'Position',[100 100 800 480]);

histogram(data_raw.PM2_5AQIValue, 30, ...
    'FaceColor', [0.25 0.55 0.90], ...
    'EdgeColor', 'white', ...
    'FaceAlpha', 0.85);

xline(50,  '--g', 'Good (50)',       'LineWidth', 1.5, 'LabelOrientation','horizontal');
xline(100, '--y', 'Moderate (100)',  'LineWidth', 1.5, 'LabelOrientation','horizontal');
xline(150, '--r', 'Unhealthy (150)', 'LineWidth', 1.5, 'LabelOrientation','horizontal');

xlabel('PM2.5 AQI Value');
ylabel('Number of City Readings');
title('PM2.5 AQI Distribution Across All Cities');
grid on;
set(gca, 'FontSize', 11);

% ------------------------------------------------------------------
% FIGURE 2 — Correlation Heatmap
% ------------------------------------------------------------------
figure('Name','Feature Correlation Heatmap','NumberTitle','off', ...
       'Position',[150 150 700 580]);

corrMatrix = corr(table2array(dataTrain));
heatmap(dataTrain.Properties.VariableNames, ...
        dataTrain.Properties.VariableNames, ...
        corrMatrix);
title('Feature Correlation Heatmap');
set(gca, 'FontSize', 11);

% ------------------------------------------------------------------
% FIGURE 3 — Top 15 Most Polluted Countries (simple horizontal bar)
%
% Why this is useful for interview:
%   Easy to explain — "these are the countries with the worst average
%   PM2.5 AQI in our dataset, color-coded by WHO severity band."
% ------------------------------------------------------------------
figure('Name','Top 15 Most Polluted Countries','NumberTitle','off', ...
       'Position',[200 100 850 500]);

countries     = data_raw.Country;
pm25          = data_raw.PM2_5AQIValue;
unique_ctry   = unique(countries);
n             = numel(unique_ctry);

country_means = zeros(n, 1);
for i = 1:n
    country_means(i) = mean(pm25(strcmp(countries, unique_ctry{i})));
end

[sorted_means, idx] = sort(country_means, 'descend');
top_n         = min(15, n);
top_means     = sorted_means(1:top_n);
top_countries = unique_ctry(idx(1:top_n));

% Color bars by AQI band
bar_colors = zeros(top_n, 3);
for i = 1:top_n
    v = top_means(i);
    if     v <= 50,  bar_colors(i,:) = [0.18 0.80 0.44];
    elseif v <= 100, bar_colors(i,:) = [1.00 0.75 0.00];
    elseif v <= 150, bar_colors(i,:) = [1.00 0.45 0.10];
    else,            bar_colors(i,:) = [0.85 0.10 0.10];
    end
end

b = barh(top_means, 'FaceColor','flat');
b.CData = bar_colors;

yticks(1:top_n);
yticklabels(top_countries);
xlabel('Average PM2.5 AQI Value');
title('Top 15 Most Polluted Countries — Avg PM2.5 AQI', 'FontWeight','bold');

xline(50,  '--', 'Color',[0.10 0.55 0.10], 'LineWidth',1.1, 'Label','Good');
xline(100, '--', 'Color',[0.80 0.65 0.00], 'LineWidth',1.1, 'Label','Moderate');
xline(150, '--', 'Color',[0.80 0.10 0.10], 'LineWidth',1.1, 'Label','Unhealthy');

% Value labels on bars
for i = 1:top_n
    text(top_means(i) + 1, i, sprintf('%.0f', top_means(i)), ...
        'VerticalAlignment','middle', 'FontSize', 9);
end

grid on; box off;
set(gca, 'FontSize', 10, 'GridAlpha', 0.25);

% ------------------------------------------------------------------
% FIGURE 4 — Global AQI Category Breakdown (pie chart)
%
% Why this is useful for interview:
%   One number to anchor the whole project — "X% of all readings in
%   our dataset are already in the Unhealthy range."
% ------------------------------------------------------------------
figure('Name','Global AQI Category Breakdown','NumberTitle','off', ...
       'Position',[250 150 700 520]);

pm25_all = data_raw.PM2_5AQIValue;
total    = numel(pm25_all);

counts = [
    sum(pm25_all <= 50);
    sum(pm25_all > 50  & pm25_all <= 100);
    sum(pm25_all > 100 & pm25_all <= 150);
    sum(pm25_all > 150 & pm25_all <= 200);
    sum(pm25_all > 200);
];

labels = {
    sprintf('Good (0-50)\n%.1f%%',         counts(1)/total*100);
    sprintf('Moderate (51-100)\n%.1f%%',    counts(2)/total*100);
    sprintf('Unhealthy-Sensitive\n(101-150)  %.1f%%', counts(3)/total*100);
    sprintf('Unhealthy (151-200)\n%.1f%%',  counts(4)/total*100);
    sprintf('Very Unhealthy (>200)\n%.1f%%',counts(5)/total*100);
};

colors = [
    0.18 0.80 0.44;
    1.00 0.75 0.00;
    1.00 0.45 0.10;
    0.85 0.10 0.10;
    0.55 0.00 0.55;
];

% Explode the largest and smallest slices for readability
explode = [0 0 0 0 0];
[~, biggest] = max(counts);
explode(biggest) = 0.05;

p = pie(counts, explode, labels);

% Apply colors
for i = 1:numel(counts)
    p(2*i-1).FaceColor = colors(i,:);
    p(2*i-1).EdgeColor = 'w';
    p(2*i).FontSize    = 9;
end

title(sprintf('Global PM2.5 AQI Category Distribution  (n = %d readings)', total), ...
    'FontWeight','bold', 'FontSize', 11);

end
