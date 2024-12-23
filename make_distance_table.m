function T = make_distance_table(P)
    N = size(P, 2);  % Number of cities
    T = zeros(N, N); % Initialize the distance matrix
    
    % Compute the Euclidean distance between each pair of cities
    for i = 1:N
        for j = 1:N
            T(i,j) = sqrt((P(1,i) - P(1,j))^2 + (P(2,i) - P(2,j))^2);  % Euclidean distance
        end
    end
end
