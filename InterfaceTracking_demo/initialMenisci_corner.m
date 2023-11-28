function d = initialMenisci_corner(d,CA)
% this is for flow direction: from bottom-right to top-left

d.CA = CA;
d.crit_angle = CA + 180 - d.corner_angle;
d.v_sub = zeros(size(d.v,1),1);
d.menisci_ind = [];  % meniscus index (n by 1)
d.menisci_trapped = [];  % meniscus status (n by 1)
d.menisci_trapped_P = []; % pressure at trapping; (n by 1);
d.Pc_unpin = [];     % unpin pressure (n by 2) at left and right triple point
d.Pc_unpin_ind = []; % unpin index (n by 2) at left and right triple point
d.Pc_TS = [];        % touch solid pressure (n by 1)
d.Pc_TS_ind = [];    % touch solid index (n by 1)
d.Pc_burst = [];     % whether unpin or TS takes place after burst pressure
d.L = [];            % throat size (n by 1)
d.i = 0;             % iteration
d.P_hist = [];       % Pc history

d.event_burst = [];  % record burst event
d.event_TS = [];     % record touch solid event
d.event_overlap = [];% record overlap event

%% select corner mesh points
    loc_ = d.v(:,1)-d.v(:,2);
    ind_in = find(loc_==max(loc_));
    ind_out = ismember(loc_,mink(loc_,2));
    ind_in = ind_in(1);
    
    % label vertice status
    d.v_sub(ind_in)=1; % inlet (zero for dry)
    d.v_sub(ind_in+1)=1;
    d.v_sub(ind_out) = 2;% outlet

    % create initial meniscus, & calculate critical Pc at the same time
    left_ind = ind_in+2;
    right_ind = ind_in;
    
    d = addMeniscus(d,[left_ind,right_ind]);

end
    
    