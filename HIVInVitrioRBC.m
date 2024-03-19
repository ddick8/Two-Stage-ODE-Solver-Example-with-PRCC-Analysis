function [zdot] = HIVInVitrioRBC(t,z,p,nm,n)
% Models the dynamics of HIV infection in an in vitro setting with RBCs
% viral traps.
% uninfected T cells (T), infected cells (I), free virus particles (V),
% infected cells in control (Ic), and viral traps (X).

% Inputs:
%   t - Time variable for the ODE solver.
%   z - Vector of current state variables [T, I, V, Ic, X].
%   p - Struct containing model parameters (not used in this implementation).
%   nm - Modulation factor for the infection rate, with a fallback value if not specified.
%   n - Additional parameter influencing virus dynamics, displayed for debugging.


T = z(1);
I = z(2);
V = z(3);
Ic = z(4);
X = z(5);

%params taken from https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6117215/
k = 1000/0.05;  % Rate constant for virus production
u = 3;          % Rate of virus clearance
d = 0.1;        % Death rate of T cells
lambdaT = 0;    % Source rate of T cells (assumed to be 0 for simplification)
a = 1;          % Rate of infected cell clearance
beta = 10e-4;   % Infection rate of T cells by the virus
q = 0.05;       % Proportion of infected cells producing virus

%Error check
if isnan(nm)
    nm = 1;
end

B = nm*beta; % Difference in affinity of RBC 'nm'
disp(n)

zdot(1) = lambdaT-d*T-beta*T*V;
zdot(2) = beta*T*V-a*I;
zdot(3) = k*q*I-u*V-beta*T*V-n*B*X*V;
zdot(4) = beta*T*V;
zdot(5) = -B*X*V;

zdot = zdot';