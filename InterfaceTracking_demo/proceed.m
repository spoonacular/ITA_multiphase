function d = proceed(d)
d.i = d.i+1;

min_Pc_TS = min(d.Pc_TS);
min_Pc_unpin = min(d.Pc_unpin,[],'all');
d.P_hist = [d.P_hist;min([min_Pc_TS,min_Pc_unpin])];

if min_Pc_TS < min_Pc_unpin || isnan(min_Pc_unpin)
    % execude touch solid
    d = touchSolid(d);
else 
    % execude unpin
    d = unpin(d);
end

if d.i>1 && d.P_hist(d.i-1) == -inf % update passive touch solid pressure
    d.P_hist(d.i-1) = d.P_hist(d.i);
end