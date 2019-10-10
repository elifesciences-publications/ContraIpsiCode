function [pd_array ] = get_pd(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    %data are assumed to be CxNxT
    %T should span 200ms before perturbation onset till 300ms after
    [~,numb_neuron,time_pts]=size(data);
    pd_array=zeros(numb_neuron,time_pts);
    
    %epochs of interest
    base_st=1;
    base_end=200;
    pert_st=base_end+1;
    pert_end=base_end+301;
    
        
    for neuron=1:numb_neuron
        %get current neuron data
        temp_data=squeeze(data(:,neuron,:));

        %get arrays that contain the average firing rate for each
        %condition during baseline and perturbation epochs
        pert_array=squeeze(temp_data(:,pert_st:pert_end));
        base_array=squeeze(temp_data(:,base_st:base_end));

        %average across time and subtract the baseline from the
        %perturbation array
        pert_array=mean(pert_array,2);
        base_array=mean(base_array,2);
        pert_array=pert_array-base_array;

        %find the entry with the largest response
        [~,ind]=max(pert_array);
        %get the entries of the two spatially adjacent loads
        ind_prev=ind-1;
        ind_after=ind+1;
        if ind_prev==0
            ind_prev=8;
        end
        if ind_after==9
            ind_after=1;
        end

        %get the activities associated with each index and subtract
        %their baselines
        temp_arr=temp_data([ind_prev,ind,ind_after],:)-repmat(base_array([ind_prev,ind,ind_after]),[1,size(temp_data,2)]);
        temp_arr=mean(temp_arr,1);
        temp_arr=temp_arr*sign(mean(temp_arr(1,pert_st:pert_end),2)); 
        pd_array(neuron,:)=temp_arr;
    end
end
            
            
%             %get the neuron's preferred diretion
%             
%             switch ind
%                 case 1
%                     temp=
%             
%             
%             a=1;
%             b=200;
%             switch ind
%                 case 1
%                     mean_sig1=pert8c(i,:)-mean(pert8c(i,a:b),2);
%                     mean_sig2=pert1c(i,:)-mean(pert1c(i,a:b),2);
%                     mean_sig3=pert2c(i,:)-mean(pert2c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
%                 case 2
%                     mean_sig1=pert1c(i,:)-mean(pert1c(i,a:b),2);
%                     mean_sig2=pert2c(i,:)-mean(pert2c(i,a:b),2);
%                     mean_sig3=pert3c(i,:)-mean(pert3c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
%                 case 3
%                     mean_sig1=pert2c(i,:)-mean(pert2c(i,a:b),2);
%                     mean_sig2=pert3c(i,:)-mean(pert3c(i,a:b),2);
%                     mean_sig3=pert4c(i,:)-mean(pert4c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
%                     
%                 case 4
%                     mean_sig1=pert3c(i,:)-mean(pert3c(i,a:b),2);
%                     mean_sig2=pert4c(i,:)-mean(pert4c(i,a:b),2);
%                     mean_sig3=pert5c(i,:)-mean(pert5c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
%                 case 5
%                     mean_sig1=pert4c(i,:)-mean(pert4c(i,a:b),2);
%                     mean_sig2=pert5c(i,:)-mean(pert5c(i,a:b),2);
%                     mean_sig3=pert6c(i,:)-mean(pert6c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
%                 case 6
%                     mean_sig1=pert5c(i,:)-mean(pert5c(i,a:b),2);
%                     mean_sig2=pert6c(i,:)-mean(pert6c(i,a:b),2);
%                     mean_sig3=pert7c(i,:)-mean(pert7c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
%                     
%                 case 7
%                     mean_sig1=pert6c(i,:)-mean(pert6c(i,a:b),2);
%                     mean_sig2=pert7c(i,:)-mean(pert7c(i,a:b),2);
%                     mean_sig3=pert8c(i,:)-mean(pert8c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
%                 case 8
%                     mean_sig1=pert7c(i,:)-mean(pert7c(i,a:b),2);
%                     mean_sig2=pert8c(i,:)-mean(pert8c(i,a:b),2);
%                     mean_sig3=pert1c(i,:)-mean(pert1c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
%             end
%             pd_array(i,:)=pd_array(i,:)*sign(mean(pd_array(i,200:500),2));        
%         end
%         pd=[pd;pd_array];
% %     
%         
%         
%         
% 
% end

