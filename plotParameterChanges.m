function plotParameterChanges(paramSets, parameterLabels)
    figure('Position', [100, 100, 1200, 700]); % [left bottom width height]

    % Define labels for the legend
    legendLabels = cell(1, length(paramSets));

    % Define variable for maxY
    maxY = 0;

    % Iterate over different parameter sets
    for i = 1:length(paramSets)
        % Retrieve the current parameter set
        parameters = paramSets{i};

        % Solve ODE with the current parameters
        [T,Y,controlTime] = restartODE(parameters);

        % Plot the solution on a semilogarithmic scale
        semilogy(T,Y(:,3));

        %Determine max y
        maxY = max(maxY,max(Y(:,3)));
        hold on;

        % Add a vertical line at the time of control introduction
        line = xline(controlTime, '--', ...
            'LineWidth', 1.6, 'Color', 'r');
        line.LabelHorizontalAlignment = 'center';
        line.LabelVerticalAlignment = 'top';

        % Construct the legend label for the current parameter set
        paramStr = [];
        for j = 1:length(parameterLabels)
            paramStr = [paramStr, parameterLabels{j}, ' = ', num2str(parameters.Control.(parameterLabels{j})), ', ']; %#ok<AGROW> 
        end
        legendLabels{2*i-1} = ['Set ', num2str(i), ': ', paramStr(1:end-2)]; % Remove trailing comma and space
   

        % Add control time to the legend
        controlTimeString = ['Control introduced at t = ', num2str(controlTime)];
        legendLabels{2*i} = controlTimeString; %#ok<AGROW> 
    end

    legend(legendLabels, 'Location', 'eastoutside');
    xlabel('time');
    ylabel('Free Virus');
    ylim([1,1.1*maxY]); %set Y axis max at 10% more then yMax
    title('Parameter Variation');
end
