function test_weibull_fit()
    % Winf velovity data
    wind_data = csvread('wind_speed_boston_corrected.csv');
    % This is wind speed
    x = wind_data(:, 1); 
    
    % Initial guesses for Weibull parameters [k0, lambda0]
    u0 = [2, 4];  
    tol = 1e-6;
    
    % Gradient
    estimated_params = mygd(x, u0, tol);
    
    % Display
    disp('Estimated Weibull parameters:');
    disp(['k (scale) = ', num2str(estimated_params(1))]);
    disp(['lambda (shape) = ', num2str(estimated_params(2))]);
    
    % Compare
    plot_fit(x, estimated_params(1), estimated_params(2));
end

function plot_fit(x, k, lambda)
    % istogram of the wind data
    histogram(x, 'Normalization', 'probability', 'DisplayName', 'Data Histogram');
    hold on;
    
    % Weibull PDF values 
    x_vals = linspace(min(x), max(x), 100);
    weibull_pdf = f(x_vals, k, lambda);
    
    % Weibull PDF
    plot(x_vals, weibull_pdf, 'r', 'LineWidth', 2, 'DisplayName', 'Fitted Weibull');
    
    % Plot
    title('Histogram of Wind Data and Fitted Weibull PDF');
    xlabel('Wind Speed (m/s)');
    ylabel('Probability Density');
    legend;
    hold off;
end

function wb = f(x, k, lambda)
    % Weibull prob density function
    wb = (k / lambda) * (x / lambda).^(k - 1) .* exp(-(x / lambda).^k);
end

function l = L(x, k, lambda)
    % Log-likelihood 
    l = (log(k + eps) + (k - 1) * log(x + eps) - k * log(lambda + eps) - (x / lambda).^k);
end

function [pk, pl] = L_grad(x, k, lambda)
    % Gradient log-likelihood
    pl = -k / lambda + k * (x / lambda).^k / lambda;
    pk = 1 / k + log(x + eps) - log(lambda + eps) - (x / lambda).^k .* log(x / lambda + eps);
end

function ustar = mygd(x, u0, tol)
    % Gradient descent
    lr = 0.00001;  
    
    % Initialize variables
    un = u0;
    
    % Iterate 10,000 times
    max_iter = 10000;
    for idx = 1:max_iter
        % Grradient of the log-likelihood
        [pk, pl] = L_grad(x, un(1), un(2));
        grad = [sum(pk), sum(pl)];
        
        % Update the para with gradient
        step = lr * grad;
        unp1 = un + step;
        
        % Check for convergence
        if norm(step) < tol
            fprintf('Converging took %d steps.\n', idx);
            ustar = unp1;
            return;
        end
        
        % Update variables for next iteration
        un = unp1;
    end
    
    % Goes back to the point if it doesnt converge
    ustar = unp1;
    fprintf('Algorithm did not converge within %d iterations.\n', max_iter);
end

