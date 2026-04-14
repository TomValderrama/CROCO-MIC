close all;
clear all;
clc;
start 

addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_bench_inv.nc';

% Crear una matriz para almacenar las alturas del nivel del mar
zeta = NaN(38, 56, 651); % Preasignación de memoria

for i = 73:723
    k = i - 72;
    [lat, lon, ~, var1] = get_var(hisfile, [], 'zeta', i, -1, 1, [0 0 0 0]);
    zeta(:,:,k) = var1;
end


[NAME,FREQ,TIDECON,XOUT]=t_tide(zeta(15,35,:),'output','none');

for i = 1:size(zeta, 1)
    for j = 1:size(zeta, 2)
        data = squeeze(zeta(i, j, :));
        
        % Verificar si todos los datos son NaN
        if ~all(isnan(data))
            [~, ~, ~, XOUT] = t_tide(data, 'output', 'none');
            marea_astronomica_dominio(i, j, :) = XOUT;
            marea_residual_dominio(i, j, :) = data - XOUT;
        else
            % Almacena los índices de NaN en nan_indices
            nan_indices{i, j} = find(isnan(data));
        end
    end
end
%%
% Bucle para la figura
close all

h=figure('Units','characters','Position',[1 1 370 100]);

titles= {'Sea Level', 'Astronomical Tides', 'Residual Tides'};
variables = {zeta, marea_astronomica_dominio, marea_residual_dominio};

for i = 1:3
    subplot(3,1,i);
    % Verifica que variables{i} tiene al menos tres dimensiones
    if ndims(variables{i}) >= 3
        % Si es una matriz 3D, selecciona la serie temporal para (15, 35)
        if numel(size(variables{i})) == 3
            plot(squeeze(variables{i}(15, 35, :)));
            ylabel('Sea Lavel [m]', FontSize=16); % Ajusta el label según tus necesidades
            set(gca, 'FontSize', 16, 'FontWeight', 'bold'); % Ajusta el tamaño de la fuente según tus necesidades
            xlim([0 650])
        else
            % Si es un vector 1D, realiza el plot directamente
            plot(squeeze(variables{i}));
        end
        title(titles{i});
        
        % Ajusta el caxis para la marea residual
        if i == 1
            ylim([-5, 5]);  % Ajusta el rango según tus necesidades para el primer subplot
        elseif i == 2
            ylim([-5, 5]);  % Ajusta el rango según tus necesidades para el segundo subplot
        elseif i == 3
            ylim([-5, 5]);  % Ajusta el rango según tus necesidades para el tercer subplot
        end

        % Quita los ticks del eje x para los dos primeros subgráficos
        if i <= 2
            set(gca, 'XTick', []);
        end
    else
        disp(['La variable ' titles{i} ' no tiene al menos tres dimensiones.']);
    end
end
duracion_horas = 651;
% Definir el punto de inicio
% fecha_inicio = datetime('2021-01-25 00:00:00', 'Format', 'yyyy-MM-dd HH:mm:ss');
fecha_inicio = datetime('2021-07-26 00:00:00', 'Format', 'yyyy-MM-dd HH:mm:ss');

% Crear el vector de tiempo
vector_tiempo = fecha_inicio + hours(0:duracion_horas-1);


% Obtener las posiciones de las marcas del eje x
xtick_positions = round(linspace(1, numel(vector_tiempo), 6));

% Establecer las marcas del eje x y las etiquetas
xticks(xtick_positions);
xticklabels(datestr(vector_tiempo(xtick_positions), 'dd/mm'));

% Cambiar el tamaño de fuente de las marcas del eje x
set(gca, 'FontSize', 16, 'FontWeight', 'bold'); % Ajusta el tamaño de la fuente según tus necesidades

xlabel('Date (dd/mm)', 'Interpreter', 'none','FontSize',20);


%%

h=figure('Units','characters','Position',[1 1 370 100]);

% Selecciona un plano de tiempo para visualizar (ajusta según tus necesidades)
tiempo_seleccionado = 541;

% Graficar el campo de marea residual usando pcolor
m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
m_pcolor(lon(:,1:53), lat(:,1:53), squeeze(marea_residual_dominio(:,:,tiempo_seleccionado)));
shading interp
hold on
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);
m_gshhs_f('patch',[.8 .8 .8]);
cmocean('balance',27)

