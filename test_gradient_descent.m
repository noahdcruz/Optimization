function test_gradient_descent()
    % I did 5 itrations with random matrices
    for iteration = 1:5
        fprintf('\nIteration %d:\n', iteration);
        
        % THis is to generat random symmetric positive definite matrix A
        % also in profesors instructions
        B = randn(5, 5);
        A = B' * B;  
        
        % This if else for check on symmetry
        symmetry_check = norm(A - A', 'fro');
        if symmetry_check > 1e-10
            fprintf('Warning: Matrix A is not perfectly symmetric (symmetry error: %e)\n', symmetry_check);
        else
            fprintf('Matrix A is symmetric.\n');
        end
        
        % Check if A is positive definite, all eigenvalues must be positive
        eigenvalues = eig(A);
        if all(eigenvalues > 0)
            fprintf('Matrix A is positive definite (smallest eigenvalue: %e).\n', min(eigenvalues));
        else
            fprintf('Matrix A is not positive definite (min eigenvalue: %e)\n', min(eigenvalues));
            continue;  % Skip this iteration if matrix is not positive definite
        end
        
        % Radnom vector 
        b = randn(5, 1);
        
        % Initial guess
        X0 = zeros(5, 1);
        
        % Tolerance
        tol = 1e-6;
        
        % Gradient descent
        X_solution = gradient_descent(A, b, X0, tol);
        
        % Display
        fprintf('Solution found by gradient descent:\n');
        disp(X_solution);
        
        % \
        X_exact = A \ b;
        
        % Display 
        fprintf('Exact solution using MATLAB solver:\n');
        disp(X_exact);
        
        % Difference between the solutions
        difference = norm(X_solution - X_exact);
        
        % Display 
        fprintf('Difference between gradient descent solution and exact solution: %e\n', difference);
    end
end

% function
function fx = fcn(x, A, b)
    fx = 0.5 * x' * A * x - x' * b;
end

% Gradient 
function gx = grad(x, A, b)
    gx = A * x - b;
end

