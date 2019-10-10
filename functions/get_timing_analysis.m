function [] = get_timing_analysis(data,ind_sign)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    %get neuron data
    [contra_data,ipsi_data] = get_neuron_data_pert_epoch(data,1);
    [pd_contra ] = get_pd(contra_data);
    [pd_ipsi   ] = get_pd(ipsi_data);
    
    %get each neuron's onset
    [onset_contra] = onset_by_diff_func(pd_contra(ind_sign,:));
    [onset_ipsi] = onset_by_diff_func(pd_ipsi(ind_sign,:));

    %get neurons with detected onsets
    onset_contra_sign=find(onset_contra>0);
    onset_ipsi_sign=find(onset_ipsi>0);
    overlap=intersect(onset_contra_sign,onset_ipsi_sign);
    
%% Plot comparison between contra and ipsi onsets
    %calculate percentiles to plot on graph
    med_ipsi=median(onset_ipsi(overlap));
    med_contr=median(onset_contra(overlap));
    prc_ipsi_25=prctile(onset_ipsi(overlap),25)-med_ipsi;
    prc_ipsi_75=prctile(onset_ipsi(overlap),75)-med_ipsi;
    prc_contr_25=prctile(onset_contra(overlap),25)-med_contr;
    prc_contr_75=prctile(onset_contra(overlap),75)-med_contr;
    
    %plot scatter plot comparing contra onsets with ipsi onsets
    figure
    hold on
    subplot(1,2,1)
    hold on
    scatter(onset_contra(overlap),onset_ipsi(overlap))
    errorbar(med_contr,med_ipsi,abs(prc_ipsi_25),abs(prc_ipsi_75),abs(prc_contr_25),abs(prc_contr_75))
    
    %plotting management
    a=0;
    b=250;
    t=linspace(a,b,10);
    plot(t,t,'k')
    xlim([a,b])
    ylim([a,b])
    axis square
    xlabel('Contralateral Onset (ms)')
    ylabel('Ipsilateral Onset (ms)')
    
    
    %plot cdfplot contrasting the onsets between contra and ipsi activity
    subplot(1,2,2)
    hold on
    cdfplot(onset_contra(overlap)-onset_ipsi(overlap))
    [p,~,stats]=signrank(onset_contra(overlap)-onset_ipsi(overlap));
    xlabel('Onset Times (ms)')
    title(strcat('Onset Contra - Onset Ipsi, Signed Rank Test pval: ',num2str(p),' z val: ', num2str(stats.zval)))
    
%% Plot PSTH of Contra and Ipsi activity
    figure
    hold on
    
    %average across neurons 
    contra_avg=mean(pd_contra(ind_sign,:),1);
    contra_ste=std(pd_contra(ind_sign,:),[],1)/sqrt(size(pd_contra(ind_sign,:),1));
    ipsi_avg=mean(pd_ipsi(ind_sign,:),1);
    ipsi_ste=std(pd_ipsi(ind_sign,:),[],1)/sqrt(size(pd_ipsi(ind_sign,:),1));

    %get onset of population response
    [onset_contra] = onset_by_diff_func(contra_avg);
    [onset_ipsi] = onset_by_diff_func(ipsi_avg);

    %plot PSTH
    time=linspace(-200,300,501);
    shadedErrorBar(time,contra_avg,contra_ste,'b')
    shadedErrorBar(time,ipsi_avg,ipsi_ste,'r')
    
    %plot the contra and ipsi onsets
    vline(onset_contra,'b')
    vline(onset_ipsi,'r')
    
    %additional plot management
    vline(0,'k')
    hline(0,'k')
    xlim([-100,300])
    xlabel('Time (ms)')
    ylabel('Firing Rate (sp/s)')
    title('Contra (blue) and Ipsi (red) PSTH)')


end





function [onset] = onset_by_diff_func(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   data are assumed to be NxT
    [numb_neuron,tp]=size(data);
    
    %define start and end of baseline period
    base_st=1;
    base_end=200;
    
    %get baseline activity
    baseline_avg=mean(data(:,base_st:base_end),2);
    baseline_std=std (data(:,base_st:base_end),[],2);
    
    onset=zeros(numb_neuron,1);
    for i=1:numb_neuron
        
        for j=1:tp-base_end-20
            curr_pts=data(i,j+base_end:j+base_end+19);
            numb_above=sum(curr_pts>baseline_avg(i)+baseline_std(i)*3);
            
            if numb_above==20
                onset(i)=j;
                break
            end
        end
    end
                

end