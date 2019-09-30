function [] = plot_single_cell_activity(start_tp,pd,col1,time,pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    rad=1;


    figure
    hold on
    subplot(4,3,1)
    hold on
    plot(time,pert8c,'Color',col1(8,:))
    
    subplot(4,3,2)
    hold on
    plot(time,pert7c,'Color',col1(7,:))
    
    subplot(4,3,3)
    hold on
    plot(time,pert6c,'Color',col1(6,:))
    
    
    subplot(4,3,4)
    hold on
    plot(time,pert1c,'Color',col1(1,:))
    
    subplot(4,3,6)
    hold on
    plot(time,pert5c,'Color',col1(5,:))
    
    subplot(4,3,7)
    hold on
    plot(time,pert2c,'Color',col1(2,:))
    
    subplot(4,3,8)
    hold on
    plot(time,pert3c,'Color',col1(3,:))

    subplot(4,3,9)
    hold on
    plot(time,pert4c,'Color',col1(4,:))
    
    hold on
    subplot(4,3,5)
    hold on

    plot([0,rad*cos((pd+180)*pi/180)],[0,rad*sin((pd+180)*pi/180)],'k')
    xlim([-1.5,1.5])
    ylim([-1.5,1.5])
    axis square
    

    
    
    %calculate the means
    pert1c=mean(pert1c(start_tp:start_tp+300));
    pert2c=mean(pert2c(start_tp:start_tp+300));
    pert3c=mean(pert3c(start_tp:start_tp+300));
    pert4c=mean(pert4c(start_tp:start_tp+300));
    
    pert5c=mean(pert5c(start_tp:start_tp+300));
    pert6c=mean(pert6c(start_tp:start_tp+300));
    pert7c=mean(pert7c(start_tp:start_tp+300));
    pert8c=mean(pert8c(start_tp:start_tp+300));
    
    array=[pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c];
    array=array-mean(array);
    
    subplot(4,3,10)
    hold on
    for i=1:8
        scatter(i,array(i),'MarkerEdgeColor',col1(i,:))
    end


    
    
end

