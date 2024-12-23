function p3()
    % Range
    city_range = 5:12;  
    start_timer = tic;  

    for num_cities = city_range
        fprintf('Evaluating for N = %d cities...\n', num_cities);

        % City coordinates and distance matrix
        city_positions = make_cities(num_cities);
        distance_matrix = make_distance_table(city_positions);
        fprintf('Running Simulated Annealing...\n');
        [best_order_anneal, min_distance_anneal] = run_simulated_annealing(num_cities, city_positions, distance_matrix);
        anneal_duration = toc(start_timer);  

        % Brute Force Method
        fprintf('Running Brute Force Method...\n');
        [~, min_distance_brute] = run_brute_force(num_cities, distance_matrix, best_order_anneal, min_distance_anneal);
        brute_duration = toc(start_timer) - anneal_duration;  

        % Output results
        fprintf('Results for N = %d:\n', num_cities);
        fprintf('Simulated Annealing Distance: %.6f, Time: %.4f seconds\n', min_distance_anneal, anneal_duration);
        fprintf('Brute Force Distance: %.6f, Time: %.4f seconds\n', min_distance_brute, brute_duration);

        if abs(min_distance_anneal - min_distance_brute) < 1e-5
            fprintf('Found the optimal solution.\n');
        else
            fprintf('Did not find the optimal solution.\n');
        end
    end

    total_duration = toc(start_timer);  
    fprintf('Time: %.2f seconds\n', total_duration);
end
