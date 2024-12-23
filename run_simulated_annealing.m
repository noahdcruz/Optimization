function [Vs, ds] = run_simulated_annealing(N, P, T)
 
  for i=1:N
    C{i} = char(i+96); 
  end
  
  V = horzcat(C, C(1));
  dn = compute_travel_distance(C, V, T);
  ds = dn;   
  Vs = V;

  fprintf('Initial visiting order')
  disp(V)
  idn = dn;  
  fprintf('Total initial travel distance = %f\n', idn)

  
  Temp = 500;
  alpha = 0.95;
  
  for i=1:300
    
    
    for m = 1:500
      
      is = randperm(N-1)+1;
      j = is(1);
      k = is(2);
      
      
      Vp = V;
      Vp{j} = V{k};
      Vp{k} = V{j};
      
      
      dnp1 = compute_travel_distance(C, Vp, T);
      
      
      if (dnp1 < dn)
	
	V = Vp;
	dn = dnp1;
      else
	
	r = rand();                  
	act = exp(-(dnp1-dn)/Temp);  
	if (act > r)
	  
	  V = Vp;
	  dn = dnp1;
	else
	  
	  V = V;
	  dn = dn;
	end
      end

      
      if (dn < ds)
	Vs = V;
	ds = dn;
      end
      
    end

  
  Temp = alpha*Temp;
  end

  fprintf('Observed minimum visiting order')
  disp(Vs)
  fprintf('At end, smallest observed travel distance = %f\n', ds)  
  fprintf('At end of annealing, optimized travel distance = %f\n', dn)

  
end
  