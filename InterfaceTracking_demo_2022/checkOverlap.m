function d = checkOverlap(d,meniscus_ind)
% overlap into touch solid not considered here, but considered in update_TS

[l_i,~] = find(meniscus_ind(1)==d.menisci_ind(:,2));
[r_i,~] = find(meniscus_ind(2)==d.menisci_ind(:,1));

if ~isempty(l_i) % check overlap of left triple point
    old_menisci_ind1 = d.menisci_ind(l_i(1),:);
    old_menisci_ind2 = meniscus_ind;
    delete_point_ind = old_menisci_ind2(1);
    new_menisci_ind = [old_menisci_ind1(1) old_menisci_ind2(2)];
    
    if    d.v_sub(d.v_adj_ind(new_menisci_ind(1),2)) ~= 3 && d.v_sub(d.v_adj_ind(new_menisci_ind(2),1)) ~= 3 && ...
        (d.v_sub(d.v_adj_ind(delete_point_ind,1)) ~= 0 || d.v_sub(d.v_adj_ind(delete_point_ind,2)) ~= 0)
        % merge if the new meniscus (left and right points) is not trapped
        left_moved = 1;
        d = removeMeniscus(d,old_menisci_ind2);
        d = removeMeniscus(d,old_menisci_ind1);
        d.v_sub(delete_point_ind) = 1;
        d = addMeniscus(d,new_menisci_ind);
        d.event_overlap = [d.event_overlap;delete_point_ind,d.i];
    end
end

if ~isempty(r_i) && ~exist('left_moved','var') % check overlap of right triple point       
    old_menisci_ind1 = meniscus_ind;
    old_menisci_ind2 = d.menisci_ind(r_i(1),:);
    delete_point_ind = old_menisci_ind2(1);
    new_menisci_ind = [old_menisci_ind1(1) old_menisci_ind2(2)];
    
    if    d.v_sub(d.v_adj_ind(new_menisci_ind(1),2)) ~= 3 && d.v_sub(d.v_adj_ind(new_menisci_ind(2),1)) ~= 3 && ...
        (d.v_sub(d.v_adj_ind(delete_point_ind,1)) ~= 0 || d.v_sub(d.v_adj_ind(delete_point_ind,2)) ~= 0)
        d = removeMeniscus(d,old_menisci_ind1);
        d = removeMeniscus(d,old_menisci_ind2);
        d.v_sub(delete_point_ind) = 1;
        d = addMeniscus(d,new_menisci_ind);
        d.event_overlap = [d.event_overlap;delete_point_ind,d.i];
    end
end