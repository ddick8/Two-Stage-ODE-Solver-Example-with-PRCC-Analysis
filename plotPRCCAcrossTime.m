function plotPRCCAcrossTime(prcc, sign, PRCCVar, timePoints, alpha)
    % Create a new figure and specify its size
    figure('Position', [100, 100, 800, 800]); % [left bottom width height]

    % Loop through time points
    for r = 1:length(timePoints)
        % Find significant PRCCs at the current time point
        a = find(sign(r, :) < alpha);
        % Store significant PRCCs
        sign_label.index{r} = a;
        sign_label.label{r} = PRCCVar(a);
        sign_label.value{r} = num2str(prcc(r, a));
        
        % Create a subplot for each time point
        subplot(length(timePoints), 1, r);
        
        % Call the plotting function (which may need to be adapted for subplotting)
        plotPRCC(prcc(r, :), PRCCVar, timePoints(r), 'PRCC Values for free virus', true);
    end

    % Add an overall title or other formatting if needed
    sgtitle('PRCC Values Across Different Time Points');

    % Add a common y-label
    ylabelPosition = get(gca, 'Position');
    yLabelX = ylabelPosition(1) - ylabelPosition(1)*3/4;
    yLabelY = .35;
    annotation('textbox', [yLabelX, yLabelY, .5, 0], ...
        'String', 'PRCC Values for free virus', ...
        'EdgeColor', 'none', ...
        'Rotation', 90, ...
        'FontSize', 14, ...      
        'FontName', 'Arial', ... 
        'FontWeight', 'bold');   

    % Add a common x-label
    xlabelPosition = get(gca, 'Position');
    xLabelX = xlabelPosition(1) + xlabelPosition(3)/2;
    xLabelY = xlabelPosition(2) - xlabelPosition(2)*1/2;
    annotation('textbox', [xLabelX, xLabelY, 0, 0], ...
        'String', 'Parameters', ...
        'EdgeColor', 'none', ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 14, ...      
        'FontName', 'Arial', ... 
        'FontWeight', 'bold');   
end
