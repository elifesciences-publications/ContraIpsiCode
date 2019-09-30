close ALL

cd('../')


cd('functions')
numb_dim=10;
numb_it=1000;

%get the neuron responses for each conditon
[pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
    ,pert4i,pert5i,pert6i,pert7i,pert8i ] = get_neuron_data_per(convolved_H,10 );





%subtract mean off each time point
[pert_matc] = subtract_mean(pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c);
[pert_mati] = subtract_mean(pert1i,pert2i,pert3i,pert4i,pert5i,pert6i,pert7i,pert8i);

[max_fr_val] = get_max_fr_val(pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c);
max_fr=repmat(max_fr_val,[1,size(pert_matc,2)]);

%check to see if no duplicates flag is active
if dup_flag
    pert_matc=pert_matc(good_indices,:);
    pert_mati=pert_mati(good_indices,:);
    max_fr=max_fr(good_indices,:);
end


%get number of neurons
numb_neuron=size(pert1c,1);





%normalize each neuron's response
pert_matc_norm=pert_matc./max_fr;
pert_mati_norm=pert_mati./max_fr;



%use SVD to find principal components
[uc,~,~]=svd(pert_matc_norm);
[ui,~,~]=svd(pert_mati_norm);


%get the top PCs
PC_c=uc(:,1:numb_dim).';
PC_i=ui(:,1:numb_dim).';


%construct covariance matrices
cov_c=pert_matc_norm*pert_matc_norm.';
cov_i=pert_mati_norm*pert_mati_norm.';


%calculate the alignment index
ac_i=trace(PC_c*cov_i*PC_c.')/(trace(PC_i*cov_i*PC_i.'));
ai_c=trace(PC_i*cov_c*PC_i.')/(trace(PC_c*cov_c*PC_c.'));





%calculate random chance of alignment
% mat=[pert_matc_norm pert_mati_norm pert_matb1_norm pert_matb2_norm];
mat=[pert_matc_norm pert_mati_norm];

%get average firing rate of each neuron 
mean_fr=mean(mat,2);
mean_fr=repmat(mean_fr,[1,size(mat,2)]);

mat_norm=(mat-mean_fr);
[ align_random,VAF_random ] = generate_random_alignments( mat_norm,numb_dim,numb_it );



width=0.2;
figure(1)
hold on
subplot(1,2,1)
hold on
bar(1,mean(align_random),width,'w')
errorbar(1,mean(align_random),std(align_random))
bar(1+width*2-width/2.0,ac_i,width,'b')
title('Contralateral_Projections')
xlim([0.75,2.75])
ylim([0,1])

subplot(1,2,2)
hold on
cdfplot(align_random)
vline(ac_i,'b')


figure(2)
hold on
subplot(1,2,1)
hold on
bar(1,mean(align_random),width,'w')
errorbar(1,mean(align_random),std(align_random))
bar(1+width*2-width/2.0,ai_c,width,'r')
title('Ipsilaterallateral_Projections')
xlim([0.75,2.75])
ylim([0,1])

subplot(1,2,2)
hold on
cdfplot(align_random)
vline(ai_c,'r')



figure(3)
hold on
subplot(1,2,1)
hold on
bar(1,mean(align_random),width,'w')
errorbar(1,mean(align_random),std(align_random))
bar(1+width*2-width/2.0,mean([ai_c,ac_i]),width,'k')
title('Average AI')
xlim([0.75,2.75])
ylim([0,1])

subplot(1,2,2)
hold on
cdfplot(align_random)
vline(mean([ai_c,ac_i]),'k')


cd('../')
direct=strcat('figures/',data_type,'/population_analysis/alignment_index');
if dup_flag
    direct=strcat(direct,'/no_duplicates');
end
mkdir(direct)
cd(direct)
h=figure(1);
saveas(h,'Contra Alignment_Index')
saveas(h,'Contra Alignment_Index','epsc')
h=figure(2);
saveas(h,'Ipsi Alignment_Index')
saveas(h,'Ipsi Alignment_Index','epsc')

h=figure(3);
saveas(h,'Avg Alignment_Index')
saveas(h,'Avg Alignment_Index','epsc')

save('Randomnly_Aligned_Axes_Alignment_Index','align_random')