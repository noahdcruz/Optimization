function newton_optimizer_quartic()
    % Initial point
    X = [2; 2];  
    
    % Tol
    tol = 1e-6;

    % Max iterations
    max_iter = 100;

    fprintf('Starting point X = [%8.5f, %8.5f]\n', X(1), X(2));

    % Newton's method
    for i = 1:max_iter
        % Function value, gradient, and Hessian 
        f_value = fcn_4th(X);       
        grad = mygrad_4th(X);       
        H = myhess_4th(X);          
        
        % Newton Step
        p = -H \ grad;  
        
        % Update currnet point
        X = X + p;  
        
        % Print result each time
        fprintf('Step %d: X = [%8.5f, %8.5f], f(X) = %8.5f\n', i, X(1), X(2), f_value);
        
        % Convergence check
        if norm(p) < tol
            fprintf('Closing after %d iterations because step norm < tol.\n', i);
            break;
        end
    end
    
    fprintf('Finished optimization after %d iterations.\n', i);
end

% Quartic function 
function f = fcn_4th(X)
    x1 = X(1);
    x2 = X(2);
    f = (x1^4 / 4) + (x2^4 / 9);  
end

% Gradient 
function grad = mygrad_4th(X)
    x1 = X(1);
    x2 = X(2);
    grad = [x1^3; (4/9)*x2^3];  
end

% Hessian 
function H = myhess_4th(X)
    x1 = X(1);
    x2 = X(2);
    H = [3*x1^2, 0; 0, (4/3)*x2^2]; 
end
