function value = get_value_invalid_cover(field, i, j, cover_value)
    if i == 0
        value = cover_value;
    elseif i == length(field(:,1)) + 1
        value = cover_value;
    else
        if j == 0
            value = cover_value;
        elseif j == length(field(1,:)) + 1
            value = cover_value;
        else
            value = field(i,j);
        end
    end
end