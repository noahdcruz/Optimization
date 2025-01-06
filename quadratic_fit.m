function xstar = quadratic_fit(f, a, b, c, tol)
  % This is the quadratic fit algorithm (successive parabola interpolation)
  % f = handle to objective function
  % a, b, c = initial points
  % tol = stopping tolerance

  % Turn off warnings for matrix singularities
  warning('off', 'MATLAB:nearlySingularMatrix');

  % Sample objective function at three points
  ya = f(a);
  yb = f(b);
  yc = f(c);

  % Use for loop instead of while loop to prevent infinite loops
  for i = 1:100
    % Solve Vandermonde system to get coefficients of the fitted parabola
    y = [ya; yb; yc];
    A = [1, a, a^2; 1, b, b^2; 1, c, c^2];
    p = A\y;

    % This is the minimum of the parabola
    x = -p(2) / (2 * p(3));
    yx = f(x);

    % Check for convergence
    if abs(x - c) < tol
      xstar = x;
      return;
    end

    % Shift points to get the next triplet for fitting
    a = b;
    ya = yb;
    b = c;
    yb = yc;
    c = x;
    yc = yx;
  end

  % If the algorithm does not converge within 100 iterations
  error('Did not converge!');
end