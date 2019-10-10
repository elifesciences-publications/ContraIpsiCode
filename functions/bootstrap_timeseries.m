function [bstrap_contra_act,bstrap_ipsi_act] = bootstrap_timeseries(data,numb_it,max_fr,contra_map,ipsi_map)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    
    %get neuron data as days x TP_number
    [contra_data,ipsi_data] = get_neuron_data_pert_epoch(data,0);
    
    %define epoch of interest
    start_tp=201;
    end_tp=start_tp+300;
    
    %bootstrap across trials
    %bstrap_contra will be numb_it x neurons x condition x timepoints
    [bstrap_contra_4dtensor]=bstrap_array(contra_data,numb_it,start_tp,end_tp);
    [bstrap_ipsi_4dtensor]=bstrap_array(ipsi_data,numb_it,start_tp,end_tp);
    
    
    bstrap_contra_act=struct;
    for it=1:numb_it
        temp=squeeze(bstrap_contra_4dtensor(it,:,:,:));
        [temp]=preprocess(temp,max_fr);
        proj=contra_map*temp;
        bstrap_contra_act(it).contra_map=proj;
        proj=ipsi_map*temp;
        bstrap_contra_act(it).ipsi_map=proj;
    end
    
    bstrap_ipsi_act=struct;
    for it=1:numb_it
        temp=squeeze(bstrap_ipsi_4dtensor(it,:,:,:));
        [temp]=preprocess(temp,max_fr);
        proj=contra_map*temp;
        bstrap_ipsi_act(it).contra_map=proj;
        proj=ipsi_map*temp;
        bstrap_ipsi_act(it).ipsi_map=proj;
    end
    

end


function [array]=bstrap_array(data,numb_it,start_tp,end_tp)
    [numb_days,TP_numb,~]=size(data);
    array=[]; %array will be n_it x neurons x condition x timepoints
    for it=1:numb_it
        neuron_counter=0;
        for day=1:numb_days
            
            for tp=1:TP_numb
                temp_day=data{day,tp};%trials x neuron x timepoints
                temp_day=temp_day(:,:,start_tp:end_tp); 
                [trials,neuron,~]=size(temp_day);
                for n=1:neuron
                    indices=randi(trials,trials);
                    temp_neuron=mean(temp_day(indices,n,:),1);
                    array(it,tp,n+neuron_counter,:)=temp_neuron;
                end
            end
            neuron_counter=neuron_counter+neuron;
        end
    end
end


