figure
plot(active_results(:,1), active_results(:, 5), 'rx')
title('time of input AP vs Can diameter')
ylabel('time of input AP (ms)')
xlabel('Can Diameter (um)')

figure
plot(active_results(:,2), active_results(:, 5), 'rx')
title('time of input AP vs channel strength')
ylabel('time of input AP (ms)')
xlabel('channel strength (1)')

figure
plot(active_results(:,3), active_results(:, 5), 'rx')
title('time of input AP vs axon diameter')
ylabel('time of input AP (ms)')
xlabel('Axon Diameter (um)')

figure
plot(active_results(:,1), active_results(:, 4), 'rx')
title('number of output APs vs Can diameter')
ylabel('number of output AP (ms)')
xlabel('Can Diameter (um)')

figure
plot(active_results(:,2), active_results(:, 4), 'rx')
title('number of output APs vs channel strength')
ylabel('number of output AP (ms)')
xlabel('Channel strength (1)')

figure
plot(active_results(:,3), active_results(:, 4), 'rx')
title('number of output APs vs Axon diameter')
ylabel('number of output AP (ms)')
xlabel('Axon Diameter (um)')

