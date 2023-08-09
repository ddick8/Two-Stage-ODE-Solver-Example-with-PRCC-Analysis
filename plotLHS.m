function plotLHS(PRCCVar, LHS_vars)
    % Check if PRCCVar and LHS_vars have the same length
    if length(PRCCVar) ~= length(LHS_vars)
        error('PRCCVar and LHS_vars must have the same length');
    end

    % Determine the number of rows and columns for the subplots
    nVars = length(LHS_vars);
    nCols = ceil(sqrt(nVars));
    nRows = ceil(nVars / nCols);

    % Create a figure
    figure;

    % Loop through the variables and plot the histograms in subplots
    for i = 1:nVars
        subplot(nRows, nCols, i);
        histogram(LHS_vars{i});
        title(['Histogram for ', PRCCVar{i}]);
        xlabel([PRCCVar{i}, ' values']);
        ylabel('Frequency');
    end
end