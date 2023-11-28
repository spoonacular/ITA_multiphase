function d = touchSolid(d)

TS_i = find(d.Pc_TS==min(d.Pc_TS));

v_target_ind = d.Pc_TS_ind(TS_i);

old_meniscus_ind = d.menisci_ind(TS_i,:);

new_meniscus_ind_1 = [old_meniscus_ind(1),v_target_ind];
new_meniscus_ind_2 = [v_target_ind,old_meniscus_ind(2)];

if d.Pc_burst(TS_i,3) == 1 % burst
    d.event_burst = [d.event_burst;v_target_ind,d.i];
else
    d.event_TS = [d.event_TS; v_target_ind,d.i];
end

if d.v_sub(v_target_ind) == 0 % dry, not outlet
    d.v_sub(v_target_ind)=1;% mark submerged
    d = removeMeniscus(d,old_meniscus_ind);
   
    d = addMeniscus(d,new_meniscus_ind_1);
    d = addMeniscus(d,new_meniscus_ind_2);
    
    d = checkTrapping(d,new_meniscus_ind_1);
    d = checkTrapping(d,new_meniscus_ind_2);
    
    d = checkOverlap(d,new_meniscus_ind_1);
    d = checkOverlap(d,new_meniscus_ind_2);

else % reach outlet
    d = removeMeniscus(d,old_meniscus_ind);
    d = addMeniscus(d,new_meniscus_ind_1);
    d = addMeniscus(d,new_meniscus_ind_2);
end