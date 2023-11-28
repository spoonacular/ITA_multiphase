function d = readPorousMediumSaman(file_name,CA)
load(file_name);

%% remove duplicated entries
for i = size(xy_all,1):-1:2
    if xy_all(i,:) == xy_all(i-1,:)
        xy_all(i,:) = [];
    end
end

%% connect boundary grains
x_bry = [0:NX,NX*ones(1,NY-1),NX:-1:0,zeros(1,NY-1)]';
y_bry = [zeros(1,NX),0:NY,NY*ones(1,NX-1),NY:-1:1,]';
xy_bry = [x_bry y_bry];

start_i_bry = find(isnan(xy_all(:,1)));
grain_i = 2; % starting from 2. reserve one for boundary
mesh_v = []; % [x, y, grain_ind, adj_v_ind_previous adj_v_ind_next]
for i = 1:length(start_i_bry)-1
    on_bry = 1; % assume on boundary
    xy_ = flip(xy_all(start_i_bry(i)+1:start_i_bry(i+1)-1,:));
    %scatter(xy_(:,1),xy_(:,2),'.r')
    
    if xy_(1,2) == 0 % on y=0
        if xy_(end,2) == 0 % both on y=0
            remove_ind = (xy_bry(:,2) == 0) + (xy_bry(:,1)<xy_(end,1)) + (xy_bry(:,1)>xy_(1,1))==3;
        else % on x = NX (corner grain)
            remove_ind = (xy_bry(:,1)>xy_(1,1)) + (xy_bry(:,2)<xy_(end,2)) ==2;
        end

    elseif xy_(1,1) == NX % on x=NX
        if xy_(end,1) == NX  % both on x=NX
            remove_ind = (xy_bry(:,1) == NX) + (xy_bry(:,2)<xy_(end,2)) + (xy_bry(:,2)>xy_(1,2))==3;
        else % on y = NY (corner grain)
            remove_ind = (xy_bry(:,1)>xy_(1,1)) + (xy_bry(:,2)>xy_(end,2)) == 2;
        end
        
    elseif xy_(1,2) == NY % on y=NY
        if xy_(end,2) == NY % both on y=NY
            remove_ind = (xy_bry(:,2) == NY) + (xy_bry(:,1)>xy_(end,1)) + (xy_bry(:,1)<xy_(1,1))==3;
        else % on x=0 (corner grain)
            remove_ind = (xy_bry(:,1)<xy_(1,1)) + (xy_bry(:,2)>xy_(end,2)) == 2;
        end
        
    elseif xy_(1,1) == 0 % on x=0
        if xy_(end,1) == 0 %both on x=0
            remove_ind = (xy_bry(:,1) == 0) + (xy_bry(:,2)>xy_(end,2)) + (xy_bry(:,2)<xy_(1,2))==3;
        else % on y=0 (corner grain)
            remove_ind = (xy_bry(:,2)<xy_(1,2)) + (xy_bry(:,1)<xy_(end,1)) == 2;
        end
    else % internal grain
        % smooth xy_; evenly space xy_
        xy_ = (xy_+[xy_(2:end,:);xy_(1,:)])/2;
        
        mesh_v = [mesh_v;flip(xy_), grain_i*ones(size(xy_,1),1)...
                  [mod(-1:size(xy_,1)-2,size(xy_,1))+1]'+size(mesh_v,1),[mod(1:size(xy_,1),size(xy_,1))+1]'+size(mesh_v,1)];
        grain_i = grain_i+1;
        on_bry = 0;
    end
    
    if on_bry == 1
        xy_bry(remove_ind,:) = [];
        xy_bry = [xy_bry(1:find(remove_ind,1)-1,:);xy_;xy_bry(find(remove_ind,1):end,:)];
    end
end
xy_ = xy_bry;
% smooth xy_; evenly space xy_
xy_ = (xy_+[xy_(2:end,:);xy_(1,:)])/2;
    
mesh_v = [flip(xy_), ones(size(xy_,1),1)...
          [mod(-1:size(xy_,1)-2,size(xy_,1))+1]',[mod(1:size(xy_,1),size(xy_,1))+1]';...
          mesh_v+[0 0 0 size(xy_,1) size(xy_,1)]];

      
%% create data structure
corner_angle = nan(size(mesh_v,1),1);
for i = 1:size(mesh_v,1)
    p1 = mesh_v(mesh_v(i,4),1:2);
    p2 = mesh_v(mesh_v(i,5),1:2);
    pc = mesh_v(i,1:2);
    corner_angle(i) = calAngleWith3Coords(p2,p1,pc);
end

d = struct();
d.v = mesh_v(:,1:2); % vertice index
d.g_ind = mesh_v(:,3); % grain index
d.v_adj_ind = mesh_v(:,4:5); % adjacent vertice index (forward, backward)
d.corner_angle = corner_angle; % local grain corner angle
d.CA = CA; % intrinsic contact angle
d.crit_angle = CA + 180 - corner_angle; % critical unpin angle

d.mesh_size = 1; 

