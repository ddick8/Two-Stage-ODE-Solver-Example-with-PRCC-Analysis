# HIV In Vitro ODE Model with Event- or Time-Triggered Control Strategies and PRCC Analysis

This repository serves as an example for simulating an ODE model which, upon reaching a certain time point or event, restarts with new parameters and initial conditions (ICs). In this case, I've used a unique HIV In Vitro model. It incorporates the Partial Rank Correlation Coefficients (PRCC) analysis to evaluate the sensitivity of the model's outputs to its control parameters.

The repository contains scripts for the simulation and analysis of the model using various control strategies.

## Description

This HIV In Vitro model represents the dynamics of the target cells (T), infected cells (I), and free virus (V).

Two main scripts are provided:
1. A basic script (`restartODEScript.m`) to run the ODE model, introduce control strategies at a specific time point, and visualize the results.
2. A script (`restartODEwithPRCC.m`) to perform a sensitivity analysis of the model's outputs to its parameters using Latin Hypercube Sampling (LHS) and Partial Rank Correlation Coefficients (PRCC).

## Stopping Conditions

The stopping conditions for the simulation are dictated by the 'stopEvent.m' function and the 'parameters.ControlTime' parameter. If the 'stopEvent' condition isn't satisfied, the simulation continues until it reaches 'ControlTime'. 

Once the ODE solver halts, control measures are implemented by modifying the 'parameters.Control.beta' and 'parameters.Control.q' parameters or modifing the initial conditions.

## Scripts

### Basic Run Script:

This script (`restartODEScript.m`) executes the HIV In Vitro model using an ODE solver. The script introduces control strategies at a predetermined point in time (or under certain conditions) and plots the populations of target cells, infectious cells, and free virus over time.

Steps:
1. Creating Control Parameters: Defines original and control parameters for the model including infection rates (beta) and proportions of infected cells producing virus (q).
2. Validation: Validates that the control time is before the final time of the simulation.
3. Solving the ODE: Calls the restartODE function to run the simulation. It initially runs the model with original parameters until a control event occurs or the control time is reached, then restarts it with altered parameters.
4. Plotting the Results: Plots the solutions of the ODE, representing the populations of target cells, infectious cells, and free virus over time. It also includes visual indications of when control measures were introduced.

### Run with PRCC Script

This script (`restartODEwithPRCC.m`) runs the HIV In Vitro model, introduces control strategies at a specific point, and carries out a sensitivity analysis on the parameters.

The parameters are varied using Latin Hypercube Sampling (LHS), and the outputs at the time points of interest are saved. The script calculates Partial Rank Correlation Coefficients (PRCC) to analyze the sensitivity of the output to the parameters.

Steps:
1. Setting Up Parameters: Similar to the original script, control parameters are created, but additional placeholders are added for Latin Hypercube Sampling.
2. Time Points and Sample Size Definition: It defines specific time points of interest for analysis and sets the number of iterations for the simulation.
3. Generating LHS Matrices: Calls the LHS_Call function to create LHS matrices for the parameters, allowing a wide spread of values.
4. Iterative Model Solving: Iterates through the runs, solves the model with new parameters at each iteration using the restartODE function, and extracts the outputs at the time points of interest.
5. Saving and Analysis: Saves the workspace and calculates PRCC to analyze the sensitivity, then plots the significant PRCC values.

### Parameter Change Script

This script (parameterChangeScript.m) visualizes different parameter combinations on the HIV In Vitro model. By varying two parameters, `beta` and `q`, it explores different scenarios and visualizes the free virus population against time using the `plotParameterChanges` function.

Notes:
- Modify the `betaChange` and `qChange` arrays to explore different values.
- The script assumes that the `plotParameterChanges` function and the necessary ODE-solving functions are defined and accessible.
- Be aware of the defined original control parameters and ensure that they are consistent.

Dependencies:
- `plotParameterChanges` function
- `validate_tstopearly` function (if used)
- Necessary ODE-solving functions for your model (e.g., `restartODE`)

Output:
A figure that represents different scenarios based on the combinations of `beta` and `q`. The figure will include a semilogarithmic plot, a legend detailing the variations, and appropriate labels and title.


## Functions

### Plotting LHS Distributions

A new function `plotLHS(PRCCVar, LHS_vars)` is included to visualize the distributions obtained through Latin Hypercube Sampling (LHS) for the parameters beta, q, and control time. It takes in the variables `PRCCVar` and `LHS_vars` and plots a combined histogram figure for the given samples, allowing for a more comprehensive overview of the parameters' distributions.

Usage:
```matlab
PRCCVar = {'\beta','q','control t'};
LHS_vars = {beta_LHS, q_LHS, controlTime_LHS};
plotLHS(PRCCVar, LHS_vars);
```

### Plot PRCC Across Time Points

- `plotPRCCAcrossTime(prcc, sign, PRCCVar, timePoints, alpha)` visualizes PRCC values across specific time points in a single figure.

Inputs:
- `prcc`: Matrix containing PRCC values for each time point.
- `sign`: Matrix containing significance levels for each time point.
- `PRCCVar`: Cell array containing names of the PRCC variables.
- `timePoints`: Array containing the time points of interest.
- `alpha`: Significance level for PRCC analysis.

Outputs:
- This function does not return values but produces a plot visualizing the PRCC values across the defined time points.

Usage:
```matlab
% Calculate PRCC (Partial Rank Correlation Coefficient)
alpha = 0.05; % Significance level
[prcc, sign, sign_label] = PRCC_II(LHSmatrix, V_lhs, 1:length(timePoints), PRCCVar, alpha);

% Plot PPRC figure at time points of interest
plotPRCCAcrossTime(prcc, sign, PRCCVar, timePoints, alpha);
```

### plotParameterChanges Function

The `plotParameterChanges` function visualizes the variations of the specified parameters in the HIV In Vitro model. It takes a cell array of parameter sets and a cell array of parameter labels as inputs and plots the free virus against time for each parameter set on a semilog scale. A vertical dashed line represents the time of control introduction. The function also includes a legend detailing the parameter changes and a title.

Inputs:
1. **paramSets**: A cell array containing multiple parameter sets. Each element of the array is a struct defining a unique combination of parameters (e.g., beta, q, controlTime) for the simulation.
2. **parameterLabels**: A cell array containing the labels of the parameters that are varied. This is used to construct the legend entries.

Outputs:
None. The function directly plots the figure.

Usage:
```matlab
paramSets = {...}; % Define different parameter sets
parameterLabels = {'beta', 'q', 'controlTime'};
plotParameterChanges(paramSets, parameterLabels);
```

## Other Functions

- `LHS_Call.m`: Generates the Latin Hypercube Sampling matrix. 
- `stopEvent.m`: Defines the condition to halt the ODE solver.
- `HIVInVitrio.m`: Defines the ODEs for the HIV In Vitro model.
- `restartODE.m`: Simulates the HIV In Vitro model using a two-stage ODE solver. It first runs the simulation with original parameters until a specific event or time is reached, then restarts the ODE solver with modified parameters to simulate control measures.

## Usage

1. Clone the repository to your local machine.

## Contact

David Dick at ddick8@uwo.ca.

## Related Git Repositories

1. [Two-Stage-ODE-Solver-Example-with-PRCC-Analysis](https://github.com/ddick8/Two-Stage-ODE-Solver-Example-with-PRCC-Analysis)
2. [lhs-prcc](https://github.com/ddick8/lhs-prcc)

## Acknowledgements

Gratitude is extended to the Denise Kirschner Lab for the LHS and PRCC code. Find more information at http://malthus.micro.med.umich.edu/lab/usadata/