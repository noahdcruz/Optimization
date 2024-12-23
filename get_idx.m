function i = get_idx(C, n)    
  for j = 1:length(C)
    if (strcmp(n, C{j}))
      % Found it
      i = j;
      return
    end
  end
  % If we get here it's an error
  error('Did not find name %s in list of cities', n)
end

