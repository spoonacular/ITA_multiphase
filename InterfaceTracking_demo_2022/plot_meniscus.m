function plot_meniscus(d,N)
 lw = 1.5; % line width
%lw = 2;
%% straight menisci
if size(N,2) == 1
    x_ind = d.menisci_ind(N,1);
    y_ind = d.menisci_ind(N,2);
elseif size(N,2) == 2
    x_ind = N(:,1);
    y_ind = N(:,2);
end

plot([d.v(x_ind(d.menisci_trapped==1),1) d.v(y_ind(d.menisci_trapped==1),1)]',[d.v(x_ind(d.menisci_trapped==1),2) d.v(y_ind(d.menisci_trapped==1),2)]','-k','LineWidth',lw);
plot([d.v(x_ind(d.menisci_trapped==0),1) d.v(y_ind(d.menisci_trapped==0),1)]',[d.v(x_ind(d.menisci_trapped==0),2) d.v(y_ind(d.menisci_trapped==0),2)]','-b','LineWidth',lw);


