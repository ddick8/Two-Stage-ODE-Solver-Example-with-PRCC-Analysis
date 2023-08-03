function [value,isterminal,direction] = stopEvent(t,y)
    value = y(1) - 5; % When y(1) = 15, an event is triggered
    %value = 1; Set value != 0 to prevent stop condition
    isterminal = 1; % terminate integration
    direction = []; % detect all zeros
end