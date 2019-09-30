function [bootc_strap,booti_strap] = bootstrap_trials(data_cell,numb_it,max_fr_val,ucrecon,cont_alig,uirecon,ipsi_alig)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    numb_days=size(data_cell,1);
    
    bootc_strap=zeros(numb_it,size(cont_alig,2),size(data_cell{1,1},3)*8);
    for k=1:numb_it
        pert_mat_c=[];
    
        for i=1:numb_days
            p1_all=data_cell{i,1};
            p2_all=data_cell{i,2};
            p3_all=data_cell{i,3};
            p4_all=data_cell{i,4};

            p5_all=data_cell{i,5};
            p6_all=data_cell{i,6};
            p7_all=data_cell{i,7};
            p8_all=data_cell{i,8};
            
            
            [numb_trials,numb_neurons,tp]=size(p1_all);

            for j=1:numb_neurons
                indices=randi(numb_trials,numb_trials,8);
%                 p1=reshape(mean(p1_all(indices(:,1),j,:),1),[1,tp]);
                p1=squeeze(mean(p1_all(indices(:,1),j,:),1));
                p2=squeeze(mean(p2_all(indices(:,2),j,:),1));
                p3=squeeze(mean(p3_all(indices(:,3),j,:),1));
                p4=squeeze(mean(p4_all(indices(:,4),j,:),1));

                p5=squeeze(mean(p5_all(indices(:,5),j,:),1));
                p6=squeeze(mean(p6_all(indices(:,6),j,:),1));
                p7=squeeze(mean(p7_all(indices(:,7),j,:),1));
                p8=squeeze(mean(p8_all(indices(:,8),j,:),1));

                pmat=subtract_mean(p1.', p2.', p3.', p4.', p5.', p6.', p7.', p8.');
                pert_mat_c=[pert_mat_c; pmat];
            end
        end
        
        max_fr=repmat(max_fr_val,[1,size(pert_mat_c,2)]);
        pert_mat_c=pert_mat_c./max_fr;
        
        mat_reduce=ucrecon.'*cont_alig.'*pert_mat_c;
        bootc_strap(k,:,:)=mat_reduce(:,:);
        
        mat_reduce=uirecon.'*ipsi_alig.'*pert_mat_c;
        booti_strap(k,:,:)=mat_reduce(:,:);
        
    end
end


