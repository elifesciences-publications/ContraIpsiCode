function [VAF] = estimate_noise_floor_on_each_trial(data_cell,numb_it,max_fr_val)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here\
    numb_days=size(data_cell,1);
    
    VAF=[];
    for k=1:numb_it
        pert_mat_c=[];
        pert_mat_c2=[];
    
        for i=1:numb_days
            p1_all=data_cell{i,1};
            p2_all=data_cell{i,2};
            p3_all=data_cell{i,3};
            p4_all=data_cell{i,4};

            p5_all=data_cell{i,5};
            p6_all=data_cell{i,6};
            p7_all=data_cell{i,7};
            p8_all=data_cell{i,8};
            numb_trials=size(p1_all,1);
            
            
            numb_neurons=size(p1_all,2);
            trials=[randperm(numb_trials);randperm(numb_trials);randperm(numb_trials);randperm(numb_trials);...
                    randperm(numb_trials);randperm(numb_trials);randperm(numb_trials);randperm(numb_trials)];
            for j=1:numb_neurons
                
                
                indices=trials(:,1);
                p1=squeeze(p1_all(indices(1),j,:));
                p2=squeeze(p2_all(indices(2),j,:));
                p3=squeeze(p3_all(indices(3),j,:));
                p4=squeeze(p4_all(indices(4),j,:));

                p5=squeeze(p5_all(indices(5),j,:));
                p6=squeeze(p6_all(indices(6),j,:));
                p7=squeeze(p7_all(indices(7),j,:));
                p8=squeeze(p8_all(indices(8),j,:));

                pmat=subtract_mean(p1.', p2.', p3.', p4.', p5.', p6.', p7.', p8.');
                pert_mat_c=[pert_mat_c; pmat/max_fr_val(j)/(sqrt(2*numb_trials))];
                
                
                
                indices2=trials(:,2);
                p1=squeeze(p1_all(indices2(1),j,:));
                p2=squeeze(p2_all(indices2(2),j,:));
                p3=squeeze(p3_all(indices2(3),j,:));
                p4=squeeze(p4_all(indices2(4),j,:));

                p5=squeeze(p5_all(indices2(5),j,:));
                p6=squeeze(p6_all(indices2(6),j,:));
                p7=squeeze(p7_all(indices2(7),j,:));
                p8=squeeze(p8_all(indices2(8),j,:));

                pmat=subtract_mean(p1.', p2.', p3.', p4.', p5.', p6.', p7.', p8.');
                pert_mat_c2=[pert_mat_c2; pmat/max_fr_val(j)/(sqrt(2*numb_trials))];
            end
            
            
        end
        diff=pert_mat_c-pert_mat_c2;
%         diff=pert_mat_c;
        diff_avg=mean(diff,2);
        diff=diff-repmat(diff_avg,[1,size(pert_mat_c,2)]);
        [u,s,v]=svd(diff);
        VAF=[VAF diag(s.^2)];
        
        
    end
end


