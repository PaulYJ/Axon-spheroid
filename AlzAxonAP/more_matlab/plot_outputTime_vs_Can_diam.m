% load active_results.mat
figure
plot(active_results(:,1), active_results(:, 6), 'rx')
title('time of output AP vs Can diameter')
ylabel('time of output AP (ms)')
xlabel('Can Diameter (um)')