function d = initialMenisci(d,direction,x1,x2)

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
% d.event_burst = 0;
% d.event_TS = 0;
% d.event_overlap = 0;
d.event_burst = []; 
d.event_TS = [];
d.event_overlap = [];

if direction == "x"
    % not checked
    d.v_sub(d.v(:,1)<x1)=1;
    d.v_sub(d.v(:,1)>x2)=2;
    
    left_ind = find(d.v_sub==1,1,'last');
    right_ind = find(d.v_sub==1,1);
    
    d = addMeniscus(d,[left_ind,right_ind]);
    
elseif direction == "y"
    % label vertice status
    d.v_sub(d.v(:,2)<x1)=1; % inlet (zero for dry)
    
    if length(x2) == 1
        d.v_sub(d.v(:,2)>x2)=2; % outlet
    elseif length(x2) == 3
        % left right top
        d.v_sub(d.v(:,1)<x2(1))=2;
        d.v_sub(d.v(:,1)>x2(2))=2;
        d.v_sub(d.v(:,2)>x2(3))=2;
    end
        
    % create initial meniscus, & calculate critical Pc at the same time
    sub_ind = find(d.v_sub==1);
    left_ind = sub_ind(d.v(sub_ind,1)==min(d.v(sub_ind,1)));
    left_ind = left_ind(d.v(left_ind,2) == max(d.v(left_ind,2)));
    
    right_ind = sub_ind(d.v(sub_ind,1)==max(d.v(sub_ind,1)));
    right_ind = right_ind(d.v(right_ind,2) == max(d.v(right_ind,2))); 

    if left_ind > right_ind
        d.v_sub(right_ind:left_ind) = 1;
    else
        d.v_sub(right_ind:sum(d.g_ind==1)) = 1;
        d.v_sub(1:left_ind) = 1;
    end
    while d.v_sub(d.v_adj_ind(left_ind,2)) == 1
        left_ind = d.v_adj_ind(left_ind,2);
    end
	while d.v_sub(d.v_adj_ind(right_ind,1)) == 1
        right_ind = d.v_adj_ind(right_ind,1);
    end
    
    d = addMeniscus(d,[left_ind,right_ind]);
else
    erorr('enter "x" or "y"');
end
    
    