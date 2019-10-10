function [data_mat_contra,data_mat_ipsi] = get_neuron_data_pert_epoch(data,f_trial_avg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    %get the number of recording days
    fnames=fieldnames(data);
    ndays=length(fnames);

    
    if f_trial_avg
        data_mat_contra=[];
        data_mat_ipsi=[];
    else
        data_mat_contra=cell(1,1);
        data_mat_ipsi=cell(1,1);
    end
    
    

    for day=1:ndays

        curr_neuron_numb=size(data_mat_contra,2);
        for TP_numb=1:8
        
            temp_array_contra=data.(fnames{day}).pert_epoch.contra_loads.(strcat('TP',num2str(TP_numb)));    
            temp_array_ipsi=data.(fnames{day}).pert_epoch.ipsi_loads.(strcat('TP',num2str(TP_numb)));
            update_neuron_numb=size(temp_array_contra,2)+curr_neuron_numb;
            if f_trial_avg
                temp_array_contra=squeeze(mean(temp_array_contra,1));
                temp_array_ipsi  =squeeze(mean(temp_array_ipsi,1));
                
                numb_neurons=size(temp_array_contra,1);
                data_mat_contra(TP_numb,curr_neuron_numb+1:update_neuron_numb,:)=temp_array_contra;
                data_mat_ipsi(TP_numb,curr_neuron_numb+1:update_neuron_numb,:)=temp_array_ipsi;
            else
                data_mat_contra{day,TP_numb}=temp_array_contra;
                data_mat_ipsi  {day,TP_numb}=temp_array_ipsi;
            end
        end
    end


end

