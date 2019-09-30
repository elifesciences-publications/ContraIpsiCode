function [ ttest_p ] = diff_func_onset( pert1, offset_ind )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

    [~,neuron,~]=size(pert1);
    base_st=offset_ind-100;
    end_st=offset_ind;
    base_avg=mean(pert1(:,base_st:end_st),2);
    base_std=std(pert1(:,base_st:end_s),[],2);
    
    onsets=[];
    for i=1:neuron 
        
        
        
        start_ind=offset_ind+100;
        end_ind=offset_ind+200;
        neuron_ind=i;
  
        unpert_curr=epoch_average( unpert(:,neuron_ind,:),start_ind, end_ind );
        pert_curr1=epoch_average( pert1(:,neuron_ind,:),start_ind, end_ind );
        pert_curr2=epoch_average( pert2(:,neuron_ind,:),start_ind, end_ind );
%         if abs(mean(unpert_curr)-mean(pert_curr1))>2
            signif_1=compare_epoch_neuron(unpert_curr,pert_curr1);
            signif_2=compare_epoch_neuron(unpert_curr,pert_curr2);
            ttest_p(i,1)=signif_1;
            ttest_p(i,2)=signif_2;
%         end
    end

    

end

