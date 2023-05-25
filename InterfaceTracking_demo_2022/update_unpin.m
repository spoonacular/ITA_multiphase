function d = update_unpin(d,varargin)
if length(varargin)==1
    m_i = cell2mat(varargin(1));
    m_ind = d.menisci_ind(m_i,:);
    L_ = d.L(m_i);
else
    m_ind = d.menisci_ind(end,:);
    L_ = d.L(end);
end

%% left - find points
p_l = d.v(m_ind(1),:);
p_l_fwd_ind = d.v_adj_ind(m_ind(1),2);
p_l_bhd = d.v(d.v_adj_ind(m_ind(1),1),:);

%% right - find points
p_r = d.v(m_ind(2),:);
p_r_fwd_ind = d.v_adj_ind(m_ind(2),1);
p_r_bhd = d.v(d.v_adj_ind(m_ind(2),2),:);

%% left - calculation
angle_l = calAngleWith3Coords(p_l_bhd,p_r,p_l); % angle made by point behind, and right point, at left point
beta_l = 90 + angle_l - d.crit_angle(m_ind(1)); % the angle within the triangle
Pc_l = 2*cosd(beta_l)/L_;
angle_excessCritAngle_l = d.crit_angle(m_ind(1))-angle_l;
    
%% choose one critical unpin
% pre-burst unpin: choose smaller Pc
% post-burst unpin: choose greater Pc
if angle_excessCritAngle_l < 0 && -angle_excessCritAngle_l < 180 % neg P
    beta_l = 90 + d.crit_angle(m_ind(1)) - angle_l;
    Pc_l = - 2*cosd(beta_l)/L_;
    if angle_l > 270 % positive P - post-burst
        d.Pc_burst(end,1) = 1;
    end
else
    if mod(angle_excessCritAngle_l,360)>90 % post-burst
        d.Pc_burst(end,1) = 1;
    end
end

% keep one value
if angle_excessCritAngle_l < -180
    angle_excessCritAngle_l = 360 + angle_excessCritAngle_l;
end

%% right - calculation
angle_r = calAngleWith3Coords(p_l,p_r_bhd,p_r); % angle made by left point, and point behind, at right point
beta_r = 90 + angle_r - d.crit_angle(m_ind(2));
Pc_r = 2*cosd(beta_r)/L_;
angle_excessCritAngle_r = d.crit_angle(m_ind(2))-angle_r;

% choose one critical unpin
if angle_excessCritAngle_r < 0 && -angle_excessCritAngle_r < 180 % neg P
    beta_r = 90 + d.crit_angle(m_ind(2)) - angle_r;
    Pc_r = - 2*cosd(beta_r)/L_;
else
    if mod(angle_excessCritAngle_r,360)>90 % post-burst
        d.Pc_burst(end,2) = 1;
    end
end

% keep one value 
if angle_excessCritAngle_r < -180
    angle_excessCritAngle_r = 360 + angle_excessCritAngle_r;
end    

if angle_excessCritAngle_l < angle_excessCritAngle_r
    Pc_r = nan;
else
    Pc_l = nan;
end

%% write
if length(varargin)==1
    d.Pc_unpin(m_i,:) = [Pc_l Pc_r];
    d.Pc_unpin_ind(m_i,:) = [p_l_fwd_ind p_r_fwd_ind];
else
    d.Pc_unpin = [d.Pc_unpin; Pc_l Pc_r];
    d.Pc_unpin_ind = [d.Pc_unpin_ind; p_l_fwd_ind p_r_fwd_ind];
end
