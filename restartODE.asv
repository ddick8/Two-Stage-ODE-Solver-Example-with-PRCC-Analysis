function [T,Y] = restartODE()
    % Define the parameters for the HIV In Vitro model, encapsulated in a struct 'p'
    p.beta = 8e-4; % Infection rate of target cells by the virus
    p.q = 1; % Proportion of infected cells producing virus

    % Define the ODE function with these initial parameters
    odeEqn = @(t,y) HIVInVitrio(t,y,p);

    % Define the time span and initial conditions for the first simulation
    tspanEnd = 10;   % The final time for the simulation
    tspan1 = [0 tspanEnd]; % Initial range for time 
    y0 = [100 0 1];  % Initial conditions [T, I, V]

    % Set the options for the ODE solver to include the event function
    options = odeset('Events', @events); 

    % Solve the ODE for the first time span
    [T1,Y1] = ode15s(odeEqn,tspan1,y0,options); 

    % At this point, the ODE solver stops due to the event function
    
    % Modify the parameters to simulate the effect of a control strategy
    p.beta = 8e-15; % Reduced infection rate due to therapy
    p.q = 1e-8;     % Reduced proportion of virus-producing cells due to therapy

    % Update the ODE function with the modified parameters
    odeEqn = @(t,y) HIVInVitrio(t,y,p);

    % The initial conditions for the next run are the final state of the first run
    % You can modify the initial conditions to represent an intervention
    y0 = Y1(end,:); 

    % The next time span starts where the first left off
    tspan2 = [T1(end) tspanEnd];
    
    % Solve the ODE for the second time span
    [T2,Y2] = ode15s(odeEqn,tspan2,y0); 

    % Concatenate the results from the two runs to provide a complete timeline
    T = [T1;T2];
    Y = [Y1;Y2];
end