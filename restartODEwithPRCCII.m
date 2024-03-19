% This script runs an ODE solver that represents the HIV In Vitro model,
% restarts it with changed parameters due to control strategies.
%
% The parameters are varied using Latin Hypercube Sampling (LHS).
% The outputs at the time points of interest are then saved and
% Partial Rank Correlation Coefficient (PRCC) is computed to analyze
% the sensitivity of the output to the parameters.
%
% Note: This script uses two external functions: LHS_Call() and restartODE(). 
% LHS_Call() generates the Latin Hypercube Sampling matrix and restartODE() 
% restarts the differential equation solver with new parameters.
% David Dick ddick8@uwo.ca (August 3, 2023)

% Creating control parameters for the model
parameters.Original = struct('beta', [], 'q', [], 'n',[],'nm', [],...
    'a',[],'d',[],'u',[],...
    'TIC', [],'VIC', [],'XIC', []); % Empty structure for original parameters
parameters.Control = struct('beta', [], 'q', [], 'n',[],'nm', [],...
    'a',[],'d',[],'u',[],...
    'TIC', [],'VIC', [],'XIC', []);  % Empty structure for control parameters
parameters.ControlTime = []; % Placeholder for control time
parameters.tspan = []; %Placeholder for tspan

% Setting up the time frame for the simulation
parameters.FinalTime = 48; % End time for the simulation
%timeIntervals = 100; % Defining the total number of time intervals for the simulation
%parameters.tspan=linspace(0,parameters.FinalTime,timeIntervals); % Array of time points for the simulation
earlyPoint = round(parameters.FinalTime/6); % Calculating an 'early' time point (1/6 of total)
midPoint = round(parameters.FinalTime/2); % Calculating the midpoint of the time array

% Time points of interest for analysis, including the early point, midpoint, and end point
timePoints=[earlyPoint midPoint parameters.FinalTime];

% Defining the sample size
runs=1000; % Number of iterations for the simulation

% Setting ICs
parameters.InitialConditions.T = NaN;
parameters.InitialConditions.I = 0;
parameters.InitialConditions.V = NaN;
parameters.InitialConditions.Ic = 0;
parameters.InitialConditions.X = NaN;

% Setting control variable parameters
parameters.Original.beta = 10e-4;
parameters.Original.q = 0.05;
parameters.Original.nm = 1;
parameters.Original.n = .00061;
parameters.Original.a = 1;
parameters.Original.d = 0.1;
parameters.Original.u = 3;

parameters.Original.TIC = 100;
parameters.Original.VIC = 1e-2;
parameters.Original.XIC = 100;

parameters.Control.beta = 10e-4;
parameters.Control.q = 0.05;
parameters.Control.nm = 1;
parameters.Control.n = .00061;
parameters.Control.a = 1;
parameters.Control.d = 0.1;
parameters.Control.u = 3;

parameters.ControlTime = 24;
parameters.FinalTime = 48;

% Variable names for PRCC (Partial Rank Correlation Coefficient) analysis
PRCCVar = {'\beta','q','n','nm', 'a','d','u','TIC', 'VIC', 'XIC'};

sdFactor = 3;
sdFix = 1000;
distribution = 'norm';
% Generating Latin Hypercube Sampling (LHS) matrices for beta, q, and control time parameters
beta_LHS = LHS_Call(0, parameters.Original.beta, [], parameters.Original.beta/sdFactor, runs, distribution);
q_LHS = LHS_Call(0, parameters.Original.q, [], parameters.Original.q/sdFactor, runs, 'norm');
n_LHS = LHS_Call(0, parameters.Original.n, [], parameters.Original.n/sdFactor, runs, 'norm');
nm_LHS = LHS_Call(0, parameters.Original.nm, [], parameters.Original.nm/sdFactor, runs, 'norm');
a_LHS = LHS_Call(0, parameters.Original.a, [], parameters.Original.a/sdFactor, runs, 'norm');
d_LHS = LHS_Call(0, parameters.Original.d, [], parameters.Original.d/sdFactor, runs, 'norm');
u_LHS = LHS_Call(0, parameters.Original.u, [], parameters.Original.u/sdFactor, runs, 'norm');
TIC_LHS = LHS_Call(0, parameters.Original.VIC, [], parameters.Original.VIC/sdFactor, runs, 'norm');
VIC_LHS = LHS_Call(0, parameters.Original.TIC, [], parameters.Original.TIC/sdFactor, runs, 'norm');
XIC_LHS = LHS_Call(0, parameters.Original.XIC, [], parameters.Original.XIC/sdFactor, runs, 'norm');

% Cell array containing the variables
LHS_vars = {beta_LHS, q_LHS, n_LHS, nm_LHS, a_LHS, d_LHS, u_LHS,...
    TIC_LHS, VIC_LHS, XIC_LHS};

%Plot histogram of the LHS distrabutions
plotLHS(PRCCVar, LHS_vars);

% Labels for compartments in the model
var_label = {'T','I','V','Ic','X'};

% Constructing the LHS matrix with generated samples for beta, q, and control time
LHSmatrix  = [beta_LHS q_LHS n_LHS nm_LHS a_LHS d_LHS u_LHS...
    TIC_LHS VIC_LHS XIC_LHS];

% Preallocate matrices for T_lhs, I_lhs, and V_lhs
T_lhs = zeros(length(timePoints), runs);
I_lhs = zeros(length(timePoints), runs);
V_lhs = zeros(length(timePoints), runs);
Ic_lhs = zeros(length(timePoints), runs);
X_lhs = zeros(length(timePoints), runs);

% Preallocate time points index
timePointsIndex = zeros(length(timePoints),1);
 
