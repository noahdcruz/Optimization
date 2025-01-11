function u = gss(f, a, b, x)
  % This function takes one step of golden section search.
  % It is used as a subroutine to Brent's method.
  % Inputs:
  % f = handle to objective fcn.
  % a = left bound.
  % b = right bound.
  % x = least value (obeying a < x, < b)

  % Golden ratio
  phi = 0.618;
    
  % Place middle point.  Wider interval is on left.
  x = a + phi*(b-a);
    
  % Place xnew in wider (left) interval
  xnew = a + phi*(x-a);
  
  % Now check to see which point is lower
  fx = f(x);
  fxnew = f(xnew);
  
  if (fxnew < fx)
    % Lower point is on left.
    u = x;
  else
    % Lower point is on right.
    u = xnew;
  end

  return
  
end


