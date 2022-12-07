% APoutput.m
% displays the number of spikes per Can Diam size and intrinsic strength
CanDiams=unique(results(:,1));
Strengths=unique(results(:,2));
AxonDiams=unique(results(:,3))';
num_of_APs=zeros( length(Strengths), length(CanDiams));
num_of_APs_cell={};
for x_index=1:length(CanDiams)
    for y_index=1:length(Strengths)
        for z_index=1:length(AxonDiams)
            for sim=1:length(results)
                if (results(sim,1)==CanDiams(x_index)) && (results(sim,2)==Strengths(y_index)) && (results(sim,3)==AxonDiams(z_index))
                num_of_APs_cell{z_index}( y_index, x_index)=results(sim, 4);
                break;
                end
            end
        end
    end
end

APs_fig=figure;
for z_index=1:length(AxonDiams)
    subplot(length(AxonDiams),1, z_index)
    colormap('hot')
    hold on
    imagesc(num_of_APs_cell{z_index})
    title(['Number of axon output APs vs channel density (y) and Can diameter (um) for axon diameter ' num2str(AxonDiams(z_index)) ' microns']);
    colorbar
    strength_index=1:floor(length(Strengths)/4):length(Strengths);
    ax=gca;
    ax.YTick=strength_index;
    ax.YTickLabel=Strengths(strength_index);
    diam_index=1:floor(length(CanDiams)/4):length(CanDiams); % [5:5:40];
    ax.XTick=diam_index;
    ax.XTickLabel=CanDiams(diam_index);

    ylabel('Intrinsic channel strength')
    xlabel('Diameter (microns) of dystrophic 5 um length "Can" connected to 1 um diam, 5um length stick')

end
figure
X=results(:,1);
Y=results(:,2);
Z=results(:,3);
c=results(:,4);
colormap('hot')
scatter3(X, Y, Z, c/10+1, c)
xlabel('Can diam')
ylabel('Intrinsic channel strength')
zlabel('Axon diam')
title('Number of output APs')
colorbar