% Ajusta los límites del colormap según tus necesidades
limite_color = 1; % Ajusta según tu rango de valores
caxis([-limite_color, limite_color]);
h_colorbar = colorbar;
set(h_colorbar, 'FontSize', 20); % Ajusta el tamaño de la fuente según tus necesidades


% title(['Campo de Marea Residual en el Tiempo: ' num2str(tiempo_seleccionado)]);

% Coordenadas de la estrella
lat_estrella = 15;
lon_estrella = 35;

% Agregar la estrella al gráfico
% m_plot(lon_estrella, lat_estrella, 'p', 'MarkerSize', 15, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');
m_line(lon(15,35), lat(15,35),'marker','pentagram', 'color','k','linewi',2, 'linest','none','markersize',20,'markerfacecolor','g');
% Puedes ajustar el tamaño, color y estilo del marcador según tus preferencias.

%% sin subplots

% Definir la duración en horas
duracion_horas = 651;

% Definir el punto de inicio
% fecha_inicio = datetime('2021-01-25 00:00:00', 'Format', 'yyyy-MM-dd HH:mm:ss');
fecha_inicio = datetime('2021-07-26 00:00:00', 'Format', 'yyyy-MM-dd HH:mm:ss');

% Crear el vector de tiempo
vector_tiempo = fecha_inicio + hours(0:duracion_horas-1);

colores = {'k', 'g', 'r'};
h=figure('Units','characters','Position',[1 1 370 100]);
h_axes = axes('Position', [0.1, 0.18, 0.85, 0.8]);         % solo yticks 

titles= {'Sea Level', 'Astronomical Tides', 'Residual Tides'}
for i = 1:3
    % Verifica que variables{i} tiene al menos tres dimensiones
    if ndims(variables{i}) >= 3
        hold on;  % Mantén los datos anteriores en el mismo gráfico
        % Si es una matriz 3D, selecciona la serie temporal para (15, 35)
        if numel(size(variables{i})) == 3
            plot(squeeze(variables{i}(15, 35, :)), 'Color', colores{i}, 'LineWidth',2);
        else
            % Si es un vector 1D, realiza el plot directamente
            plot(squeeze(variables{i}), 'Color', colores{i});
        end
        % Ajusta el caxis para la marea residual
        if i == 3  % Marea Residual
            caxis([-1, 1]);  % Puedes ajustar el rango según tus necesidades
        end
    else
        disp(['La variable ' titles{i} ' no tiene al menos tres dimensiones.']);
    end
end

% Agregar leyenda
legend(titles,'Location','best');

% Obtener las posiciones de las marcas del eje x
xtick_positions = round(linspace(1, numel(vector_tiempo), 6));

% Establecer las marcas del eje x y las etiquetas
xticks(xtick_positions);
xticklabels(datestr(vector_tiempo(xtick_positions), 'dd/mm'));

% Cambiar el tamaño de fuente de las marcas del eje x
set(gca, 'FontSize', 20, 'FontWeight', 'bold'); % Ajusta el tamaño de la fuente según tus necesidades


% Finalmente, agregar la etiqueta al eje x
xlabel('Date (dd/mm)', 'Interpreter', 'none','FontSize',20);

ylabel('Sea level [m]')

axis tight
hold off;  % Liberar el estado de "hold on" después de terminar



%%


% 
% clc
%  % Supongamos que lon y lat son matrices 2D correspondientes a las dimensiones de marea_residual_dominio
% [m, n] = size(lon);
% 
% % Selecciona un tiempo específico (ajusta según tus necesidades)
% tiempo_seleccionado = 541;
% 
% % Extrae la marea residual en el tiempo seleccionado
% % Evita que el índice i+1 supere el límite n
%     if i+1 <= n
%         marea_residual_segmento = marea_residual_tiempo(:, i:min(i+1, n));
%     end
% % Inicializa las matrices de velocidad
% u = zeros(m, n-1);
% v = zeros(m-1, n);
% 
% % Calcula las diferencias finitas para obtener las componentes de velocidad de manera incremental
% for i = 1:n-1
%     % Coordenadas y marea residual para el segmento actual
%     lon_segmento = lon(:, i:i+1);
%     lat_segmento = lat(:, i:i+1);
%     marea_residual_segmento = marea_residual_tiempo(:, i:min(i+1, n-1));
%     
%     % Encuentra los índices donde no hay NaN en la marea residual
%     validos = ~any(isnan(marea_residual_segmento), 2);
%     
%     % Diferencias finitas solo en los puntos sin NaN
%     dx_lon = diff(lon_segmento(validos, :), 1, 2);
%     dy_lat = diff(lat_segmento(validos, :), 1, 1);
%     du = diff(marea_residual_segmento(validos, :), 1, 2) ./ dx_lon;
%     dv = diff(marea_residual_segmento(validos, :), 1, 1) ./ dy_lat;
% 
%     % Actualiza las matrices de velocidad solo en los puntos sin NaN
%     u(validos, i) = du; 
%     v(validos(1:end-1), i) = dv(:, 1);  % Asigna la primera columna de dv a v
% end
% 
% % Puedes ajustar las escalas según la resolución de tus datos y el intervalo de tiempo
% escala_temporal = 1;  % horas
% escala_espacial = 1;  % ajusta según la resolución espacial
% u = u / escala_temporal / escala_espacial;
% v = v / escala_temporal / escala_espacial;
% 
% % Ahora, u y v representan las componentes de velocidad de corriente debido a la marea residual en el tiempo seleccionado
% 
% %%
% clc
% % Supongamos que lon y lat son matrices 2D correspondientes a las dimensiones de marea_residual_dominio
% [m, n_lon] = size(lon);
% [m_lat, n_lat] = size(lat);
% 
% % Selecciona un tiempo específico (ajusta según tus necesidades)
% tiempo_seleccionado = 541;
% 
% % Extrae la marea residual en el tiempo seleccionado
% marea_residual_tiempo = squeeze(marea_residual_dominio(:,:,tiempo_seleccionado));
% 
% % Asegúrate de que las dimensiones de lon y lat coincidan con las de marea_residual_tiempo
% n = min(n_lon, size(marea_residual_tiempo, 2));
% lon = lon(:, 1:n);
% lat = lat(:, 1:n);
% 
% % Inicializa las matrices de velocidad
% u = zeros(m, n-1);
% v = zeros(m-1, n);
% 
% % Calcula las diferencias finitas para obtener las componentes de velocidad de manera incremental
% for i = 1:n-1
%     % Coordenadas y marea residual para el segmento actual
%     lon_segmento = lon(:, i:i+1);
%     lat_segmento = lat(:, i:i+1);
%     marea_residual_segmento = marea_residual_tiempo(:, i:i+1);
%     
%     % Encuentra los índices donde no hay NaN en la marea residual
%     validos = ~any(isnan(marea_residual_segmento), 'all');
%     
%     % Diferencias finitas solo en los puntos sin NaN
%     dx_lon = diff(lon_segmento(validos, :), 1, 2);
%     dy_lat = diff(lat_segmento(validos, :), 1, 1);
%     du = diff(marea_residual_segmento(validos, :), 1, 2) ./ dx_lon;
%     dv = diff(marea_residual_segmento(validos, :), 1, 1) ./ dy_lat;
%     
%     % Actualiza las matrices de velocidad solo en los puntos sin NaN
%     u(validos, i) = du;
%     
%     % Evita que el índice i+1 supere el límite n
%     if i+1 <= n
%         v(validos(1:end-1), i+1) = dv(:, 1);
%     end
% end
% 
% % Puedes ajustar las escalas según la resolución de tus datos y el intervalo de tiempo
% escala_temporal = 1;  % horas
% escala_espacial = 1;  % ajusta según la resolución espacial
% u = u / escala_temporal / escala_espacial;
% v = v / escala_temporal / escala_espacial;
% 
% % Ahora, u y v representan las componentes de velocidad de corriente debido a la marea residual en el tiempo seleccionado
% %%
% 
% % Selecciona un tiempo específico (ajusta según tus necesidades)
% tiempo_seleccionado = 541;
% % Extrae las componentes de velocidad en la cuadrícula 3D en el tiempo seleccionado
% u_rho = u2rho_2d(u);
% v_rho = v2rho_2d(v);
% % Grafica las componentes de velocidad tridimensionales usando quiver
% figure;
% quiver(lon, lat, u_rho, v_rho, 'AutoScale', 'on', 'Color', 'b');
% title('Componentes de Velocidad de la Marea Residual');
% xlabel('Longitud');
% ylabel('Latitud');
% axis equal;
% % Puedes personalizar el color y otros parámetros según tus preferencias