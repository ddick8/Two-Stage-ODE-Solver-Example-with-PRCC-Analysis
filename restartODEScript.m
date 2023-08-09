%% Restart ODE script
% This script runs an ODE solver that represents the HIV In Vitro model,
% restarts it with changed parameters due to control strategies,
% and plots the results.

%% create control parameters
parameters.Original = struct('beta', [], 'q', []);
parameters.Control = struct('beta', [], 'q', []);
parameters.ControlTime = [];

%set control variable parameters
parameters.Original.beta = 8e-4;
parameters.Original.q = 1;

parameters.Control.beta = 8e-15;
parameters.Control.q = 1e-8;

parameters.ControlTime = 3;
parameters.FinalTime = 10;

% Check if the stop time is before the end time, throw error otherwise.
validate_tstopearly(parameters.ControlTime, parameters.FinalTime);

%% Solve ODE
% Call the 'restartODE' function to run the HIV In Vitro model.
% This function first runs the model with initial parameters until
% a certain event condition is met (defined in the 'events' function),
% or if 'parameters.ControlTime' is reached,
% and then restarts the model with altered parameters from the state
% where the first run stopped.
[T,Y,controlTime] = restartODE(parameters);

%% Plots
% Plot the solution of the ODE on a semilogarithmic scale.
% This plot visualizes the populations of target cells, infectious cells,
% and free virus over time.
figure;
p1 = semilogy(T,Y(:,1:3));

%Incress line width
%p1.LineWidth = 1.2;

% Plot a vertical line at the time of control introduction
line = xline(controlTime,'--', ...
    'LineWidth', 1.6, 'Color', 'r', 'Label', 'Control Introduced');
% Move the label to the bottom of the plot
line.LabelHorizontalAlignment = 'center';
line.LabelVerticalAlignment = 'top';

% Convert the control time to a string to add to the legend
controlTimeString = ['Control introduced at t = ', num2str(controlTime)];

legend('Target cells', 'Infectious cells', 'Free virus', controlTimeString)

xlabel('t')
ylabel('y')

% Set the limits for the y-axis to range from 1 to 10000.
ylim([1,10000])