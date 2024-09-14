function pos = plot_sensor(D, room_grid,q,occorrenze)
    S = D;
    for i = 1:q
        S(i,:) = max_filter(D(i,:),1,0);
        S(i,:);
        pos(i,1) = find(S(i,:));
        real_sensors = find(S(i,:));
        x = room_grid(1,real_sensors);
        y = room_grid(2,real_sensors);
        r = 20; % Raggio del cerchio
        c = [1 1 0]; % Colore giallo
        
        % Calcolo dei punti del cerchio
        theta = linspace(0, 2*pi, 100);
        xc = r * cos(theta) + x;
        yc = r * sin(theta) + y;
        
        % Plottaggio dell'area opaca come cerchio
        fill(xc, yc, c, 'EdgeColor', 'none', 'FaceAlpha', 0.5);
        hold on;
        grid on;
        if occorrenze(i)> 1    
            stringa = num2str(occorrenze(i));
            text(x, y, stringa , 'Color', 'black', 'FontSize', 8, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
        end
    end