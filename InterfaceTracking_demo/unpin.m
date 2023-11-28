function d = unpin(d)

[i,l_or_r] = find(d.Pc_unpin==min(d.Pc_unpin,[],'all'));
if length(i) > 1 % identical unpin pressure by accident
    i = i(1);
    l_or_r= l_or_r(1);
end

v_static_ind = d.menisci_ind(i,3-l_or_r);
v_move_ind =  d.menisci_ind(i,l_or_r);
v_target_ind = d.Pc_unpin_ind(i,l_or_r);

old_meniscus_ind = d.menisci_ind(i,:);
if l_or_r == 1 % left
    new_meniscus_ind = [v_target_ind,v_static_ind];
else
    new_meniscus_ind = [v_static_ind,v_target_ind];
end

d.v_sub(v_move_ind)=1;% mark submerged

d = removeMeniscus(d,old_meniscus_ind);

if new_meniscus_ind(1) ~= new_meniscus_ind(2) % equality means collapse of meniscus of adjacent points onto a grain 
    d = addMeniscus(d,new_meniscus_ind);
    d = checkOverlap(d,new_meniscus_ind);
else
    d.v_sub(new_meniscus_ind(1))=1;
end

