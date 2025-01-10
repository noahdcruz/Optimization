% Brent's method function for optimizing a 1D unimodal function
function xstar = brents_method(f, a, b, tol)
  % This implements Brent's method for optimizing a 1D unimodal function.
  
  % Compute starting values
  psi = (sqrt(5)-1)/2;  % Golden ratio
  x = a + psi * (b - a); % Golden ratio to find first x
  
  % Running measure of the last step
  sm1 = inf;

  % Brent's method loop
  for cnt = 1:50
    % Try to get a new point u using SPI (Successive Parabolas Interpolation)
    u = spi(f, a, b, x);  % SPI function for Brent's method
    do_gss = 0;
    
    % If SPI fails, do golden section search (GSS)
    if isnan(u) || abs(u - x) > sm1 / 2
      u = gss(f, a, b, x);  % GSS if SPI fails
      do_gss = 1;
    end
    
    % Now evaluate f at new points and update boundaries as needed
    fu = f(u);
    fx = f(x);
    
    if fu <= fx
      if u >= x
        a = x;
        x = u;
      else
        b = x;
        x = u;
      end
    else
      if u < x
        a = u;
      else
        b = u;
      end
    end
    
    % Check for convergence
    if (b - a) < tol
      xstar = u;
      return;
    end
    
    sm1 = abs(u - x);  % Update step size for next iteration
  end
  
  % If the method fails to converge within 50 iterations
  error('Brent''s method failed to converge!');
end