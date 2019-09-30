close ALL

cd('../')


cd('functions')
numb_dim=10;
[pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
    ,pert4i,pert5i,pert6i,pert7i,pert8i ] = get_neuron_data_per( convolved_H,10);

numb_neuron=size(pert1c,1);
ind_comb=linspace(1,numb_neuron,numb_neuron);

[pert_matc] = subtract_mean(pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c);
[pert_mati] = subtract_mean(pert1i,pert2i,pert3i,pert4i,pert5i,pert6i,pert7i,pert8i);


[max_fr_val] = get_max_fr_val(pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c);
max_fr=repmat(max_fr_val,[1,size(pert_matc,2)]);


pert_matc_norm=pert_matc./max_fr;
pert_mati_norm=pert_mati./max_fr;

%use SVD to find principal components
[uc,~,~]=svd(pert_matc_norm);

%get variance of array of normalized contralateral repsonse; used for
%variance accounted for calculation
pert_matc_norm_VAR=norm(pert_matc_norm,'fro');

%calculate variance accounted for (VAF)
VAFc_calign=zeros(1,1);
for i=1:numb_dim
    %create mapping from neuron to PCA space using left sing. vectors
    map=uc(:,i).';
    %reconstruct neuron resp. from mapping
    reconst=map.'*map*pert_matc_norm;
    %calculate residuals
    resd=norm(reconst-pert_matc_norm,'fro');
    %caculate and store the VAF
    VAFc_calign(i,1)=1-resd^2/pert_matc_norm_VAR^2;
end



%same as above for ipsilateral arm
pert_mati_norm_VAR=norm(pert_mati_norm,'fro');
VAFi_calign=zeros(1,1);
for i=1:numb_dim
    map=uc(:,i).';
    reconst=map.'*map*pert_mati_norm;
    resd=norm(reconst-pert_mati_norm,'fro');
    VAFi_calign(i,1)=1-resd^2/pert_mati_norm_VAR^2;
end




%get PCA's for ipsilateral activity
[ui,si,vi]=svd(pert_mati_norm);
pert_matc_norm_VAR=norm(pert_matc_norm,'fro');


%calculate VAF for contrateral activity for each principal component
VAFc_ialign=zeros(numb_dim,1);
for i=1:numb_dim
    map=ui(:,i).';
    reconst=map.'*map*pert_matc_norm;
    resd=norm(reconst-pert_matc_norm,'fro');
    VAFc_ialign(i,1)=1-resd^2/pert_matc_norm_VAR^2;
end


%calculate VAF for ipsilateral activity for each principal component
pert_mati_norm_VAR=norm(pert_mati_norm,'fro');
VAFi_ialign=zeros(numb_dim,1);
for i=1:numb_dim
    map=ui(:,i).';
    reconst=map.'*map*pert_mati_norm;
    resd=norm(reconst-pert_mati_norm,'fro');
    VAFi_ialign(i,1)=1-resd^2/pert_mati_norm_VAR^2;
end



bwidth=0.1;
figure(1)
hold on

subplot(1,2,1)
hold on
scatter(linspace(1,numb_dim,numb_dim),cumsum(VAFc_calign(1:numb_dim))*100,'filled','b')
scatter(linspace(1,numb_dim,numb_dim),cumsum(VAFi_calign(1:numb_dim))*100,'filled','r')
ylim([0,100])
xlim([0.5,10.5])
xlabel('PC #')
ylabel('Accum VAF')
title('Contra Principal Components')

subplot(1,2,2)
hold on
scatter(linspace(1,numb_dim,numb_dim),cumsum(VAFc_ialign(1:numb_dim))*100,'filled','b')
scatter(linspace(1,numb_dim,numb_dim),cumsum(VAFi_ialign(1:numb_dim))*100,'filled','r')
ylim([0,100])
xlim([0.5,10.5])
xlabel('PC #')
ylabel('Accum VAF')
title('Ipsi Principal Components')


PC_c=abs(uc(:,1:numb_dim).');
PC_i=abs(ui(:,1:numb_dim).');

% figure(2)
% hold on
% for j=1:3
%     for i=1:3
%         subplot(3,3,i+(j-1)*3)
%         hold on
%         w_diff=(PC_c(i,:)-PC_i(j,:))./(PC_c(i,:)+PC_i(j,:));
%         histogram(w_diff,'Binwidth',0.2,'FaceColor','k','FaceAlpha',1);
%         [h,p,ksstat]=kstest((w_diff-mean(w_diff))/std(w_diff));
%         title(strcat('KS test: ksstat ',num2str(ksstat),' pval: ',num2str(p)))
%     end
% end

w_c=sum(PC_c);
w_i=sum(PC_i);

w_diff=(w_c-w_i)./(w_c+w_i);
figure(2)
hold on
histogram(w_diff,'Binwidth',0.1)
xlim([-1,1])
xlabel('Contra - Ipsi over Contra + Ipsi')

[h,p,ksstat]=kstest((w_diff-mean(w_diff))/std(w_diff));
title(strcat('KS test: ksstat ',num2str(ksstat),' pval: ',num2str(p)))


cd('../')
direct=strcat('figures/',data_type,'//population_analysis/PCA');
mkdir(direct)
cd(direct)

h=figure(1);
saveas(h,'CV_PCs')
saveas(h,'CV_PCs','epsc')

h=figure(2);
saveas(h,'Weights Distribution')
saveas(h,'Weights Distribution','epsc')




