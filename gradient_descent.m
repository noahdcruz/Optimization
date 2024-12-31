function X = gradient_descent(A, b, X0, tol)

  % Armijo I kept messing around with this
  c1 = 0.001;

  % Initialize X as innital guess
  X = X0;

  % itierations
  max_iter = 4000;

  % for loop
  for i = 1:max_iter
    % fucntion
    fx = 0.5 * X' * A * X - X' * b;
    
    % gradient
    grad = A * X - b;

    % backtracking line Armijo's rule
    alpha = 1;  
    X_step = X - alpha * grad;
    fx_step = 0.5 * X_step' * A * X_step - X_step' * b;

    % Iterate to finds right step size
    for j = 1:25
      if fx_step >= fx - c1 * alpha * norm(grad)
        % If not satisfied, I make the size smaller
        alpha = alpha / 2;
        X_step = X - alpha * grad;
        fx_step = 0.5 * X_step' * A * X_step - X_step' * b;
      else
        % Armijo's condition satisfied
        break;
      end
    end

    % New solution using the step size
    X = X - alpha * grad;

    % Check if the stopping criterion is met
    if norm(grad) < tol
      fprintf('Converged after %d iterations.\n', i);
      return;
    end
  end

  % If it doesnt converge
  fprintf('Max iterations reached without convergence.\n');
end
