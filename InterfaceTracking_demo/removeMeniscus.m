function d = removeMeniscus(d,meniscus_ind)

rm_i = find(sum(d.menisci_ind==meniscus_ind,2)==2);

d.menisci_ind(rm_i,:) = [];
d.menisci_trapped(rm_i,:) = [];
d.menisci_trapped_P(rm_i,:) = [];
d.Pc_unpin(rm_i,:) = [];
d.Pc_unpin_ind(rm_i,:) = [];
d.Pc_TS(rm_i,:) = [];
d.Pc_TS_ind(rm_i,:) = [];
d.Pc_burst(rm_i,:) = [];
d.L(rm_i,:) = [];

