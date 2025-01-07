function test_quadratic_fit()
  global xl xr
  
  Ntrial = 3;
  xmax = 10;
  tol = 1e-3;
  % Parameters mentioned in question 
  x0 = 5;
  sigma = 3;
  
  % Function
  f = @(x) x .* tanh((x - x0) / sigma);
  
  % Pass and fail 
  pass = 0;
  fail = 0;

  % This from the Profesors code on canvas
  a = -xmax;           % Left wall
  c = xmax;            % Right wall
  b = a + 0.618*(c-a); % Midpoint

  % Storing results
  results_xstar = zeros(Ntrial, 1);

  for i = 1:Ntrial
    % Quadratic fit
    xstar = quadratic_fit(f, a, b, c, tol/5);
    
    % Store
    results_xstar(i) = xstar;

  % Try fsolve to find the true minimum. For some reason my computer had to
  % restart twice to download fsolve
  options = optimset('Display','off'); 
  true_min_x = fsolve(@(x) df(x, x0, sigma), 0, options); 
  true_min_y = f(true_min_x);

  % This if else is to check if the result is within tolerance
    if abs(xstar - true_min_x) < tol
      pass = pass + 1;
    else
      fail = fail + 1;
    end
  end

  % Plot 
  x = linspace(a, c, 100);
  figure;
  plot(x, f(x), 'k-', 'LineWidth', 1);  
  hold on;
  
  % I used AI to help me with this plotting syntax on Starting point, found minima and True minimum as I am unfamililar
  % with Matlab plotting and labeling. Also was thinkning of a way to for loop this code to make
  % it less manuala nd repettive

  % Starting point
  plot(c, f(c), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'DisplayName', 'Starting Point1');
  plot(a, f(a), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'DisplayName', 'Starting Point2');

  % Found minima
  plot(results_xstar, f(results_xstar), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'DisplayName', 'Found Minima');
  
  % True minimum
  plot(true_min_x, true_min_y, 'gx', 'MarkerSize', 12, 'LineWidth', 2, 'DisplayName', 'True Minimum (fsolve)');

  % This is just axises and legends
  title('Function and Found, True Minima');
  xlabel('x');
  ylabel('f(x)');
  legend('Function', 'SP1', 'SP2',  'Found Minima', 'True Minimum');
  hold off;

  % Final statemtsn
  fprintf('Amt of trials = %d, passed = %d, failed = %d\n', Ntrial, pass, fail);
  fprintf('True minimum found by fsolve at x = %f, f(x) = %f\n', true_min_x, true_min_y);

end

% This is just the deritvatice of the function
function dfdx = df(x, x0, sigma)
  dfdx = tanh((x - x0) / sigma) + (x / sigma) * (1 - tanh((x - x0) / sigma).^2);
end
