function valid = validate_tstopearly(tstopearly, tspanfinal)
    % This function checks if tstopearly is less than tspanfinal
    if tstopearly >= tspanfinal
        valid = false;
        error('Invalid: tstopearly is not less than tspanfinal');
    end
end