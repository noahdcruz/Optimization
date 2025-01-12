function test_brents_method_nasty()
  % Tol
  tol = 1e-5;  
  
  % This from the problem
  x0 = -1;   
  sigma = 4; 
  
  % Function
  f = @(x) 1 - exp(-((x - x0).^2) / sigma);
  
  % Left and Right Bound
  a = -10;  
  b = 10;  
  
  % Expected min. Min set at xo is -1
  expected_min = x0; 

  % Brents method
  xstar = brents_method(f, a, b, tol);

  % See if brent is close
  if abs(xstar - expected_min) < tol
        disp('Brent method test PASSED');
  else
        disp('Brent method test FAILED');
  end


  % Plot
  x = linspace(a, b, 100);    
  figure;
  plot(x, f(x), 'b-', 'LineWidth', 1.5); 
  hold on;
  plot(xstar, f(xstar), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');  
  title('Found Minimum and function');
  xlabel('x');
  ylabel('f(x)');
  legend('Function', 'Minimum point')
  hold off;
  
end

