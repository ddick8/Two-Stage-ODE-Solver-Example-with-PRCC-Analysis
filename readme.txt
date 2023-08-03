# HIV In Vitro ODE Model with Event- or Time-Triggered Control Strategies and PRCC Analysis

This repository serves as an example for simulating an ODE model which, upon reaching a certain time point or event, restarts with new parameters and initial conditions (ICs). In this case, I've used a unique HIV In Vitro model. It incorporates the Partial Rank Correlation Coefficients (PRCC) analysis to evaluate the sensitivity of the model's outputs to its control parameters.

The repository contains scripts for the simulation and analysis of the model using various control strategies.

## Description

This HIV In Vitro model represents the dynamics of the target cells (T), infected cells (I), and free virus (V).

Two main scripts are provided:
1. A basic script to run the ODE model, introduce control strategies at a specific time point, and visualize the results.
2. A script to perform a sensitivity analysis of the model's outputs to its parameters using Latin Hypercube Sampling (LHS) and Partial Rank Correlation Coefficients (PRCC).

## Scripts

### Basic Run Script

This script (`run_script.m`) executes the HIV In Vitro model using an ODE solver. The script introduces control strategies at a predetermined point in time (or under certain conditions) and plots the populations of target cells, infectious cells, and free virus over time.

The script utilizes the following functions:
- `restartODE.m`: Resets the ODE solver with modified parameters.
- `validate_tstopearly.m`: Validates that the time of control strategy introduction is earlier than the end time of the simulation.

### Run with PRCC Script

This script (`run_prcc.m`) runs the HIV In Vitro model, introduces control strategies at a specific point, and carries out a sensitivity analysis on the parameters.

The parameters are varied using Latin Hypercube Sampling (LHS), and the outputs at the time points of interest are saved. The script calculates Partial Rank Correlation Coefficients (PRCC) to analyze the sensitivity of the output to the parameters.

### Other Functions

- `LHS_Call.m`: Generates the Latin Hypercube Sampling matrix. 
- `restartODE.m`: Resets the differential equation solver with new parameters.
- `stopEvent.m`: Defines the condition to halt the ODE solver.
- `HIVInVitrio.m`: Defines the ODEs for the HIV In Vitro model.

## Usage

1. Clone the repository to your local machine.

## Contact

David Dick at ddick8@uwo.ca.

## Related Git Repositories

1. [Two-Stage-ODE-Solver-Example-with-PRCC-Analysis](https://github.com/ddick8/Two-Stage-ODE-Solver-Example-with-PRCC-Analysis)
2. [lhs-prcc](https://github.com/ddick8/lhs-prcc)

## Acknowledgements

Gratitude is extended to the Denise Kirschner Lab for the LHS and PRCC code. Find more information at http://malthus.micro.med.umich.edu/lab/usadata/