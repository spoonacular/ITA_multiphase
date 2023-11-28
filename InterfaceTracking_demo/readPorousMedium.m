function d = readPorousMedium(file_name,mesh_size,CA)
    I_raw = imread(file_name);
    if length(size(I_raw)) == 3 % color picture
        I = imbinarize(rgb2gray(I_raw));
    else % gray or binanry
        if max(max(I_raw)) == 1 % binary
            I = I_raw;
        else
            I = imbinarize(I_raw);
        end
    end
    I_label = bwlabel(I);

    edges_raw_map = struct();
    edges_raw = struct();
    edges_mesh = struct();
    mesh_v = [];

    for i = 1:max(I_label,[],'all')
        %% edge bw map
        edge_ = edge(I_label==i);
        edge_sum = conv2(edge_,[0 1 0;1 1 1;0 1 0],'same');
        edge_(edge_sum==4) = 0;
        edges_raw_map.(sprintf("g%.0f",i)) = edge_;

        %% edge [x, y] coords
        [x,y] = find(edges_raw_map.(sprintf("g%.0f",i))==1);
        [sorted,~,cut_]=sortsnake([x,y],[x(1) y(1)]);
        x = sorted(cut_,1); y = sorted(cut_,2);
        edges_raw.(sprintf("g%.0f",i)) = sorted(cut_,:);

        
        %% mesh edge (averaging)
        x_m = [];y_m = [];
        for j = 1:mesh_size:length(x)
            x_m = [x_m;mean(x(j:min(j+mesh_size,length(x))))];
            y_m = [y_m;mean(y(j:min(j+mesh_size,length(x))))];
        end

        sorted_xym = makeSnakeCounterClockwise([x_m, y_m]);
        if i == 1 % clockwise for the surrounding grain
            sorted_xym = flip(sorted_xym);
        end
        x_m = sorted_xym(:,1); y_m = sorted_xym(:,2);
        edges_mesh.(sprintf("g%.0f",i)) = [x_m, y_m];
        mesh_v = [mesh_v;x_m,y_m,i*ones(length(x_m),1), [mod(-1:length(x_m)-2,length(x_m))+1]'+size(mesh_v,1),[mod(1:length(x_m),length(x_m))+1]'+size(mesh_v,1)];

    end

    %% calculate corner angle
    corner_angle = nan(size(mesh_v,1),1);
    for i = 1:size(mesh_v,1)
        p1 = mesh_v(mesh_v(i,4),1:2);
        p2 = mesh_v(mesh_v(i,5),1:2);
        pc = mesh_v(i,1:2);

        corner_angle(i) = calAngleWith3Coords(p2,p1,pc);

    end
    
    %% output geometry
    d = struct();
    d.v = mesh_v(:,1:2);
    d.g_ind = mesh_v(:,3);
    d.v_adj_ind = mesh_v(:,4:5);
    d.corner_angle = corner_angle;
    d.CA = CA;
    d.crit_angle = CA + 180 - corner_angle;
    d.mesh_size = mesh_size;
