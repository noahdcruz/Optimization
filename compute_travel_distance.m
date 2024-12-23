function l = compute_travel_distance(C, V, T)

  l = 0;
  for i=1:length(C)
    j = get_idx(C, V{i});
    k = get_idx(C, V{i+1});
    l = l+T(j,k);
  end

end
