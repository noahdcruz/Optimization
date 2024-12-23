function [best_order, min_distance] = run_brute_force(N, distance_matrix, current_order, current_min)
    % city names 
    city_names = arrayfun(@(x) char(x + 96), 1:N, 'UniformOutput', false);
    
    % Start with the first city and get permutations of the rest
    start_city = city_names{1};
    cities_to_permute = city_names(2:end);
    
    % best found order and distance
    min_distance = current_min;
    best_order = current_order;

    % all possible routes
    possible_routes = perms(cities_to_permute);
    
    % Iterate 
    num_routes = size(possible_routes, 1);
    for route_idx = 1:num_routes
        this_route = [start_city, possible_routes(route_idx,:), start_city];
        route_distance = calculate_total_distance(city_names, this_route, distance_matrix);
        if route_distance < min_distance
            min_distance = route_distance;
            best_order = this_route;
        end
    end
    
    % Output
    fprintf('Minimum travel distance found: %.6f\n', min_distance);
    fprintf('Best visiting order: \n');
    disp(best_order);
end

function total_distance = calculate_total_distance(city_names, visit_order, distance_matrix)
    total_distance = 0;
    
    for city_idx = 1:(length(visit_order) - 1)
        current_city_idx = find(strcmp(city_names, visit_order{city_idx}));
        next_city_idx = find(strcmp(city_names, visit_order{city_idx + 1}));
        total_distance = total_distance + distance_matrix(current_city_idx, next_city_idx);
    end
end
