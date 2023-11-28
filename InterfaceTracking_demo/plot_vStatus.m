function plot_vStatus(d)

wet_ind = d.v_sub == 1; % wetted vertices
outlet_ind = d.v_sub == 2; % outlet vertices
trapped_ind = d.v_sub == 3; % trapped vertices

scatter(d.v(:,1),d.v(:,2),50,0.6*[1 1 1],'.');
scatter(d.v(wet_ind,1),d.v(wet_ind,2),'.b');

scatter(d.v(trapped_ind,1),d.v(trapped_ind,2),'.k');
scatter(d.v(outlet_ind,1),d.v(outlet_ind,2),50,'or','filled');
