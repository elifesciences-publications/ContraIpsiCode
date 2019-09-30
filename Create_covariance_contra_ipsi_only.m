close ALL
cd('../')
cd('functions')
%get neuron data from both files
[pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
    ,pert4i,pert5i,pert6i,pert7i,pert8i ] = get_neuron_data_per( convolved_H,10);

numb_neuron=size(pert1c,1);


[pert_matc] = subtract_mean(pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c);
[pert_mati] = subtract_mean(pert1i,pert2i,pert3i,pert4i,pert5i,pert6i,pert7i,pert8i);

[max_fr_val] = get_max_fr_val(pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c);
max_fr=repmat(max_fr_val,[1,size(pert_matc,2)]);

pert_matc_norm=pert_matc./max_fr;
pert_mati_norm=pert_mati./max_fr;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%COVARIANCE MATRIX PLOTTING
%calculate covariance matrices for each response'
sp_thr=0.4; %threshold for sparse matrix ordering

cov_c=corr(pert_matc_norm.',pert_matc_norm.');
cov_i=corr(pert_mati_norm.',pert_mati_norm.');

cov_c_resh=reshape(cov_c,[1,numb_neuron*numb_neuron]);
cov_i_resh=reshape(cov_i,[1,numb_neuron*numb_neuron]);


%generate sparse matrix from covariance matrix
%this is used to elucidate structure in cov. matrix visually
sp=(cov_c)>sp_thr;

%get indices that will structure matrix
[p]=symamd(sp);


%re-structure each matrix using the covariances
cov_c_str=cov_c(p,p);
cov_i_str=cov_i(p,p);

%plot covariance matrices
x=linspace(1,numb_neuron,numb_neuron); %neuron indices
figure(1)
hold on
surf(x,x,cov_c_str,'EdgeColor','none')
colorbar
colormap('jet')
xlabel('Neuron Numb.')
ylabel('Neuron Numb.')
title('Contralateral Structuring: Contralateral Cov. Matrix')
caxis([-1,1])

figure(2)
hold on
surf(x,x,cov_i_str,'EdgeColor','none')
colorbar
colormap('jet')
xlabel('Neuron Numb.')
ylabel('Neuron Numb.')
title('Contralateral Structuring: Ipsilateral Cov. Matrix')
caxis([-1,1])




%generate sparse matrix from covariance matrix
%this is used to elucidate structure in cov. matrix visually
sp=(cov_i)>sp_thr;

%get indices that will structure matrix
[p]=symamd(sp);

%re-structure each matrix using the covariances
cov_c_str=cov_c(p,p);
cov_i_str=cov_i(p,p);




figure(7)
hold on
surf(x,x,cov_c_str,'EdgeColor','none')
colorbar
colormap('jet')
xlabel('Neuron Numb.')
ylabel('Neuron Numb.')
title('Ipsilateral Structuring: Contralateral Cov. Matrix')
caxis([-1,1])

figure(8)
hold on
surf(x,x,cov_i_str,'EdgeColor','none')
colorbar
colormap('jet')
xlabel('Neuron Numb.')
ylabel('Neuron Numb.')
title('Ipsilateral Structuring: Ipsilateral Cov. Matrix')
caxis([-1,1])






nplot=10;
figure(13)
hold on
scatter(cov_c_resh(1:nplot:end),cov_i_resh(1:nplot:end),4,'filled')
[rho,pval]=corr(cov_c_resh.',cov_i_resh.');
title(num2str(rho))
xlabel('Contra Corr')
ylabel('Ipsi Corr')
xlim([-1,1])
ylim([-1,1])
axis square


assert(false)

cd('../')
direct=strcat('figures/',data_type,'/population_analysis/covariance_matrices');
mkdir(direct)
cd(direct)
h=figure(1);
saveas(h,'Cov Mat Contra Sorted Contra Activity')
saveas(h,'Cov Mat Contra Sorted Contra Activity','epsc')
h=figure(2);
saveas(h,'Cov Mat Contra Sorted Ipsi Activity')
saveas(h,'Cov Mat Contra Sorted Ipsi Activity','epsc')



h=figure(7);
saveas(h,'Cov Mat Ipsi Sorted Contra Activity')
saveas(h,'Cov Mat Ipsi Sorted Contra Activity','epsc')
h=figure(8);
saveas(h,'Cov Mat Ipsi Sorted Ipsi Activity')
saveas(h,'Cov Mat Ipsi Sorted Ipsi Activity','epsc')





h=figure(13);
saveas(h,'Pairwise Correlation with Contra')
saveas(h,'Pairwise Correlation with Contra','epsc')
