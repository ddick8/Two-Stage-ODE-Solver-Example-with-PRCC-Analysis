function [value,isterminal,direction] = events(t,y)
    value = y(1) - 15; % When y(1) = 50, an event is triggered
    isterminal = 1; % terminate integration
    direction = []; % detect all zeros
end