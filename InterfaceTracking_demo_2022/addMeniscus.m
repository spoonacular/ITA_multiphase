function d = addMeniscus(d,meniscus_ind)

    %% add meniscus index
    d.menisci_ind = [d.menisci_ind;meniscus_ind];
    d.menisci_trapped = [d.menisci_trapped;0];
    d.menisci_trapped_P = [d.menisci_trapped_P; nan]; % pressure at trapping; (n by 1);
    
    %% add throat size
    L_ = norm(d.v(meniscus_ind(1),:)-d.v(meniscus_ind(2),:));
    d.L = [d.L;L_];

    %% assume burst case happens
    d.Pc_burst = [d.Pc_burst;0 0 0];  % unpin left, unpin right, TS. assume pre-burst

    %% update critical unpin pressure
    d = update_unpin(d);

    %% update critical touch solid pressure
    d = update_TS(d);
% end