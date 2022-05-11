function [d] = checkTrapping(d,meniscus_ind)

%% go from left triple point
% along dry surface & jump through meniscus

next_p_ind = meniscus_ind(1);
v_series = [];

while ~ismember(meniscus_ind(2),v_series) && ~sum(ismember(find(d.v_sub==2),v_series))
    % while not return to rigth point of menniscus, and not reaching outlet
    v_series = [v_series next_p_ind];
    
    move_ind = d.v_adj_ind(next_p_ind,2);
    jump_ind = d.menisci_ind(next_p_ind==d.menisci_ind(:,2),1);
    
    if ismember(next_p_ind,d.menisci_ind(:,2))% reach meniscus - right
        if ismember(next_p_ind,d.menisci_ind(:,1))% reach meniscus - left
            if ~ismember(move_ind,v_series) % new update
                next_p_ind = move_ind;
            else
                 next_p_ind = jump_ind;
            end
        else
            next_p_ind = jump_ind;
        end
    else
        next_p_ind = move_ind;
    end
end

%% determine trapping: if reach right triple point: trapped; elseif reach outlet: not trapped
i_c = sum(meniscus_ind == d.menisci_ind,2)==2;
if ismember(meniscus_ind(2),v_series)
    xy_ = d.v(v_series,:);
    if ispolycw(xy_(:,1),xy_(:,2))
        % mark trapped region - excluding meniscus points
        d.v_sub(v_series(2:end-1)) = 3;
        % adjust current meniscus shape for equilibrium: only unpin events
        % (forward/backward movement)
        if d.L(i_c) > 3*d.mesh_size
            if ~isnan(d.Pc_unpin(i_c,1)) && sum(d.menisci_ind(i_c,1)==d.menisci_ind,'all')==2 && sum(d.menisci_ind(i_c,2)==d.menisci_ind,'all')==1% left forward; right backward; left is TS target point
                while isnan(d.Pc_unpin(i_c,2)) &&...
                        ~ismember(d.v_adj_ind(d.menisci_ind(i_c,1),2),d.menisci_ind) &&...
                        ~ismember(d.v_adj_ind(d.menisci_ind(i_c,2),2),d.menisci_ind)
                    % update vertice status
                    d.v_sub(d.menisci_ind(i_c,1)) = 1;
                    d.v_sub(d.menisci_ind(i_c,2)) = 3;
                    d.v_sub(d.v_adj_ind(d.menisci_ind(i_c,1),2)) = 3;
                    d.v_sub(d.v_adj_ind(d.menisci_ind(i_c,2),2)) = 3;
                    % update triple point location
                    d.menisci_ind(i_c,1) = d.v_adj_ind(d.menisci_ind(i_c,1),2);
                    d.menisci_ind(i_c,2) = d.v_adj_ind(d.menisci_ind(i_c,2),2);
                    % update length, and unpin
                    d.L(i_c) = norm(d.v(d.menisci_ind(i_c,1),:)-d.v(d.menisci_ind(i_c,2),:));
                    d = update_unpin(d,i_c);
                end
%             elseif isnan(d.Pc_unpin(i_c,1)) && ~isnan(d.Pc_unpin(i_c,2)) % left backward; right forward; right is TS target point
            elseif ~isnan(d.Pc_unpin(i_c,2)) && sum(d.menisci_ind(i_c,2)==d.menisci_ind,'all')==2 && sum(d.menisci_ind(i_c,1)==d.menisci_ind,'all')==1% right forward; right is TS target point
                while isnan(d.Pc_unpin(i_c,1)) &&...
                        ~ismember(d.v_adj_ind(d.menisci_ind(i_c,1),1),d.menisci_ind) &&...
                        ~ismember(d.v_adj_ind(d.menisci_ind(i_c,2),1),d.menisci_ind)
                    % update vertice status
                    d.v_sub(d.menisci_ind(i_c,2)) = 1;
                    d.v_sub(d.menisci_ind(i_c,1)) = 3;
                    d.v_sub(d.v_adj_ind(d.menisci_ind(i_c,1),1)) = 3;
                    d.v_sub(d.v_adj_ind(d.menisci_ind(i_c,2),1)) = 3;
                    % update triple point location
                    d.menisci_ind(i_c,1) = d.v_adj_ind(d.menisci_ind(i_c,1),1);
                    d.menisci_ind(i_c,2) = d.v_adj_ind(d.menisci_ind(i_c,2),1);
                    % update length, and unpin
                    d.L(i_c) = norm(d.v(d.menisci_ind(i_c,1),:)-d.v(d.menisci_ind(i_c,2),:));
                    d = update_unpin(d,i_c);
                end
            end
        end
        % diactivate the currennt meniscus
        d.Pc_TS(i_c) = nan;
        d.Pc_unpin(i_c,:) = nan;
        d.menisci_trapped(i_c) = 1;
        d.menisci_trapped_P(i_c) = d.P_hist(end);       % Pc history; % record pressure at trapping

        % diactivate all menisci along v_series
        i = sum(ismember(d.menisci_ind,v_series),2)==2;
        d.Pc_TS(i) = nan;
        d.Pc_unpin(i,:) = nan;
        d.menisci_trapped(i) = 1;
        d.menisci_trapped_P(i) = d.P_hist(end);% recard pressure at trapping
    end
    
elseif sum(ismember(find(d.v_sub==2),v_series)) % reach outlet
    % disp('not trapped');
    %% activate the currennt meniscus
        if d.menisci_trapped(i_c)==1
            meniscus_to_activate = d.menisci_ind(i_c,:);
            d = removeMeniscus(d,meniscus_to_activate);
            d = addMeniscus(d,meniscus_to_activate);
        end
end
