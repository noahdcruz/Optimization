
% Eigenvalues are negative 

function test3_rearranged()
  % Grid size and range
  grid_size = 100;
  x_range = linspace(-1, 4, grid_size);
  y_range = linspace(-1, 4, grid_size);
  
  % Meshgrid for x and y values
  [xm, ym] = meshgrid(x_range, y_range);
  
  % Plot
  figure(1);
  zm = zeros(grid_size);
  for row = 1:grid_size
      for col = 1:grid_size
          zm(row, col) = f([xm(row, col), ym(row, col)]);
      end
  end
  contour(xm, ym, zm, 40);
  hold on;
  
  % Track for succss and failed
  success_points = -zeros(20, 2);
  start_points = -zeros(20, 2);
  fail_count = 0;
  success_count = 0;
  epsilon_threshold = 1e-5;
  epsilon_vector = [epsilon_threshold, epsilon_threshold];

  % FOR loop that goes through starting points
  for x0 = 0:1:4
      for y0 = 0:1:4
          start_point = [x0; y0];
          result_point = newton_optimizer(@f, @lgrad, @hess0, start_point, epsilon_threshold);
          
          % Check minimum
          if f(result_point) < f(result_point + epsilon_vector) && f(result_point) < f(result_point - epsilon_vector)
              fprintf('Found minimum at (%f, %f)\n, start at (%f, %f)', result_point(1), result_point(2), x0, y0);
              success_count = success_count + 1;
              success_points(success_count, :) = result_point';
              start_points(success_count, :) = [x0, y0];
          else
              fprintf('Start point (%d, %d). Failed to find minimum at (%f, %f)\n', x0, y0, result_point(1), result_point(2));
              fail_count = fail_count + 1;
          end
      end
  end

  % This code I just wanted to showthe counter for fail and pass
  fprintf('Failures: %d, Successes: %d\n', fail_count, success_count);
  
  % Plot for sucess
  for i = 1:success_count
      fprintf('Start point (%d, %d). Found minimum at (%f, %f)\n', start_points(i, 1), start_points(i, 2), success_points(i, 1), success_points(i, 2));
      plot(success_points(i, 1), success_points(i, 2), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
  end
end


function fx = f(X)
  fx = -exp(-(X(1)*X(2) - 1.5)^2 - (X(2) - 1.5)^2);
end

function h = hess0(X)
  a = 1.5;
  x1 = X(1);
  x2 = X(2);

  h11 = -4 * x2^2 * (x1 * x2 - a)^2 * exp(-(x1 * x2 - a)^2 - (x2 - a)^2) + 2 * x2^2 * exp(-(x1 * x2 - a)^2 - (x2 - a)^2);
  h12 = 2 * x1 * x2 * exp(-(x1 * x2 - a)^2 - (x2 - a)^2) + 2 * x2 * (x1 * x2 - a) * (2 * a - 2 * x1 * (x1 * x2 - a) - 2 * x2) * exp(-(x1 * x2 - a)^2 - (x2 - a)^2);
  h21 = -2 * x2 * (x1 * x2 - a) * (-2 * a + 2 * x1 * (x1 * x2 - a) + 2 * x2) * exp(-(x1 * x2 - a)^2 - (x2 - a)^2) + (-2 * a + 4 * x1 * x2) * exp(-(x1 * x2 - a)^2 - (x2 - a)^2);
  h22 = (2 * x1^2 + 2) * exp(-(x1 * x2 - a)^2 - (x2 - a)^2) + (-2 * a + 2 * x1 * (x1 * x2 - a) + 2 * x2) * (2 * a - 2 * x1 * (x1 * x2 - a) - 2 * x2) * exp(-(x1 * x2 - a)^2 - (x2 - a)^2);

  h = [h11, h12; h21, h22];  
end

function Y = lgrad(X)
  a = 1.5;
  x1 = X(1);
  x2 = X(2);

  xn = 2 * x2 * (x1 * x2 - a) * exp(-(x1 * x2 - a)^2 - (x2 - a)^2);
  yn = -(2 * a - 2 * x1 * (x1 * x2 - a) - 2 * x2) * exp(-(x1 * x2 - a)^2 - (x2 - a)^2);

  Y = [xn; yn];
end

function X = newton_optimizer(objective_fn, grad_fn, hessian_fn, initial_X, tolerance)
    % Initial point
    X = initial_X;
    fprintf('Starting point X = [%8.5f, %8.5f]\n', X(1), X(2));
    plot(X(1), X(2), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 5);
    hold on;

    % Loop to 100 for Newton's method
    for iteration = 1:100
        % Function, gradient, and Hessian
        current_fx = objective_fn(X);
        current_grad = grad_fn(X);
        current_hessian = hessian_fn(X);

        % Hssian check
        if rcond(current_hessian) < 1e-20
            fprintf('Hessian matrix is near singular, exiting after %d iterations.\n', iteration);
            return;
        end

        % search direction
        search_direction = -current_hessian \ current_grad;

        % Line search
        line_search_fn = @(step_size) objective_fn(X + step_size * search_direction);
        optimal_step_size = fminsearch(line_search_fn, 1);

        % Updateing with each new step
        X = X + optimal_step_size * search_direction;

        % Convergence check
        if norm(current_grad) < tolerance
            fprintf('Terminating after %d iterations due to small gradient norm < tolerance.\n', iteration);
            return;
        end
    end
end

