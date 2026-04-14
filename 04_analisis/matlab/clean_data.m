function cleaned_data = clean_data(data)
    % Elimina valores no finitos de la serie temporal
    cleaned_data = data;
    cleaned_data(~isfinite(cleaned_data)) = NaN;
end