% Iterating over the number of runs and solving the model for each set of parameters
for x=1:runs 
    parameters.Original.beta = LHSmatrix(x,1);
    parameters.Original.q = LHSmatrix(x,2);
    parameters.Original.n = LHSmatrix(x,3);
    parameters.Original.nm = LHSmatrix(x,4);
    parameters.Original.a = LHSmatrix(x,5);
    parameters.Original.d = LHSmatrix(x,6);
    parameters.Original.u = LHSmatrix(x,7);
    parameters.InitialConditions.T = LHSmatrix(x,8);
    parameters.InitialConditions.V = LHSmatrix(x,9);
    parameters.InitialConditions.X = LHSmatrix(x,10);

    [t,y,controlTime] = restartODERBC(parameters); % Solving the model with new parameters

    A=[t y]; % Combining the time and state vectors

     % Find the index of each time point of intrest  [time_points]
    for i = 1:length(timePoints)
    timePointsIndex(i) = find(t > i,1);
    end

    % Extracting the outputs at the time points of interest
    T_lhs(:,x)=A(timePointsIndex,1);
    I_lhs(:,x)=A(timePointsIndex,2);
    V_lhs(:,x)=A(timePointsIndex,3);
    Ic_lhs(:,x)=A(timePointsIndex,4);
    X_lhs(:,x)=A(timePointsIndex,5);
end
            
% Save the workspace
save Model_LHS.mat;

% Calculate PRCC (Partial Rank Correlation Coefficient)
alpha = 0.05; %Significance level

[prcc, sign, sign_label] = PRCC_II(LHSmatrix, V_lhs, 1:length(timePoints), PRCCVar, alpha);

% Plot the PRCC values across the different time points
plotPRCCAcrossTime(prcc, sign, PRCCVar, timePoints, alpha)

% Plot non-monotonicities diagnostics

%% LHS vs. V at final timepoint
% Create a figure and set its size
figure('Position', [100, 100, 1200, 1200]);

numVars = length(PRCCVar); % Number of variables in PRCCVar
numRowsCols = ceil(sqrt(numVars)); % Calculate the number of rows and columns for the grid

tiledlayout(numRowsCols, numRowsCols); % Create a tiled layout for the plots

for i = 1:numVars
    nexttile; % Move to the next tile in the layout
    scatter(LHSmatrix(:,i), V_lhs(3,:), 'filled', 'SizeData', 10); % Create a scatter plot for the i-th variable

    % Calculate Pearson correlation coefficient and p-value
    [R, P] = corr(LHSmatrix(:,i), V_lhs(3,:)', 'Type', 'Pearson');

    % Set labels and title including R and p-value
    xlabel(PRCCVar{i}); % Label the x-axis with the i-th variable from PRCCVar
    ylabel('V'); % Replace 'Y-axis Label' with the appropriate label
    title(sprintf('%s\n (Pearson corr=%.2f,\n p-value=%.3g)', PRCCVar{i}, R, P)); % Include R and p-value in title
end

%% Rank Transformed
% Create a figure and set its size
figure('Position', [100, 100, 1200, 1200]);

% Use tiledlayout for arranging the plots
numVars = length(PRCCVar); % Number of variables in PRCCVar
numRowsCols = ceil(sqrt(numVars)); % Calculate the number of rows and columns for the grid

tiledlayout(numRowsCols, numRowsCols); % Create a tiled layout for the plots

% Rank-transform the data
V_lhs_ranked = tiedrank(V_lhs(3,:)'); % Rank-transform the specific row from V_lhs and transpose

for i = 1:numVars
    LHSmatrix_ranked = tiedrank(LHSmatrix(:,i)); % Rank-transform each column of LHSmatrix
    
    nexttile; % Move to the next tile in the layout
    scatter(LHSmatrix_ranked, V_lhs_ranked, 'filled', 'SizeData', 10); % Create a scatter plot with rank-transformed data
    
    % Calculate Pearson correlation coefficient and p-value on ranked data
    [R, P] = corr(LHSmatrix_ranked, V_lhs_ranked, 'Type', 'Spearman'); 
    
    % Set labels and title including R and p-value
    xlabel(sprintf('%s (Ranked)', PRCCVar{i})); % Indicate the data is ranked in the x-axis label
    ylabel('V (Ranked)'); % Indicate the y-axis data is ranked
    title(sprintf('%s (R=%.2f, p=%.3g)', PRCCVar{i}, R, P)); % Include R and p-value in title
end

%%Linear Regression

% % % Create a figure and set its size
% % fig = figure('Position', [100, 100, 1000, 1000]);
% % 
% % % Determine the number of variables
% % numVars = size(LHSmatrix, 2); % Number of parameters in your data
% % 
% % % Use tiledlayout for arranging the plots
% % numRowsCols = ceil(sqrt(numVars - 1)); % Calculate layout excluding the parameter itself
% % tiledlayout(numRowsCols, numRowsCols); % Create a tiled layout for the plots
% % 
% % % Loop over each parameter
% % for i = 1:numVars
% %     param1 = LHSmatrix(:, i); % Independent variable
% % 
% %     for j = 1:numVars
% %         if i ~= j
% %             % Perform linear regression of param1 against parameter j
% %             otherParam = LHSmatrix(:, j);
% %             mdl = fitlm(param1, otherParam);
% %             
% %             % Calculate residuals
% %             residuals = mdl.Residuals.Raw;
% %             
% %             % Plot residuals in the next tile
% %             nexttile;
% %             scatter(param1, residuals, 'filled', 'SizeData', 10);
% %             xlabel(sprintf('%s', PRCCVar{i}));
% %             ylabel('Residuals');
% %             title(sprintf('Residuals for %s vs. %s', PRCCVar{i}, PRCCVar{j}));
% %         end
% %     end
% % end
