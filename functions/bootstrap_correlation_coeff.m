function [ cov_matc_resh,cov_mati_resh ] = ...
    bootstrap_correlation_coeff(convolved_H_all,max_fr_val,numb_it,numb_neuron)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

all_contra=cell(0,8);
all_ipsi=cell(0,8);

numb_days=size(convolved_H_all,1);
for i=1:numb_days
        convolved_H=convolved_H_all{i,1};
        [pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
            ,pert4i,pert5i,pert6i,pert7i,pert8i ] = get_neuron_data_per_trials(convolved_H,10 );

        all_contra{i,1}=pert1c;
        all_contra{i,2}=pert2c;
        all_contra{i,3}=pert3c;
        all_contra{i,4}=pert4c;

        all_contra{i,5}=pert5c;
        all_contra{i,6}=pert6c;
        all_contra{i,7}=pert7c;
        all_contra{i,8}=pert8c;


        all_ipsi{i,1}=pert1i;
        all_ipsi{i,2}=pert2i;
        all_ipsi{i,3}=pert3i;
        all_ipsi{i,4}=pert4i;

        all_ipsi{i,5}=pert5i;
        all_ipsi{i,6}=pert6i;
        all_ipsi{i,7}=pert7i;
        all_ipsi{i,8}=pert8i;
end
    


cov_matc_resh=zeros(numb_it,numb_neuron*numb_neuron);
cov_mati_resh=zeros(numb_it,numb_neuron*numb_neuron);
numb_days=size(all_contra,1);
for k=1:numb_it
    pert_mat_1=[];
    pert_mat_2=[];

    for i=1:numb_days
        p1_all=all_contra{i,1};
        p2_all=all_contra{i,2};
        p3_all=all_contra{i,3};
        p4_all=all_contra{i,4};

        p5_all=all_contra{i,5};
        p6_all=all_contra{i,6};
        p7_all=all_contra{i,7};
        p8_all=all_contra{i,8};
        numb_trials=size(p1_all,1);


        numb_neurons=size(p1_all,2);

        for j=1:numb_neurons
            indices=randi(numb_trials,numb_trials,8);
            p1=squeeze(mean(p1_all(indices(:,1),j,:),1));
            p2=squeeze(mean(p2_all(indices(:,2),j,:),1));
            p3=squeeze(mean(p3_all(indices(:,3),j,:),1));
            p4=squeeze(mean(p4_all(indices(:,4),j,:),1));

            p5=squeeze(mean(p5_all(indices(:,5),j,:),1));
            p6=squeeze(mean(p6_all(indices(:,6),j,:),1));
            p7=squeeze(mean(p7_all(indices(:,7),j,:),1));
            p8=squeeze(mean(p8_all(indices(:,8),j,:),1));

            pmat=subtract_mean(p1.', p2.', p3.', p4.', p5.', p6.', p7.', p8.');
            pert_mat_1=[pert_mat_1; pmat];

            indices=randi(numb_trials,numb_trials,8);
            p1=squeeze(mean(p1_all(indices(:,1),j,:),1));
            p2=squeeze(mean(p2_all(indices(:,2),j,:),1));
            p3=squeeze(mean(p3_all(indices(:,3),j,:),1));
            p4=squeeze(mean(p4_all(indices(:,4),j,:),1));

            p5=squeeze(mean(p5_all(indices(:,5),j,:),1));
            p6=squeeze(mean(p6_all(indices(:,6),j,:),1));
            p7=squeeze(mean(p7_all(indices(:,7),j,:),1));
            p8=squeeze(mean(p8_all(indices(:,8),j,:),1));

            pmat=subtract_mean(p1.', p2.', p3.', p4.', p5.', p6.', p7.', p8.');
            pert_mat_2=[pert_mat_2; pmat];
        end
    end

    max_fr=repmat(max_fr_val,[1,size(pert_mat_1,2)]);
    pert_mat_1=pert_mat_1./max_fr;
    max_fr=repmat(max_fr_val,[1,size(pert_mat_2,2)]);
    pert_mat_2=pert_mat_2./max_fr;

    numb_neuron=size(pert_mat_1,1);
    cov_1=corr(pert_mat_1.',pert_mat_1.');
    cov_2=corr(pert_mat_2.',pert_mat_2.');
    cov_1_resh=reshape(cov_1,[1,numb_neuron*numb_neuron]);
    cov_2_resh=reshape(cov_2,[1,numb_neuron*numb_neuron]);
    cov_matc_resh(k,:)=abs(cov_1_resh-cov_2_resh);

end








for k=1:numb_it
    pert_mat_1=[];
    pert_mat_2=[];

    for i=1:numb_days
        p1_all=all_ipsi{i,1};
        p2_all=all_ipsi{i,2};
        p3_all=all_ipsi{i,3};
        p4_all=all_ipsi{i,4};

        p5_all=all_ipsi{i,5};
        p6_all=all_ipsi{i,6};
        p7_all=all_ipsi{i,7};
        p8_all=all_ipsi{i,8};
        numb_trials=size(p1_all,1);


        numb_neurons=size(p1_all,2);

        for j=1:numb_neurons
            indices=randi(numb_trials,numb_trials,8);
            p1=squeeze(mean(p1_all(indices(:,1),j,:),1));
            p2=squeeze(mean(p2_all(indices(:,2),j,:),1));
            p3=squeeze(mean(p3_all(indices(:,3),j,:),1));
            p4=squeeze(mean(p4_all(indices(:,4),j,:),1));

            p5=squeeze(mean(p5_all(indices(:,5),j,:),1));
            p6=squeeze(mean(p6_all(indices(:,6),j,:),1));
            p7=squeeze(mean(p7_all(indices(:,7),j,:),1));
            p8=squeeze(mean(p8_all(indices(:,8),j,:),1));

            pmat=subtract_mean(p1.', p2.', p3.', p4.', p5.', p6.', p7.', p8.');
            pert_mat_1=[pert_mat_1; pmat];

            indices=randi(numb_trials,numb_trials,8);
            p1=squeeze(mean(p1_all(indices(:,1),j,:),1));
            p2=squeeze(mean(p2_all(indices(:,2),j,:),1));
            p3=squeeze(mean(p3_all(indices(:,3),j,:),1));
            p4=squeeze(mean(p4_all(indices(:,4),j,:),1));

            p5=squeeze(mean(p5_all(indices(:,5),j,:),1));
            p6=squeeze(mean(p6_all(indices(:,6),j,:),1));
            p7=squeeze(mean(p7_all(indices(:,7),j,:),1));
            p8=squeeze(mean(p8_all(indices(:,8),j,:),1));

            pmat=subtract_mean(p1.', p2.', p3.', p4.', p5.', p6.', p7.', p8.');
            pert_mat_2=[pert_mat_2; pmat];
        end
    end

    max_fr=repmat(max_fr_val,[1,size(pert_mat_1,2)]);
    pert_mat_1=pert_mat_1./max_fr;
    max_fr=repmat(max_fr_val,[1,size(pert_mat_2,2)]);
    pert_mat_2=pert_mat_2./max_fr;

    numb_neuron=size(pert_mat_1,1);
    cov_1=corr(pert_mat_1.',pert_mat_1.');
    cov_2=corr(pert_mat_2.',pert_mat_2.');
    cov_1_resh=reshape(cov_1,[1,numb_neuron*numb_neuron]);
    cov_2_resh=reshape(cov_2,[1,numb_neuron*numb_neuron]);
    cov_mati_resh(k,:)=abs(cov_1_resh-cov_2_resh);

end


end