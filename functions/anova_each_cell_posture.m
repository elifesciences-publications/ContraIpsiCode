function [ind_sign ] = anova_each_cell_posture( convolved_H_all )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    ind_sign=[];
    numb_days=length(convolved_H_all);

    
    base_st=1;
    base_end=100;

    pert_st=101;
    pert_end=100+300;
    
    contra_base_mat=cell(1,1);
    contra_pert_mat=cell(1,1);
    start_cell_ind=0;
    
    for i=1:numb_days
        convolved_H=convolved_H_all{i};
        
        for k=1:8
            base=extract_neuron_numb_per_onset(convolved_H,k);
            pert=extract_neuron_numb_tune_posture(convolved_H,k);
            numb_neuron=size(pert,2);
            base_ep=squeeze(mean(base(:,:,base_st:base_end),3));
            pert_ep=squeeze(mean(pert(:,:,1:end),3));
            for j=1:numb_neuron
                contra_base_mat{start_cell_ind+j,k}=base_ep(:,j);
            end
            for j=1:numb_neuron
                contra_pert_mat{start_cell_ind+j,k}=pert_ep(:,j);
            end
        end
        
        start_cell_ind=start_cell_ind+numb_neuron;
       
    end
    
    
    
    
    
    
    
    
    
    ipsi_base_mat=cell(1,1);
    ipsi_pert_mat=cell(1,1);
    start_cell_ind=0;
    
    for i=1:numb_days
        convolved_H=convolved_H_all{i};
        
        for k=10:17
            base=extract_neuron_numb_per_onset(convolved_H,k);
            pert=extract_neuron_numb_tune_posture(convolved_H,k);
            numb_neuron=size(pert,2);
            base_ep=squeeze(mean(base(:,:,base_st:base_end),3));
            pert_ep=squeeze(mean(pert(:,:,1:end),3));
            for j=1:numb_neuron
                ipsi_base_mat{start_cell_ind+j,k-9}=base_ep(:,j);
            end
            for j=1:numb_neuron
                ipsi_pert_mat{start_cell_ind+j,k-9}=pert_ep(:,j);
            end
        end
        
        start_cell_ind=start_cell_ind+numb_neuron;
       
    end
    
    
    
    numb_neuron=size(contra_base_mat,1);
    numb_load=size(contra_base_mat,2);
    
    for i=1:numb_neuron
        data=[];
        label_dir=[];
        label_context=[];
        label_time=[];
        for k=1:numb_load
            data=[data contra_base_mat{i,k}.'];
            numb_trials=size(contra_base_mat{i,k},1);
            for trial=1:numb_trials
                label_dir=[label_dir k];
                label_context=[label_context,1];
                label_time=[label_time,1];
            end
        end
        for k=1:numb_load
            data=[data contra_pert_mat{i,k}.'];
            numb_trials=size(contra_pert_mat{i,k},1);
            for trial=1:numb_trials
                label_dir=[label_dir k];
                label_context=[label_context,1];
                label_time=[label_time,2];
            end
        end
        for k=1:numb_load
            data=[data ipsi_base_mat{i,k}.'];
            numb_trials=size(ipsi_base_mat{i,k},1);
            for trial=1:numb_trials
                label_dir=[label_dir k];
                label_context=[label_context,2];
                label_time=[label_time,1];
            end
        end
        for k=1:numb_load
            data=[data ipsi_pert_mat{i,k}.'];
            numb_trials=size(ipsi_pert_mat{i,k},1);
            for trial=1:numb_trials
                label_dir=[label_dir k];
                label_context=[label_context,2];
                label_time=[label_time,2];
            end
        end
        [p,tbl,stats]=anovan(data,{label_context,label_dir,label_time},'model','full','varnames',{'context','load direction','time'});
        close ALL hidden
        if p(3)<0.05 || p(5)<0.05 || p(6)<0.05 || p(7)<0.05
            ind_sign=[ind_sign i];
        end
        
    end
    
    
    

end

