function newton_optimizer_quadratic()
    % Initial point
    X = [2; 2];  
    
    % This just toleratnce
    tol = 1e-6;

    % Iterations
    max_iter = 10;

    fprintf('Starting point X = [%8.5f, %8.5f]\n', X(1), X(2));

    % Newtons
    for i = 1:max_iter
        % Function value, gradient, and Hessian
        f_value = fcn_quadratic(X);      
        grad = mygrad_quadratic(X);       
        H = myhess_quadratic(X);      
        
        % Newton Step
        p = -H \ grad;  
        
        % Update the points
        X = X + p;  
        
        % Just print after each iterations
        fprintf('Step %d: X = [%8.5f, %8.5f], f(X) = %8.5f\n', i, X(1), X(2), f_value);
        
        % Convergence check
        if norm(p) < tol
            fprintf('Stopping after %d iterations because step norm < tol.\n', i);
            break;
        end
    end
    
    fprintf('Done optimization after %d iterations.\n', i);
end

% Quadratic function
function f = fcn_quadratic(X)
    x1 = X(1);
    x2 = X(2);
    f = (x1^2 / 4) + (x2^2 / 9);  
end

% Gradient
function grad = mygrad_quadratic(X)
    x1 = X(1);
    x2 = X(2);
    grad = [x1/2; (2/9)*x2]; 
end

% Hessian
function H = myhess_quadratic(X)
    H = [1/2, 0; 0, 2/9]; 
end
