function lat_sexagesimal = decimalToSexagesimal(lat_decimal)
    % Convertir grados decimales a sexagesimales (grados y minutos)

    % Extraer la parte entera (grados)
    grados = fix(lat_decimal);

    % Calcular los minutos
    minutos_decimal = (lat_decimal - grados) * -60;

    % Extraer la parte entera de los minutos (minutos)
    minutos = fix(minutos_decimal);

    % Crear el vector de salida en formato [grados; minutos]
    lat_sexagesimal = [grados; minutos];
end
