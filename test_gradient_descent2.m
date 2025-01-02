function test_gradient_descent2()
    % Objective function and its gradient
    fcn = @f;
    gra = @gra;
    
    % Tolwrance
    tol = 1e-5;

    % [-5, 5] for both x and y
    [Xgrid, Ygrid] = meshgrid(-5:1:5, -5:1:5);
    num_points = numel(Xgrid);

    % Array to store
    minima = zeros(num_points, 2);

    % Loop 
    for i = 1:num_points
        X0 = [Xgrid(i), Ygrid(i)];
        
        % gradient descent backtracking
        X_min = gradient_descent_backtracking(fcn, gra, X0, tol);
        
        % Local min
        if is_local_minimum(fcn, X_min)
            minima(i, :) = X_min;  
            fprintf('Startpoint (%d, %d). Found the minimum: (%.5f, %.5f)\n', X0(1), X0(2), X_min(1), X_min(2));
        else
            fprintf('Startpoint (%d, %d). Did not converge to a valid minimum\n', X0(1), X0(2));
        end
    end

    % Display 
    disp('Converged minima for each start point:');
    disp(minima);

    % Plotting
    x = -5:0.1:5; 
    y = -5:0.1:5;
    [X, Y] = meshgrid(x, y);
    Z = f([X(:), Y(:)]); 
    Z = reshape(Z, size(X)); 

    figure; 
    contour(X, Y, Z, 50); 
    hold on;

    % Initial grid points as blue dots
    plot(Xgrid(:), Ygrid(:), 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');

    % Converged minima as red dots
    plot(minima(:, 1), minima(:, 2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

    % Plot
    title('Contour Plot with Converged Minima from Gradient Descent');
    xlabel('x');
    ylabel('y');
    hold off;
end

function fx = f(X)
    x = X(:, 1);  
    y = X(:, 2);  
    fx = x.^4 ./ 4 - x.^2 ./ 2 + x ./ 10 + y.^2 ./ 2 + exp(x) ./ 5;
end

function Y = gra(X)
    xn = X(1)^3 - X(1) + 1 / 10 + exp(X(1)) / 5;
    yn = X(2);
    % Clip the gradient to avoid extreme values
    xn = min(max(xn, -10), 10);  
    yn = min(max(yn, -10), 10);  
    Y = [xn, yn];
end

% Backtracking gradient descent with Armijo rule
function X_min = gradient_descent_backtracking(fcn, gra, X0, tol)
    max_iter = 100;
    alpha = 1;  
    beta = 0.5; 
    c1 = 1e-4;  

    X = X0;
    for iter = 1:max_iter
        grad = gra(X);
        if norm(grad) < tol
            break;
        end

        % Backtracking
        alpha_tmp = alpha;
        while fcn(X - alpha_tmp * grad) > fcn(X) - c1 * alpha_tmp * norm(grad)^2
            alpha_tmp = beta * alpha_tmp;  
        end

        % Update step
        X = X - alpha_tmp * grad;
    end
    X_min = X;
end

% Local minimum check
function is_min = is_local_minimum(fcn, X)
    epsilon = 1e-5;
    fx = fcn(X);
    fx_plus = fcn(X + epsilon);
    fx_minus = fcn(X - epsilon);
    
    is_min = fx < fx_plus && fx < fx_minus;
end
