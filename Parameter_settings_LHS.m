% PARAMETER BASELINE VALUES
beta1 = 0.0637;
beta4 = 0.052;
beta3 = 0.12;
beta2 = 0.0296;
beta5 = 0.15;
beta31 = 0.015; 
beta51 = 0.012;
omega = 0.00578;
muR = 0.003;
sigma = 0.528; 
gamma = 0.024;
alphahv = 0.432;
alpharv = 0.43;
LambdaR = 0.172;
muV = 0.1; 
muW = 0.2;
etahv = 0.21;
etarv = 0.5;
dummy=1;

% Parameter Labels 
PRCC_var = {'$\beta_1$','$\beta_2$','$\beta_3$','$\beta_4$','$\beta_5$','$\beta_{31}$',...
         '$\beta_{51}$','$\omega$','$\mu_R$','$\sigma$','$\gamma$','$\alpha_{hv}$','$\alpha_{rv}$','$\Lambda_R$','$\mu_V$',...
         '$\mu_W$','$\eta_{hv}$','$\eta_{rv}$'};

%% TIME SPAN OF THE SIMULATION
t_end=500; % length of the simulations
tspan=(0:1:t_end);   % time points where the output is calculated
time_points=[200 400]; % time points of interest for the US analysis

% INITIAL CONDITION FOR THE ODE MODEL
Sh0 = 20000;
Eh0 = 0; 
Ih0 = 0; 
Rh0 = 0;
Sr0 = 3000; 
Ir0 = 1; 
V0 = 0; 
W0 = 0;


%%initial values 
y0 = [Sh0;Eh0;Ih0;Rh0;Sr0;Ir0;V0;W0];   


% Variables Labels
y_var_label={'$S_h$','$E_h$','$I_h$','$R_h$','$S_r$','$I_r$','$V$','$W$'};