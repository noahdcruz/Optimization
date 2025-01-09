function test_quadratic_fit_nasty()
  global xl xr
  
  Ntrial = 3;
  xmax = 10;
  tol = 1e-3;
  % Parameters mentioned in question
  x0 = -1;
  sigma = 4;
  
  % Nasty function
  f = @(x) 1 - exp(-((x - x0).^2) / sigma);
  
  % Pass and Fail
  pass = 0;
  fail = 0;

  % This is start values from the Profesors code 
  a = -xmax;           % Left wall
  c = xmax;            % Right wall
  b = a + 0.618*(c-a); % Midpoint

  % Storing results
  results_xstar = zeros(Ntrial, 1);

  for i = 1:Ntrial
    try
      % Quadratic fit
      xstar = quadratic_fit(f, a, b, c, tol / 5);
      % Store
      results_xstar(i) = xstar;

      % This if else is to check if the result is within tolerance
      if abs(xstar - x0) < tol
        pass = pass + 1;
      else
        fail = fail + 1;
      end
    catch
      % If any eror, I am marking it as a failuer
      fprintf('Quadratic fit failed in trial %d\n', i);
      fail = fail + 1;
    end
  end

  % fsolve to find the true minimum. I had to redownload/reinstall
  % fsovel for some reason, despite doing it previously
  % Suppress fsolve output (I used matlab online forums for this because I did not want
  % concstant progression updates)
  options = optimset('Display','off'); 
  % First initial guess at 0
  true_min_x = fsolve(@(x) df_nasty(x, x0, sigma), 0, options);  
  true_min_y = f(true_min_x);

  % syntax for plotting 
  x = linspace(a, c, 100);
  figure;
  plot(x, f(x), 'k-', 'LineWidth', 1); 
  hold on;
  plot(c, f(c), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'DisplayName', 'Starting Point 1');
  plot(a, f(a), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'DisplayName', 'Starting Point 2');
  if pass > 0
    plot(results_xstar, f(results_xstar), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'DisplayName', 'Found Minima');
  end
  plot(true_min_x, true_min_y, 'gx', 'MarkerSize', 12, 'LineWidth', 2, 'DisplayName', 'True Minimum (fsolve)');
  title('Nasty Function and Found, True Minima');
  xlabel('x');
  ylabel('f(x)');
  if (fail == 0)
      legend('Function', 'SP 1', 'SP 2', 'Found Minima', 'True Minimum');
  else
      legend('Function', 'SP1', 'SP2',  'True Minimum');
      text(0, 0.5, 'Method cant find result xmax is too big', 'FontSize', 12, 'Color', 'red','HorizontalAlignment', 'center');
  end
  
  hold off;

  % Final results
  fprintf('Amount of trials = %d, passed = %d, failed = %d\n', Ntrial, pass, fail);
  fprintf('True minimum found by fsolve at x = %f, f(x) = %f\n', true_min_x, true_min_y);

end

% Derivative 
function dfdx = df_nasty(x, x0, sigma)
  dfdx = (2 * (x - x0) / sigma) * exp(-((x - x0).^2) / sigma);
end
