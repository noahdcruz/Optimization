function test_brents_method()
  % Tol
  tol = 1e-5;  
  
  % This from the problem
  x0 = 5;   
  sigma = 3; 
  
  % Function
  f = @(x) x .* tanh((x - x0) / sigma);
  
  % left and right bounds
  a = -10;  
  b = 10; 

  % Expected min (Usinf fsolve for this)
  expected_min = fsolve(@(x) derivative_of_f(x, x0, sigma), 0); 
  
  % Brent's method
  xstar = brents_method(f, a, b, tol);

  % See if brent is close
  if abs(xstar - expected_min) < tol
        disp('Brent''s method test PASSED');
  else
        disp('Brent''s method test FAILED');
  end

  % Plot 
  x = linspace(a, b, 100);   
  figure;
  plot(x, f(x), 'b-', 'LineWidth', 1.5); 
  hold on;
  plot(xstar, f(xstar), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');  
  title('Found Minimum on function');
  xlabel('x');
  ylabel('f(x)');
  legend('Function', 'Minimum point')
  hold off;
  

end

function df = derivative_of_f(x, x0, sigma)
    % Derivative
    df = tanh((x - x0) / sigma) + (x / sigma) * (1 - tanh((x - x0) / sigma).^2);
end

