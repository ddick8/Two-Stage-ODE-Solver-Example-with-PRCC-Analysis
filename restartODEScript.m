%% Restart ODE script
% This script runs an ODE solver that represents the HIV In Vitro model,
% restarts it with changed parameters due to control strategies,
% and plots the results.

%% Solve ODE
% Call the 'restartODE' function to run the HIV In Vitro model.
% This function first runs the model with initial parameters until
% a certain event condition is met (defined in the 'events' function),
% and then restarts the model with altered parameters from the state
% where the first run stopped.
[T,Y] = restartODE();

%% Plots
semilogy(T,Y(:,1:3))
legend('Target cells','Infectious cells','Free virus')

% Label the x-axis as 't', representing time.
xlabel('t')

% Label the y-axis as 'y', representing the logarithm of the number of cells or virus.
ylabel('y')

% Set the limits for the y-axis to range from 1 to 10000.
ylim([1,10000])