clear all;

%% input
plot_interval = 100; % plotting interval
CA = 45; % contact angle

%% initialization - read porous media and initialize menisci
% option 1: porous media directly from an image
mesh_size = 8; 
file_name = "porousMedia/Ju2020_berea_sandstone.png";
d = readPorousMedium(file_name,mesh_size,CA);
d = initialMenisci(d,"y",30,1100); % Ju2020

% option 2: porous media with solid surface represented by coordinates
% d = readPorousMediumSaman("porousMedia/Saman_PM_1.mat",CA);
% d = initialMenisci_corner(d,CA); 

% option 3: create your own methods of reading the porous media

%% main loop
figure('color','white','position',[300,50,600,500]);
while ~sum(ismember(d.Pc_unpin_ind,find(d.v_sub==2)),'all')
    d = proceed(d);
    if d.i == 1 || mod(d.i,plot_interval)==0 || sum(ismember(d.Pc_unpin_ind,find(d.v_sub==2)),'all')
        fprintf('i = %d\n',d.i);clf;
        plot_invasionStatus(d);axis off;
        title(sprintf("$\\theta_0 = %.1f^\\circ$, iT=%d",CA,d.i),'interpreter','latex','fontsize',16);
        drawnow;
    end
end