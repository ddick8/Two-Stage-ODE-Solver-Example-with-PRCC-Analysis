% Define original control parameters
parameters.Original = struct('beta', 8e-4, 'q', 1);
parameters.Control = struct('beta', 8e-4, 'q', 1);
parameters.ControlTime = 3;
parameters.FinalTime = 10;

% Validate if the stop time is before the end time, throw error otherwise.
validate_tstopearly(parameters.ControlTime, parameters.FinalTime);

% Changed paramter labels
paramterLabels = {'beta','q'};

% Changed parameter list
betaChange = [8e-4,8e-4*.5,0];
qChange = [1,.5,0];

%determine number of parameter sets
n = length(betaChange);

% Initialize cell array to hold parameter sets
paramSets = cell(length(betaChange) * length(qChange), 1);

% Counter for inserting parameter sets into the cell array
counter = 1;

% Iterate through all combinations of beta and q
for i = 1:length(betaChange)
    for j = 1:length(qChange)
    % Create a new parameter set based on the original, with some variations
    newParamSet = parameters;
    newParamSet.Original.beta = parameters.Original.beta;
    newParamSet.Original.q = parameters.Original.q;
    newParamSet.Control.beta = betaChange(i); 
    newParamSet.Control.q = qChange(j);
    newParamSet.ControlTime = parameters.ControlTime;

        % Insert the structure into the cell array
        paramSets{counter} = newParamSet;
        counter = counter + 1;
    end
end

%Plot
plotParameterChanges(paramSets, paramterLabels);