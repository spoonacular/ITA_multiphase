function plot_invasionStatus(d)

%% plot grain boundary
for i = 1:max(d.g_ind)
    ind_ = d.g_ind == i;
    if i == 1
        x_low = floor(min(d.v(:,1))/100)*100;
        x_high = ceil(max(d.v(:,1))/100)*100;
        y_low = floor(min(d.v(:,2))/100)*100;
        y_high = ceil(max(d.v(:,2))/100)*100;
        fill([x_low x_high x_high x_low],[y_low y_low y_high y_high],'-k','FaceColor',0.7*[1 1 1]);hold on
        fill(d.v(ind_,1),d.v(ind_,2),'-k','FaceColor',[1 1 1]);hold on
    else
        fill(d.v(ind_,1),d.v(ind_,2),'-k','FaceColor',0.7*[1 1 1],'LineStyle','none');hold on
    end
end

%% plot vertice status
plot_vStatus(d)

%% plot meniscus
plot_meniscus(d,d.menisci_ind);
