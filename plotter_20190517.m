close all;
%
% Figure 2(a)
figure(1);

% hold on, plot(lle_initial_1km(:,2), lle_initial_1km(:,3),'.k', 'MarkerSize', 0.5);
hold on, a1 = plot(ATD_km, ele_km, '.k', 'MarkerSize', 4.5);
set(gca,'FontSize',18);

xlim([0 1000]);
ylim([-200 1400]);

xlabel('Distance Along Track (m)','FontSize', 18);
ylabel('Elevation (m)','FontSize', 18);
title('Raw Data','FontSize', 20);
box on;
% position_2a = get(gcf,'position'); % 2018-12-21
% set(gcf, 'position', position_2a); % 2018-12-21
%}

