% This function calculates Partial Rank Correlation Coefficients (PRCC) 
% between a set of inputs and outputs.

% Original code by Simeone Marino, May 29 2007 %%
% Modified by David Dick ddick8@uwo.ca

% This function calculates Partial Rank Correlation Coefficients (PRCC) 
% between a set of inputs and outputs.

% Inputs:
% LHSmatrix: Latin Hypercube Sampling (LHS) matrix
% Y: Output values 
% timePoints: Subset of time points 
% PRCC_var: Names of the input parameters
% alpha: Significance level for PRCC calculation

% rho is the array of calculated correlation coefficients, and
% p is the array of p-values indicating the statistical significance of these correlations.

function [prcc, sign, signLabel]=PRCC_II(LHSmatrix,Y,timePoints,PRCCVar,alpha)

% Define LHS matrix and output. Comment out if the Y is already a subset of all the time points
Y=Y(timePoints,:)';

% numRowsLHS is the number of rows in the LHS matrix
% numParams is the number of parameters in the model
[numRowsLHS, numParams]=size(LHSmatrix); 

% numRowsY is the number of rows in the Y vector
% numOutputs is the number of output points
[numRowsY, numOutputs]=size(Y);

% Loop through all parameters
for i=1:numParams  
    % Create a temporary LHS matrix without the current parameter
    eval(['LHStemp=LHSmatrix;LHStemp(:,',num2str(i),')=[];Z',num2str(i),'=LHStemp;LHStemp=[];']);
    % Calculate PRCCs and significances
    [rho,p]=partialcorr([LHSmatrix(:,i),Y],eval(['Z',num2str(i)]),'type','Spearman');

    % Loop through all output points to calculate PRCC and significance
    for j=1:numOutputs
        eval(['prcc_',num2str(i),'(',num2str(j),')=rho(1,',num2str(j+1),');']);
        eval(['prcc_sign_',num2str(i),'(',num2str(j),')=p(1,',num2str(j+1),');']);
    end
    % Clear the temporary matrix for the next iteration
    eval(['clear Z',num2str(i),';']);
end

% Initialize empty vectors for PRCC and significances
prcc=[];
prcc_sign=[];

% Loop through all parameters to populate PRCC and significances
for i=1:numParams
    eval(['prcc=[prcc ; prcc_',num2str(i),'];']);
    eval(['prcc_sign=[prcc_sign ; prcc_sign_',num2str(i),'];']);
end

% Transpose PRCCs and significances
PRCCs=prcc';
uncorrected_sign=prcc_sign';
prcc=PRCCs;
sign=uncorrected_sign;

% Create structure to store significant PRCCs
sign_label_struct=struct;
sign_label_struct.uncorrected_sign=uncorrected_sign;

% Return the structure containing significant PRCCs
signLabel=sign_label_struct;

end
