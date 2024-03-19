%% Model Solution distributions

%The code in 'solutionDistributions.m' summarizes the ODE model's solutions
% at a specific time point of interest, in this case, the final time.
% We're analyzing the ODE model%s results at a specific time point, timePoint,
% generated from solving the ODE using parameter sets from a Latin Hypercube
% Sampling (LHS) utilized in the PRCC analysis. This approach visualizes the
% model's behavior and assesses the values of different compartments
% (like susceptible, infected, recovered) based on the sampled parameter sets.
% The focus is on the distribution and variability of these values at timePoint
% to understand how the model's outcomes change across our LHS.

%The code is structured into three primary sections:

%1.	Generate Statistical Summaries: For each compartment, it calculates
% several statistics (mean, median, mode, min, max, range, standard deviation,
% variance) at the time point timePoint. These statistics provide insights into
% the final distribution of each compartment, helping to summarize the outcomes
% of the epidemic model's simulation.

%2.	Visualize Distributions: Histograms are created for each compartment to
% visually represent how the final values are distributed, considering the
% Latin hypercube sample of parameters used for the PRCC analysis. This helps
% in understanding the variability within each compartment at the end of the
% simulation and can reveal patterns such as skewness or multimodality that
% might be important for interpreting the model's results. In this plot,
% the X-axis (Horizontal Axis) represents the range of values that the
% compartment has at timePoint, split into histogram bins. The Y-axis
% (Vertical Axis) represents the count of model solutions that fall within
% each bin of the histogram. Essentially, the y-axis quantifies how many
% times data points occur within the specified ranges, giving insight into
% the most common values or the spread of values across the population or
% simulations.

%3.	Kernel Density Estimation: A KDE is performed for the last compartment
% analyzed, offering a smooth estimate of its probability density function
% at %timePoint’. This plot provides a continuous view of the distribution,
% which can be particularly useful for identifying the shape of the data
% distribution, such as peaks, valleys, and tails, that might not be as
% apparent in a histogram.


%% Load solution data
load('Model_LHS.mat');

%% Set plot parameters

% timePoint is the index of the saved time point.
% 1,2, or 3 in this example.
timePoint = 3;
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


% Histogram
% Histograms are created for each compartment to visually represent how
% the final values are distributed. This helps in understanding the
% variability within each compartment at the end of the simulation
% and can reveal patterns such as skewness or multimodality.


% Loop over the list of variables
for i = 1:length(list)
    % Get the variable data using eval (assuming the variables are in the workspace)
    data = eval(list{i});

    figure()
    hist(data(timePoint,:),100)%the second argument specifies the number of bins to use in the histogram
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
sgtitle(["Histograms of Compartments at Solution Point ", num2str(timePoint)]);

%% Kernel density plot
% For each compartment in your list, calculate and plot the kernel density estimate

for i = 1:length(list)
    % Get the variable data for the specified time point using eval
    data = eval([list{i} '(timePoint,:)']);

    % Calculate the kernel density estimate
    [f,xi] = ksdensity(data);

    % Plot the kernel density estimate
    figure();
    plot(xi, f, 'LineWidth', 2);  % Adjust the line width as needed

    % Enhance the plot with titles and labels
    title(['Kernel Density Estimate for ' list{i} ' at time point ' num2str(timePoint)]);
    xlabel([list{i} ' Value']);
    ylabel('Probability Density');
end
