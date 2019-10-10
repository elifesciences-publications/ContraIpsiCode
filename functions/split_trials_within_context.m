function [bstrap_contra_act,bstrap_ipsi_act] = split_trials_within_context(data,numb_it)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    
    %get neuron data as days x TP_number
    [contra_data,ipsi_data] = get_neuron_data_pert_epoch(data,0);
    
    %define epoch of interest
    start_tp=201;
    end_tp=start_tp+300;
    
    %bootstrap across trials
    %bstrap_contra will be numb_it x neurons x condition x timepoints
    [contra_4dtensor1,contra_4dtensor2]=bstrap_array(contra_data,numb_it,start_tp,end_tp);
    [ipsi_4dtensor1,ipsi_4dtensor2]=bstrap_array(ipsi_data,numb_it,start_tp,end_tp);
    
    
    bstrap_contra_act=struct;
    for it=1:numb_it
        temp=squeeze(contra_4dtensor1(it,:,:,:));
        [temp]=preprocess(temp,1);
        bstrap_contra_act(it).contra1=temp;
        temp=squeeze(contra_4dtensor2(it,:,:,:));
        [temp]=preprocess(temp,1);
        bstrap_contra_act(it).contra2=temp;
    end
    
    bstrap_ipsi_act=struct;
    for it=1:numb_it
        temp=squeeze(ipsi_4dtensor1(it,:,:,:));
        [temp]=preprocess(temp,1);
        bstrap_ipsi_act(it).ipsi1=temp;
        temp=squeeze(ipsi_4dtensor2(it,:,:,:));
        [temp]=preprocess(temp,1);
        bstrap_ipsi_act(it).ipsi2=temp;
    end
    

end


function [array1,array2]=bstrap_array(data,numb_it,start_tp,end_tp)
    [numb_days,TP_numb,~]=size(data);
    array1=[]; %array will be n_it x neurons x condition x timepoints
    array2=[]; %array will be n_it x neurons x condition x timepoints
    for it=1:numb_it
        neuron_counter=0;
        for day=1:numb_days
            
            for tp=1:TP_numb
                temp_day=data{day,tp};%trials x neuron x timepoints
                temp_day=temp_day(:,:,start_tp:end_tp); 
                [trials,neuron,~]=size(temp_day);
                half=round(trials/2);
                for n=1:neuron
                    indices=randperm(trials,trials);
                    temp_neuron=mean(temp_day(indices(1:half),n,:),1);
                    array1(it,tp,n+neuron_counter,:)=temp_neuron;
                    temp_neuron=mean(temp_day(indices(half+1:end),n,:),1);
                    array2(it,tp,n+neuron_counter,:)=temp_neuron;
                end
            end
            neuron_counter=neuron_counter+neuron;
        end
    end
end


