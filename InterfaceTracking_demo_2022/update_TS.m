function d = update_TS(d)
%% step 1: select search box according to meniscus size
% box center
p1_ind = d.menisci_ind(end,1);
p2_ind = d.menisci_ind(end,2);
p1_xy = d.v(p1_ind,:);
p2_xy = d.v(p2_ind,:);
box_xy_c = (p1_xy+p2_xy)/2;

v_ind = [];
% box size - should be much larger than throat size, also larger than the maximum pore
% size
box_L = 5*d.L(end);

while isempty(v_ind)
    % box coords
    box_xy = [box_xy_c-box_L/2;...
              box_xy_c+[-box_L/2,box_L/2];...
              box_xy_c+box_L/2;...
              box_xy_c+[box_L/2,-box_L/2]];

    % get points within box
    v_b = double(d.v(:,1)>=box_xy(1,1)) +...
          double(d.v(:,1)<=box_xy(3,1)) +...
          double(d.v(:,2)>=box_xy(1,2)) +...
          double(d.v(:,2)<=box_xy(2,2));
    v_ind = find(v_b==4);
    v_ind(ismember(v_ind,find(d.v_sub==1))) = []; % remove submerged points
    v_ind(v_ind == p1_ind) = []; % remove submerged points
    v_ind(v_ind == p2_ind) = [];
    
    v_ind(ismember(v_ind,find(d.v_sub==3))) = []; % remove trapped points
    v_ind(ismember(v_ind,reshape(d.menisci_ind,[],1))) = []; % remove menisci points
    

    %% step 2: remove points: only look at points at front & behind near the meniscus
    %% step 2.1: get dry points that is behind invasion front
    angle_l = calAngleWith3Coords(d.v(v_ind,:),p2_xy,p1_xy);
    angle_r = calAngleWith3Coords(p1_xy,d.v(v_ind,:),p2_xy);

    if d.CA<=60;b_angle=45;elseif d.CA<=90;b_angle=30;elseif d.CA<=120;b_angle=15;else;b_angle=10;end
    v_ind_bhd = v_ind(double(angle_l<b_angle)+double(angle_r<b_angle)==2); % look backwards b_angle degree
    angle_bhd = calAngleWith3Coords(p1_xy,p2_xy,d.v(v_ind_bhd,:));

    %% step 2.2: get dry points that is in front of meniscus within the box
    v_angle = calAngleWith3Coords(p1_xy,p2_xy,d.v(v_ind,:));
    v_ind(v_angle>180) = [];
    v_angle(v_angle>180) = [];

    %% combine 2.1 & 2.2
    v_ind = [v_ind; v_ind_bhd];
    v_angle = [v_angle;angle_bhd];

    box_L = box_L * 2;
end

%% step 3: for all these points, choose the one that make largest angle: the angle made by p_left,p_dry,p_right
angle_TS = max(v_angle);
v_ind_TS = v_ind(v_angle==angle_TS);
if isempty(v_ind_TS)
    v_ind_TS = nan;
    Pc_TS = nan;
else
    v_ind_TS = v_ind_TS(1);

    if angle_TS > 180 % TS behind front
        if ismember(v_ind_TS,d.Pc_unpin_ind(end,:)) % pseudo-TS: actually unpin
            Pc_TS = nan;
        else
            Pc_TS = -inf; % value is increased to force execution: passive TS, must happen
        end
    elseif angle_TS > 90 % pre-burst TS
        if ismember(v_ind_TS,d.Pc_unpin_ind(end,:)) % pseudo-TS: actually unpin
            Pc_TS = nan;
        else
%             if d.Pc_burst(end,1:2) == 1 % if both unpin are post-burst
            if d.Pc_burst(end,~isnan(d.Pc_unpin(end,:))) % if the active unpin is post-burst
                d.Pc_unpin(end,:) = [nan nan];
            end
            [R,~] = fit_circle_through_3_points([p1_xy;p2_xy;d.v(v_ind_TS,:)]);
            Pc_TS = 1/R;
        end
    else % post-burst TS
        d.Pc_burst(end,3) = 1;
        valid_unpin_i = find(~isnan(d.Pc_unpin(end,:)));
        if ismember(0,d.Pc_burst(end,1:2)) % unpin has pre-burst & post-burst TS
            Pc_TS = nan;
        else % post-burst unpin & TS: choose largest P
            if ismember(v_ind_TS,d.Pc_unpin_ind(end,:)) % pseudo-TS: actually unpin
                Pc_TS = nan;
                d.Pc_unpin(end,valid_unpin_i) = 2/d.L(end);
            else 
                [R,~] = fit_circle_through_3_points([p1_xy;p2_xy;d.v(v_ind_TS,:)]);
                Pc_TS = 1/R;
                if d.Pc_unpin(end,valid_unpin_i) > Pc_TS
                    Pc_TS = nan;
                    d.Pc_unpin(end,valid_unpin_i) = 2/d.L(end);
                else
                    d.Pc_unpin(end,valid_unpin_i) = nan;
                    Pc_TS = 2/d.L(end);
                end
            end
        end
    end
end

%% step 4: write data
d.Pc_TS = [d.Pc_TS; Pc_TS];
d.Pc_TS_ind = [d.Pc_TS_ind; v_ind_TS];

