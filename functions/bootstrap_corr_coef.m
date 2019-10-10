function [bins,contra_nbins,ipsi_nbins] = bootstrap_corr_coef(data,numb_it)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
       
    %bootstrap trials
    [bstrap_contra_act,bstrap_ipsi_act] = split_trials_within_context(data,numb_it);
    
    %calculate change in correlation 
    corr_change_contra=[];
    corr_change_ipsi=[];
    for it=1:numb_it
        temp_1=bstrap_contra_act(it).contra1;
        temp_2=bstrap_contra_act(it).contra2;
        [corr_change]=calc_corr_change(temp_1,temp_2);
        corr_change_contra(it,:)=corr_change;
        
        temp_1=bstrap_ipsi_act(it).ipsi1;
        temp_2=bstrap_ipsi_act(it).ipsi2;
        [corr_change]=calc_corr_change(temp_1,temp_2);
        corr_change_ipsi(it,:)=corr_change;
    end
    
    
    bins=linspace(0,1.5,ceil(1.5/0.01));
    [contra_nbins]=bin_corr_coef(corr_change_contra,numb_it,bins);
    [ipsi_nbins]  =bin_corr_coef(corr_change_ipsi,numb_it,bins);
    


end


function [corr_change]=calc_corr_change(data1,data2)
    %calculate change in correlation 
    numb_neuron=size(data1,1);
    corr_1=corr(data1.',data1.');
    corr_2=corr(data2.',data2.');
    corr_1_resh=reshape(corr_1,[1,numb_neuron*numb_neuron]);
    corr_2_resh=reshape(corr_2,[1,numb_neuron*numb_neuron]);
    corr_change=abs(corr_1_resh-corr_2_resh);
end

function [numb_in_bin]=bin_corr_coef(data,numb_it,bins)
    
    numb_in_bin=ones(numb_it,length(bins));
    numb_pts=size(data,2);
    for j=1:numb_it
       for i=1:length(bins)
           curr_bin=bins(i);
           numb_in_bin(j,i)=length(find(data(j,:)<curr_bin))/numb_pts;
           if length(find(data(j,:)<curr_bin))/numb_pts==1
               break;
           end
       end    
    end

end