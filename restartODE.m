function [T,Y,stoppedTime] = restartODE(parameters)
    % This function simulates the HIV In Vitro model with a two-stage ODE solver. 
    % It uses original parameters up to a certain point (or an event), and then restarts the ODE 
    % solver with modified control parameters.
    
    % Unpack initial parameters from the input structure
    p.beta = parameters.Original.beta; % Infection rate of target cells by the virus
    p.q = parameters.Original.q; % Proportion of infected cells producing virus

    % Define the ODE function with these initial parameters
    odeEqn = @(t,y) HIVInVitrio(t,y,p);

    % Define the time span and initial conditions for the first simulation
    tspanEnd = parameters.FinalTime;   % The final time for the simulation
    tspanStop = parameters.ControlTime; % Time to introduce controls if event condition not met

    tspan1 = [0 tspanStop]; % Initial range for time 
    y0 = [100 0 1];  % Initial conditions [T, I, V]

    % Set the options for the ODE solver to include the event function
    options = odeset('Events', @stopEvent); 

    % Solve the ODE for the first time span
    [T1,Y1] = ode15s(odeEqn,tspan1,y0,options);

    % At this point, the ODE solver stops due to the event function
    stoppedTime = T1(end); % Time at which the ODE solver was stopped
    
    % Modify the parameters to simulate the effect of a control strategy
    p.beta = parameters.Control.beta; % Reduced infection rate due to therapy
    p.q = parameters.Control.q;     % Reduced proportion of virus-producing cells due to therapy

    % Update the ODE function with the modified parameters
    odeEqn = @(t,y) HIVInVitrio(t,y,p);

    % The initial conditions for the next run are the final state of the first run
    y0 = Y1(end,:); 

    % The next time span starts where the first left off
    tspan2 = [T1(end) tspanEnd];
    
    % Solve the ODE for the second time span
    [T2,Y2] = ode15s(odeEqn,tspan2,y0); 

    % Concatenate the results from the two runs to provide a complete timeline
    T = [T1;T2]; % Time array
    Y = [Y1;Y2]; % Solution array
end