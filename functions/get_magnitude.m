function [outputArg1,outputArg2] = get_magnitude(data,ind_sign)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        %get neuron data as an array CxNxT where N is neuron number and T is number
    %of time points
    [contra_data,ipsi_data] = get_neuron_data_pert_epoch(data,1);
    
    %average across time points
    offset=201;
    pert_start=0+offset;
    pert_end=300+offset;
    contra_data=squeeze(mean(contra_data(:,:,pert_start:pert_end),3)).'; %NxC
    ipsi_data  =squeeze(mean(ipsi_data(:,:,pert_start:pert_end),3)).';   %NxC


    % [pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
    %     ,pert4i,pert5i,pert6i,pert7i,pert8i ] = get_neuron_data_tuned( convolved_H );

    %total number of neurons
    numb_neuron=size(contra_data,1);

    %get neurons that are tuned for ipsi and contra
    [ind_contr,pd_contra,mag_contra]=get_tuned_neurons_input_matrix( contra_data );
    [ind_ipsi, pd_ipsi,  mag_ipsi]  =get_tuned_neurons_input_matrix( ipsi_data );
    
    %get neuron classifications of interest
    ind_contr=intersect(ind_contr,ind_sign);
    ind_ipsi=intersect(ind_ipsi,ind_sign);
    ind_comb=intersect(ind_contr,ind_ipsi);
    ind_resp=ind_sign;
    
    
    
    %plot polar histograms showing the tuning distribution in joint torque
    %space
    rad=30;
    figure
    hold on
    subplot(2,3,1)
    hold on
    %plot polar histograms
    [r_contra_resp,theta_contra_resp]=plot_polar_histogram_pd(pd_contra(ind_resp),'k');
    %plot major axis of the bimodal distribution
    plot([0,rad*cos(theta_contra_resp*pi/180)],[0,rad*sin(theta_contra_resp*pi/180)],'k')
    plot([0,rad*cos((theta_contra_resp+180)*pi/180)],[0,rad*sin((theta_contra_resp+180)*pi/180)],'k')
    title(strcat('Angle:',num2str(theta_contra_resp)))

    subplot(2,3,2)
    hold on
    %plot polar histogram
    [r_ipsi_resp,theta_ipsi_resp]=plot_polar_histogram_pd(pd_ipsi(ind_resp),'k');
    %plot major axis of the bimodal distribution
    plot([0,rad*cos(theta_ipsi_resp*pi/180)],[0,rad*sin(theta_ipsi_resp*pi/180)],'k')
    plot([0,rad*cos((theta_ipsi_resp+180)*pi/180)],[0,rad*sin((theta_ipsi_resp+180)*pi/180)],'k')
    title(strcat('Angle: black:',num2str(theta_ipsi_resp)))

    
    %calculate the change in tuning 
    diff_tuning=pd_contra-pd_ipsi;
    for i=1:length(diff_tuning)
        if abs(diff_tuning(i))>360
            diff_tuning(i)=mod(diff_tuning(i),360);
        end
    end


    %plot polar histogram for change in tuning
    subplot(2,3,3)
    hold on
    [r_diff_resp,theta_diff_resp]=plot_polar_histogram_pd_diff(diff_tuning(ind_resp),'k');
    plot([0,rad*cos(theta_diff_resp*pi/180)],[0,rad*sin(theta_diff_resp*pi/180)],'k')
    title(strcat('Angle: black:',num2str(theta_diff_resp)))

    %plotting management
    for i=1:3
        subplot(2,3,i)
        xlim([-32,32])
        ylim([-32,32])
        axis square
    end
end

