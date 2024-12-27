% Function
f = @(x, y) (x^4)/4 - (x^2)/2 + x/10 + (y^2)/2 + exp(x)/5;

% Gradient 
grad_f = @(x, y) [x^3 - x + 1/10 + exp(x)/5; y];

% Hessian
hess_f = @(x, y) [3*x^2 - 1 + exp(x)/5, 0; 0, 1];

% Tol and max iter
epsilon = 1e-5;
max_iter = 100;

% -5 to 5
x_range = -5:1:5;  
y_range = -5:1:5;  

% Storing est results
results_x = zeros(length(x_range), length(y_range));  
results_y = zeros(length(x_range), length(y_range));  
results_f = zeros(length(x_range), length(y_range)); 

delta = 1e-6;  

% for loop iteation
for i = 1:length(x_range)
    for j = 1:length(y_range)
        
        % Starting point
        x = x_range(i);
        y = y_range(j);
        
        % Newton's Method Iteration
        for iter = 1:max_iter
            % Gradient and Hessian
            g = grad_f(x, y);
            H = hess_f(x, y);
            
            % Newton's update step
            p = -H \ g;
            m = @(t) f(x + t*p(1),y+t*p(2));
            delta = fminsearch(m, 1);
            
            % Update
            x = x + p(1) * delta;
            y = y + p(2) * delta;
            
            % Check stopping criteria 
            if norm(g) <= epsilon * (1 + abs(f(x, y)))
                break;
            end
        end
        
        % Store
        results_x(i, j) = x;  
        results_y(i, j) = y;  
        results_f(i, j) = f(x, y);  
        
        % This is checkig for local minimum
        f_star = f(x, y);
        f_left = f(x - delta, y);
        f_right = f(x + delta, y);
        
        if f_star < f_left && f_star < f_right
            local_minimum_check = 'Pass';
        else
            local_minimum_check = 'Fail';
        end
        
        % Display
        fprintf('Starting point: (%d, %d) -> Converged to: (%.4f, %.4f) with f(x,y) = %.4f in %d iter, Local Min Check: %s\n', ...
            x_range(i), y_range(j), x, y, f(x, y), iter, local_minimum_check);
    end
end
