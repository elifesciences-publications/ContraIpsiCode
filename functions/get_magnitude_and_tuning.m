function [indices,mag_struct] = get_magnitude_and_tuning(data,ind_sign)
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

    %get neurons that are tuned for ipsi and contra
    [ind_contr,pd_contra,mag_contra]=get_tuned_neurons_input_matrix( contra_data );
    [ind_ipsi, pd_ipsi,  mag_ipsi]  =get_tuned_neurons_input_matrix( ipsi_data );
    
    %get neuron classifications of interest
    ind_contr=intersect(ind_contr,ind_sign);
    ind_ipsi=intersect(ind_ipsi,ind_sign);
    ind_resp=ind_sign;
    ind_common=intersect(ind_contr,ind_ipsi);
    indices=struct;
    indices.indices_contra=ind_contr;
    indices.indices_ipsi=ind_ipsi;
    indices.indices_all_resp=ind_resp;
    indices.indices_resp_for_contra_and_ipsi=ind_common;
    
    
    
%% Analysis of Tuning 
    %plot polar histograms showing the tuning distribution in joint torque
    %space
    rad=30;
    figure
    hold on
    subplot(2,3,1)
    hold on
    %plot polar histograms
    [r_contra_resp,theta_contra_resp]=plot_polar_histogram_pd(pd_contra(ind_resp),'b');
    %plot major axis of the bimodal distribution
    plot([0,rad*cos(theta_contra_resp*pi/180)],[0,rad*sin(theta_contra_resp*pi/180)],'b')
    plot([0,rad*cos((theta_contra_resp+180)*pi/180)],[0,rad*sin((theta_contra_resp+180)*pi/180)],'b')
    title(strcat('Angle:',num2str(theta_contra_resp)))

    subplot(2,3,2)
    hold on
    %plot polar histogram
    [r_ipsi_resp,theta_ipsi_resp]=plot_polar_histogram_pd(pd_ipsi(ind_resp),'r');
    %plot major axis of the bimodal distribution
    plot([0,rad*cos(theta_ipsi_resp*pi/180)],[0,rad*sin(theta_ipsi_resp*pi/180)],'r')
    plot([0,rad*cos((theta_ipsi_resp+180)*pi/180)],[0,rad*sin((theta_ipsi_resp+180)*pi/180)],'r')
    title(strcat('Angle:',num2str(theta_ipsi_resp)))

    
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
    title(strcat('Angle:',num2str(theta_diff_resp)))

    %plotting management
    for i=1:3
        subplot(2,3,i)
        xlim([-32,32])
        ylim([-32,32])
        axis square
    end
    
    %calculate the r coefficient expected from a uniform distribution
    numb_it=1000;
    [r_uniform_bimo]=sample_uniform_distribution(length(ind_resp),numb_it,1);
    [r_uniform_unim]=sample_uniform_distribution(length(ind_resp),numb_it,2);
    
    %calculate p values for the data r coefficients 
    contra_p=find(r_uniform_bimo>r_contra_resp);
    contra_p=length(contra_p)/numb_it;
    
    ipsi_p=find(r_uniform_bimo>r_ipsi_resp);
    ipsi_p=length(ipsi_p)/numb_it;
    
    diff_p=find(r_uniform_unim>r_diff_resp);
    diff_p=length(diff_p)/numb_it;
    
    %plot random distributions as cumulative sum plots
    subplot(2,3,4)
    hold on
    cdfplot(r_uniform_bimo)
    vline(r_contra_resp,'b')
    title(strcat('pval:',num2str(contra_p)))
    
    subplot(2,3,5)
    hold on
    cdfplot(r_uniform_bimo)
    vline(r_ipsi_resp,'b')
    title(strcat('pval:',num2str(ipsi_p)))
    
    subplot(2,3,6)
    hold on
    cdfplot(r_uniform_unim)
    vline(r_diff_resp,'b')
    title(strcat('pval:',num2str(diff_p)))
    
    
    
%% Analysis of Magnitude
    %output magnitudes
    mag_struct=struct;
    mag_struct.contra=mag_contra;
    mag_struct.ipsi=mag_ipsi;
    
    %calculate percentiles and medians
    med_ipsi=median(mag_ipsi(ind_resp));
    med_contr=median(mag_contra(ind_resp));
    prc_ipsi_25=prctile(mag_ipsi(ind_resp),25)-med_ipsi;
    prc_ipsi_75=prctile(mag_ipsi(ind_resp),75)-med_ipsi;
    prc_contr_25=prctile(mag_contra(ind_resp),25)-med_contr;
    prc_contr_75=prctile(mag_contra(ind_resp),75)-med_contr;
    

    %plot magnitudes
    figure
    subplot(1,2,1)
    hold on
    scatter(mag_contra(ind_ipsi),mag_ipsi(ind_ipsi),'filled','r');
    scatter(mag_contra(ind_contr),mag_ipsi(ind_contr),'filled','b');
    scatter(mag_contra(ind_common),mag_ipsi(ind_common),'filled','k');
    errorbar(med_contr,med_ipsi,abs(prc_ipsi_25),abs(prc_ipsi_75),abs(prc_contr_25),abs(prc_contr_75))

    %additional plotting details    
    low=0.0;
    upp=120;
    t=linspace(low,upp,10);
    plot(t,t,'k')
    xlim([low,upp])
    ylim([low,upp])
    axis square
    vline(0,'k')
    hline(0,'k')
    set(gca,'XTick',low:20:upp)
    xlabel('Contra Mag')
    ylabel('Ipsi Mag')
    corr_coef=corr(mag_contra.',mag_ipsi.');
    text(0,0,strcat('Rho: ',num2str(corr_coef)))


    %plot difference in magnitude btwn contra and ipsi as a cdfplot
    subplot(1,2,2)
    hold on
    h=cdfplot(mag_contra(ind_resp)-mag_ipsi(ind_resp));
    h.Color='k';
    [p_resp,~,stat_resp]=signrank(mag_contra(ind_resp)-mag_ipsi(ind_resp));
    title(strcat('Contra Mag - Ipsi Mag Signed Rank Test Both Responsive pval: ',num2str(p_resp),' Z-value: ',num2str(stat_resp.zval)))
    xlabel('Magnitude Diff (Contra - Ipsi) (Hz)')
    xlim([-50,100])
    set(gca,'XTick',-50:25:100)
    vline(0,'k')


end


function [r_dist]=sample_uniform_distribution(numb_samps,numb_it,f_uni_or_bi)
%sample tuning changes from a uniform distribution
%calculate Rayleigh unimodal (f_uni_or_bi=1) or bimodal (2) coefficients
    r_dist=zeros(1,numb_it);
    if f_uni_or_bi==1
        for i=1:numb_it
            rand_pds=rand([1,numb_samps])*360;
            rcos=sum(cos(rand_pds*pi/180));
            rsin=sum(sin(rand_pds*pi/180));
            r=sqrt(rcos^2+rsin^2)/numb_samps;
            r_dist(i)=r;
        end
        
    else
        for i=1:numb_it
            rand_pds=rand([1,numb_samps])*360;
            rcos=sum(cos(rand_pds*pi/180*2));
            rsin=sum(sin(rand_pds*pi/180*2));
            r=sqrt(rcos^2+rsin^2)/numb_samps;
            r_dist(i)=r;
        end
    end
end
