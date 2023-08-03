function zdot = HIVInVitrio(~,z,p)
%p is a parameter data structure

%HIV ODE model
%z is a vector of state variables, z = [T, I, V]
T = z(1); % Target cells
I = z(2); % Infected cells
V = z(3); % Virus

%Parameters for the model taken (inspierd) from
%https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6117215/
%The parameters are constant for the system and does not change over time

k = 1000; % Virus production rate
u = 3; % Virus decay rate
d = 0.1; % Death rate of target cells
lambdaT = 1; % Growth rate of target cells
a = 1; % Death rate of infected cells

%beta and q are parameters passed via the structure 'p'
beta = p.beta; % Rate of infection of target cells by the virus
q = p.q; % Proportion of infected cells producing virus

%Calculate the derivatives of the state variables
zdot(1) = lambdaT - d*T - beta*T*V;
zdot(2) = beta*T*V - a*I;
zdot(3) = k*q*I - u*V - beta*T*V;

%Return the derivatives as a column vector
zdot = zdot'; 
end