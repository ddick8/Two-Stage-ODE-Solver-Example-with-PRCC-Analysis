function [value,isterminal,direction] = stopEvent(t,y)
    value = y(1) - 5; % When y(1) = 15, an event is triggered
    isterminal = 1; % terminate integration
    direction = []; % detect all zeros
end