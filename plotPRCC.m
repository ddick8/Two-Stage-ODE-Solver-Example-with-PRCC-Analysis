function plotPRCC(PRCCs, PRCCVar, timePoint, xLabelText,subPlot)
    if ~subPlot
        figure;
        ylabel(xLabelText)
        xlabel('Parameters')
    end
    bar(PRCCs)
    grid
    ax = gca; % get the current axes
    ax.FontSize = 12; % set the font size to 12
    
    set(ax,'XLim',[0.5 length(PRCCVar)+.5])
    set(ax,'XTick',1:length(PRCCVar))
    set(ax,'XTickLabel',PRCCVar),
    colormap autumn
    
    % Add title to the plot indicating the current time point
    title(['PRCCs at time: ', num2str(timePoint)])
end