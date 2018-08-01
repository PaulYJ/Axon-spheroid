%% APoutput.m
CanDiams=unique(results(:,1));
Strengths=unique(results(:,2));
AxonDiams=unique(results(:,3));
num_of_APs=zeros(length(Strengths), length(CanDiams));
delay_cell={};
num_of_APs_cell={};

%calculating the delay
for sim=1:length (results)
    if (results(sim,4)==0) results(sim,7)=-10;
    else results(sim,7)=results(sim,6)-results(sim,5);
    end
end

%rearrange for plot
for x_index=1:length(CanDiams)
    for y_index=1:length(Strengths)
        for z_index=1:length(AxonDiams)
            for sim=1:length(results)
                if (results(sim,1)==CanDiams(x_index)) && (results(sim,2)==Strengths(y_index)) && (results(sim,3)==AxonDiams(z_index))
                num_of_APs_cell{z_index}(y_index, x_index)=results(sim, 4);
                delay_cell{z_index}(y_index,x_index)=results(sim,7);
                break;
                end
            end
        end
    end
end

%%
width=0.5;
%change the number here to 
figure,h=bar3(flipud(num_of_APs_cell{1,1}(1:7,1:41)),width); zlim([0,20]); axis off; alpha(0.75);
view(18,28);

colormap(mycmap);
caxis([-2,150]);
hold on
figure,g=bar3(flipud(delay_cell{1,1}(1:7,1:41)));
hold off


for i = 1:length(h)
    
     zdata = get(g(i),'Zdata');
     set(h(i),'Cdata',zdata);
     set(h(i),'EdgeColor','k')
end

