function plot_parabola(fobj, p, a, b, c, xs)
  % Inputs:
  % p = Coeffs of parabola.
  % a = Left wall.
  % b = Middle point.
  % c = Right wall.
  % xs = bottom of parabola identified by calculation.
  
  global xl
  global xr
  global pplot
  
  % Clear out old plots before making new ones.
  delete(pplot.main);
  delete(pplot.a);
  delete(pplot.b);
  delete(pplot.c);  
  delete(pplot.xs);
  
  % Make fcn to plot based on input values.
  N = 100;
  x = linspace(xl, xr, N);
  f = @(xi) p(1) + p(2)*xi + p(3)*xi.*xi;
  
  % Now make new plots.
  pplot.main = plot(x, f(x), 'b--','LineWidth',2);
  hold on
  pplot.a = plot(a, f(a), 'bo', 'MarkerSize',12,'MarkerFaceColor','b');
  pplot.b = plot(b, f(b), 'k*', 'MarkerSize',12,'MarkerFaceColor','k');
  pplot.c = plot(c, f(c), 'go', 'MarkerSize',12,'MarkerFaceColor','g'); 
  if (~isempty(xs))
    pplot.xs = plot(xs, f(xs), 'rs', 'MarkerSize',12,'MarkerFaceColor','r');
  end
  
end