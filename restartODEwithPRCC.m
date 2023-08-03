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

% Setting up the time frame for the simulation
parameters.FinalTime = 10; % End time for the simulation
tspan=linspace(0,parameters.FinalTime,100); % Array of time points for the simulation
midPoint = round(length(tspan)/2); % Calculating the midpoint of the time array
time_points=[midPoint parameters.FinalTime]; % Time points of interest for analysis

% Defining the sample size
runs=100; % Number of iterations for the simulation

% Creating control parameters for the model
parameters.Original = struct('beta', [], 'q', []); % Empty structure for original parameters
parameters.Control = struct('beta', [], 'q', []); % Empty structure for control parameters
parameters.ControlTime = []; % Placeholder for control time

% Setting control variable parameters
parameters.Original.beta = 8e-4;
parameters.Original.q = 1;

parameters.Control.beta = 8e-15;
parameters.Control.q = 1e-8;

parameters.ControlTime = 3;
parameters.FinalTime = 10;

% Generating Latin Hypercube Sampling (LHS) matrices for beta, q, and control time parameters
beta_LHS = LHS_Call(1e-2, parameters.Control.beta, parameters.Control.beta*100, parameters.Control.beta*1/100 ,runs,'unif');
q_LHS = LHS_Call(1e-4, parameters.Control.q, parameters.Control.q*100, parameters.Control.q*1/100 ,runs,'unif');
controlTime_LHS = LHS_Call(1e-4, parameters.ControlTime, parameters.FinalTime, 0 ,runs,'unif');

% Variable names for PRCC (Partial Rank Correlation Coefficient) analysis
PRCC_var = {'\beta','q','control t'};

% Labels for compartments in the model
var_label = {'T','I','V'};

% Constructing the LHS matrix with generated samples for beta, q, and control time
LHSmatrix  = [beta_LHS q_LHS controlTime_LHS];
 
% Iterating over the number of runs and solving the model for each set of parameters
for x=1:runs 
    parameters.Control.beta = LHSmatrix(x,1);
    parameters.Control.q = LHSmatrix(x,2);
    parameters.ControlTime = LHSmatrix(x,3);

    [t,y,controlTime] = restartODE(parameters); % Solving the model with new parameters

    A=[t y]; % Combining the time and state vectors

    % Extracting the outputs at the time points of interest [time_points]
    T_lhs(:,x)=A(time_points,1);
    I_lhs(:,x)=A(time_points,2);
    V_lhs(:,x)=A(time_points,3);
end
            
% Save the workspace
save Model_LHS.mat;

% Calculate PRCC (Partial Rank Correlation Coefficient)
[prcc sign sign_label]=PRCC_II(LHSmatrix,V_lhs,1:length(time_points),PRCC_var,0.05);

