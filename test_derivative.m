
% Will comment my code out to point out ny steps and when there were
% problems 

% Point 
x0 = 2;
% Step sizes for h
h_values = [0.1, 0.01, 0.001, 0.0001];
% I am just storing the errors in the arays
forward_error = zeros(size(h_values));
centered_error = zeros(size(h_values));
% Derivative
df_exact = @(x) 3*x.^2 - 10*x + 7; 

% For loop that goes through each h value and does the derivative
for i = 1:length(h_values)
    h = h_values(i);
    
    % Fwd
    fwd_diff = (p(x0 + h) - p(x0)) / h;
    
    % Mid
    mid_diff = (p(x0 + h) - p(x0 - h)) / (2 * h);
    
    % Errors
    forward_error(i) = abs(fwd_diff - df_exact(x0));
    centered_error(i) = abs(mid_diff - df_exact(x0));
end

% Call the test function to check the results
test_finite_difference(forward_error, centered_error);

% Plot (I used AI on this plotting syntax as I am unfamiliar with Matlab
% plot syntax)
figure;
loglog(h_values, forward_error, 'ro-', 'LineWidth', 2);
hold on;
loglog(h_values, centered_error, 'bo-', 'LineWidth', 2);
xlabel('h');
ylabel('Error');
legend('fwd diff', 'mid diff');
title('Finite Diff Error vs. Step Size h');
grid on;

% Function
function px = p(x)
    px = x.^3 - 5*x.^2 + 7*x - 2;
end

% Test function to see if errors are decreasing
function test_finite_difference(forward_error, centered_error)
    fwd_decreasing = all(diff(forward_error) < 0);
    mid_decreasing = all(diff(centered_error) < 0);
    
    if fwd_decreasing
        fprintf('Fwd errors are decreasing as h decreases as expected.');
    else
        fprintf('Fwd errors are not going down.');
    end
    
    if mid_decreasing
        fprintf('Mid errors are decreasing as h decreases as expected.');
    else
        fprintf('Mid errors are not going down.');
    end
end

