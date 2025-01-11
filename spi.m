function u = spi(f, a, b, x)
  % This function takes one step of quadratic fit.
  % I renamed it spi here = successive parabolic interpolation.
  % This function accepts the following input:
  % f = handle to objective function.
  % a = left bound
  % b = right bound
  % x = midpoint to use

  tol = 1e-10;  % Tol used to judge if SPI is well behaved.
    
  warning('off','MATLAB:nearlySingularMatrix');
  warning('off','MATLAB:singularMatrix');

  % Sample objective function at three points.
  ya = f(a);
  yb = f(b);
  yx = f(x);

  % Solve Vandermonde system to get coeffs of fitted parabola.
  y = [ya; yb; yx];
  A = [1, a, a^2; 1, b, b^2; 1, x, x^2];
  p = A\y;
  
  % For Brent-s method, check that SPI is well-behaved.  If not,
  % return nan.
  if (abs(p(3)) < tol) 
    u = nan;
    return
  end
  
  % Compute new point -- minimum of parabola.
  u = -p(2)/(2*p(3));
  % Check for good behavior.  Return nan if behavior is bad.
  if ((u<a) || (u>b))
    u = nan;
    return
  end

  % Two checks passed, return new u
  return
  
end
  
  