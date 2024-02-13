%% Model Solution distrabutions

%% Load solution data
load('Model_LHS.mat');

%% Set plot parameters

% timePoint is the index of the saved time point.
% 1,2, or 3 in this example.
timePoint = 2;
data = V_lhs(timePoint,:);

% Your list of variable names as strings in a cell array
list = {'T_lhs', 'I_lhs', 'V_lhs'};

%% Statistical summary

% Initialize an empty table to store results
statsTable = table();

% Loop over the list of variables
for i = 1:length(list)
    % Get the variable data using eval (assuming the variables are in the workspace)
    data = eval(list{i});

    % Calculate statistics
    meanValue = mean(data(timePoint,:));
    medianValue = median(data(timePoint,:));
    modeValue = mode(data(timePoint,:));
    minValue = min(data(timePoint,:));
    maxValue = max(data(timePoint,:));
    rangeValue = range(data(timePoint,:));
    stdDev = std(data(timePoint,:));
    varianceValue = var(data(timePoint,:));

    % Create a temporary table with the statistics
    tempTable = table(meanValue, medianValue, modeValue, minValue, maxValue, rangeValue, stdDev, varianceValue, ...
        'VariableNames', {'Mean', 'Median', 'Mode', 'Min', 'Max', 'Range', 'StandardDeviation', 'Variance'}, ...
        'RowNames', list(i));

    % Concatenate the temporary table with the main statsTable
    statsTable = [statsTable; tempTable];
end

% Display the complete table of statistics
disp(statsTable);


%% Visualizations

% % % Gather the data from each vector into a cell array
% % data = cell(size(list));
% % for i = 1:length(list)
% %     data{i} = eval(list{i}); % Extract each dataset using eval
% % end
% % 
% % % Convert the cell array to a matrix for boxplot
% % dataMatrix = cell2mat(data');
% % 
% % % Create a boxplot
% % figure()
% % boxplot(dataMatrix);


% histogram
% Loop over the list of variables
for i = 1:length(list)
    % Get the variable data using eval (assuming the variables are in the workspace)
    data = eval(list{i});

    figure()
    hist(data(timePoint,:),20)
    title(['Distribution Histogram for solution at saved point',num2str(timePoint)]);
    xlabel(list{i});
    ylabel('Count');
end

%% Create a figure with subplots using nexttile
numVariables = length(list);
numRows = ceil(sqrt(numVariables));  % Determine the number of rows for subplots
numCols = ceil(numVariables / numRows);  % Determine the number of columns for subplots
figure;

% Loop over the list of variables
for i = 1:numVariables

    % Get the plot data using eval 
    data = eval(list{i});
    
    % Create subplot using nexttile
    nexttile;
    
    % Plot histogram
    hist(data(timePoint,:), 20);

    % Set labels
    xlabel(list{i});
    ylabel('Count');
end

% Overall title
sgtitle(["Histograms of Variables at Solution Point ", num2str(timePoint)]);

%% Kernel density plot
% % Calculate the kernel density estimate
% [f,xi] = ksdensity(data(timePoint,:));
% 
% % Plot the kernel density estimate
% figure()
% plot(xi,f,'LineWidth',2);
% 
% % Enhance the plot with titles and labels
% title('Kernel Density Estimate');
% xlabel('Data Value');
% ylabel('Probability Density');