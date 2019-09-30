close ALL
cd('../')

cd('functions')

%number of orthogonal dimensions
d=3;
cond_size=150;
numb_it=100;

%get neuron data from both files
[pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
    ,pert4i,pert5i,pert6i,pert7i,pert8i ] = get_neuron_data_per( convolved_H,10 );



numb_neuron=size(pert1c,1);


[pert_matc] = subtract_mean(pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c);
[pert_mati] = subtract_mean(pert1i,pert2i,pert3i,pert4i,pert5i,pert6i,pert7i,pert8i);


[max_fr_val] = get_max_fr_val(pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c);
max_fr=repmat(max_fr_val,[1,size(pert_matc,2)]);

pert_matc_norm=pert_matc./max_fr;
pert_mati_norm=pert_mati./max_fr;




%matrix manifold calculation using MANOPT
curr_dir=cd();
cd('C:\Users\BrainDrain\Documents\MATLAB\manopt') %directory containing functions for MANOPT
importmanopt;
cd(curr_dir);


%find the dx2 vectors of length n that are orthogonal and capture the
%covariance of the contralateral and ipsilateral data
%d is the number of orhtogonal dimensions
%n is the number of neurons
%this reduces to a Steiefel Manifold problem


%decompose matrix array contralateral responses using SVD
cov_c=pert_matc_norm*pert_matc_norm.';
cov_i=pert_mati_norm*pert_mati_norm.';

[uc,sc,vc]=svd(cov_c);
[ui,si,vi]=svd(cov_i);
%create covariance matrix of contralateral and ipsilateral 
cov_c=cov_c/(sum(diag(sc(1:d,1:d))));
cov_i=cov_i/(sum(diag(si(1:d,1:d))));



K=eye(d,d*2).';
J=[zeros(d,d) eye(d,d)].';

manifold=stiefelfactory(numb_neuron,d*2,1);
problem.M=manifold;
problem.cost=@(x) -0.5*trace(K.'*x.'*cov_c*x*K+J.'*x.'*cov_i*x*J);
problem.egrad=@(x) -0.5*(cov_c*x*(K*K.')+cov_c.'*x*(K*K.')+cov_i*x*(J*J.')+cov_i.'*x*(J*J.'));

%find projections that minimze cost function on manifold
[x,xcost,info,options]=trustregions(problem);

%get the contra aligned and ipsi aligned projections
cont_alig=x(:,1:d);
ipsi_alig=x(:,d+1:end);

%randomnly combine contralateral and ipsilateral projections
pert_matc_crecon=cont_alig.'*pert_matc_norm;
pert_mati_irecon=ipsi_alig.'*pert_mati_norm;

[ucrecon,scr,~]=svd(pert_matc_crecon);
[uirecon,sci,~]=svd(pert_mati_irecon);

contra_map=ucrecon.'*cont_alig.';
ipsi_map=uirecon.'*ipsi_alig.';

for i=1:d

    pert_matc_norm_VAR=norm(pert_matc_norm,'fro');
%     reconst=cont_alig(:,i)*cont_alig(:,i).'*pert_matc_norm;
    reconst=contra_map(i,:).'*contra_map(i,:)*pert_matc_norm;
    resd=norm(reconst-pert_matc_norm,'fro');
    VAFc_cont_alig(1,i)=1-resd^2/pert_matc_norm_VAR^2;
    ampc_cont_alig(1,i)=norm(contra_map(i,:)*pert_matc_norm,'fro');
    

    %project ipsilateral activity onto the contral aligned projs and
    %calculate the VAF
    pert_mati_norm_VAR=norm(pert_mati_norm,'fro');
    reconst=contra_map(i,:).'*contra_map(i,:)*pert_mati_norm;
    resd=norm(reconst-pert_mati_norm,'fro');
    VAFi_cont_alig(1,i)=1-resd^2/pert_mati_norm_VAR^2;
    ampi_cont_alig(1,i)=norm(contra_map(i,:)*pert_mati_norm,'fro');

    %project contralateral activity onto the ipsi aligned projs and
    %calculate the VAF
    pert_matc_norm_VAR=norm(pert_matc_norm,'fro');
    reconst=ipsi_map(i,:).'*ipsi_map(i,:)*pert_matc_norm;
    resd=norm(reconst-pert_matc_norm,'fro');
    VAFc_ipsi_alig(1,i)=1-resd^2/pert_matc_norm_VAR^2;
    ampc_ipsi_alig(1,i)=norm(ipsi_map(i,:)*pert_matc_norm,'fro');


    %project ipsi activity onto the ipsi aligned projs and
    %calculate the VAF
    pert_mati_norm_VAR=norm(pert_mati_norm,'fro');
    reconst=ipsi_map(i,:).'*ipsi_map(i,:)*pert_mati_norm;
    resd=norm(reconst-pert_mati_norm,'fro');
    VAFi_ipsi_alig(1,i)=1-resd^2/pert_mati_norm_VAR^2;
    ampi_ipsi_alig(1,i)=norm(ipsi_map(i,:)*pert_mati_norm,'fro');


end

 [ VAF_diff,amp_contra,amp_ipsi ] = generate_random_alignments_proj_contra_align( pert_matc_norm,pert_mati_norm,d,numb_it );
figure(1)
hold on
subplot(1,3,1)
hold on
bar(1,sum(VAFc_cont_alig),0.2,'b')
bar(1.2,sum(VAFi_cont_alig),0.2,'r')
legend('Contra','Ipsi')
ylim([0,1])
ylabel('Variance Acct. For')
title('Contra Align')

subplot(1,3,2)
hold on
bar(1,sum(VAFc_ipsi_alig),0.2,'b')
bar(1.2,sum(VAFi_ipsi_alig),0.2,'r')
ylim([0,1])
ylabel('Variance Acct. For')
title('Ipsi Align')

subplot(1,3,3)
hold on
cdfplot(VAF_diff);
vline(sum(VAFc_cont_alig-VAFi_cont_alig),'b')
vline(sum(VAFc_ipsi_alig-VAFi_ipsi_alig),'r')
title('Diff of Contra with Ipsi')


suptitle(strcat('Numb Dimensions: ',num2str(d),' Separation Index: ',num2str(xcost)))




[h,p,ksstat]=kstest((w_diff-mean(w_diff))/std(w_diff));
title(strcat('KS test: ksstat ',num2str(ksstat),' pval: ',num2str(p)))


[ bootstrap_contra_calign,bootstrap_contra_ialign,bootstrap_ipsi_calign,bootstrap_ipsi_ialign ] = ...
    bootstrap_amp_btwn_contra_ipsi(convolved_H,cont_alig,ipsi_alig,ucrecon,uirecon,max_fr_val,numb_it);



contra_calign=ucrecon.'*cont_alig.'*pert_matc_norm;
ipsi_ialign=uirecon.'*ipsi_alig.'*pert_mati_norm;

figure(102)
hold on
for i=1:d
    subplot(3,d,i)
    hold on
        
    %contra aligned ipsi activity
    amp=[];
    for j=1:numb_it
        temp=norm(squeeze(bootstrap_ipsi_calign(j,i,:))-squeeze(contra_calign(i,:).'),'fro');
        amp=[amp,temp];
    end
    
    relative_amp=(amp)./(norm(contra_calign(i,:),'fro'))*100;
    bar(1,mean(relative_amp),'r')
    errorbar(1,mean(relative_amp),std(relative_amp)*3,'r')
    ylim([0,150])
    title(strcat('Contra Projection Ipsi Activity: ',num2str(i)))
    ylabel(strcat('Relative Change in Amplitude',num2str(mean(relative_amp))))
    
    subplot(3,d,i+d*2)
    hold on
    h=cdfplot(relative_amp);
    h.Color='r';
    
    
    subplot(3,d,i+d)
    hold on
    %contra aligned ipsi activity
    amp=[];
    for j=1:numb_it
        temp=norm(squeeze(bootstrap_contra_calign(j,i,:))-squeeze(contra_calign(i,:).'),'fro');
        amp=[amp,temp];
    end
    
    relative_amp=(amp)./(norm(contra_calign(i,:),'fro'))*100;
    bar(1,mean(relative_amp),'b')
    errorbar(1,mean(relative_amp),std(relative_amp)*3,'b')
    ylim([0,150])
    title(strcat('Contra Projection Contra Activity: ',num2str(i)))
    ylabel(strcat('Relative Change in Amplitude',num2str(mean(relative_amp))))
    
    subplot(3,d,i+d*2)
    h=cdfplot(relative_amp);
    h.Color='b';
end




figure(103)
hold on
for i=1:d
    subplot(3,d,i)
    hold on
    amp=[];
    for j=1:numb_it
       
        temp=norm(squeeze(bootstrap_contra_ialign(j,i,:))-squeeze(ipsi_ialign(i,:).'),'fro');
        amp=[amp,temp];
    end
    
    relative_amp=amp./norm(ipsi_ialign(i,:),'fro')*100;
    bar(1,mean(relative_amp),'b')
    errorbar(1,mean(relative_amp),std(relative_amp)*3,'b')
    ylim([00,150])
    title(strcat('Ipsi Projection Contra Activity: ',num2str(i)))
    ylabel(strcat('Relative Change in Amplitude',num2str(mean(relative_amp))))
    
    
    subplot(3,d,i+d*2)
    hold on
    h=cdfplot(relative_amp);
    h.Color='b';
    
    
    
    subplot(3,d,i+d)
    hold on
    amp=[];
    for j=1:numb_it
       
        temp=norm(squeeze(bootstrap_ipsi_ialign(j,i,:))-squeeze(ipsi_ialign(i,:).'),'fro');
        amp=[amp,temp];
    end
    
    relative_amp=amp./norm(ipsi_ialign(i,:),'fro')*100;
    bar(1,mean(relative_amp),'r')
    errorbar(1,mean(relative_amp),std(relative_amp)*3,'r')
    ylim([00,150])
    title(strcat('Ipsi Projection Contra Activity: ',num2str(i)))
    ylabel(strcat('Relative Change in Amplitude',num2str(mean(relative_amp))))
    
    
    subplot(3,d,i+d*2)
    h=cdfplot(relative_amp);
    h.Color='r';
end


[pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
        ,pert4i,pert5i,pert6i,pert7i,pert8i ] = get_neuron_data_per_onset(convolved_H,1);
[pert_matc] = subtract_mean(pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c);
[pert_mati] = subtract_mean(pert1i,pert2i,pert3i,pert4i,pert5i,pert6i,pert7i,pert8i);

mat_all=[pert_matc pert_mati];
%get max firing rate +5Hz(soft normalization)
max_fr=repmat(max_fr_val,[1,size(mat_all,2)/2]);

pert_matc_norm=pert_matc./max_fr;
pert_mati_norm=pert_mati./max_fr;

pert_matc_caxis=ucrecon.'*cont_alig.'*pert_matc_norm;
pert_mati_caxis=ucrecon.'*cont_alig.'*pert_mati_norm;
pert_matc_iaxis=uirecon.'*ipsi_alig.'*pert_matc_norm;
pert_mati_iaxis=uirecon.'*ipsi_alig.'*pert_mati_norm;


cond_size=801;
time=linspace(-100,600,701);
yupp=3;
ylow=-3;
for j=1:d
    cdim=j;
    figure(cdim+1)
    hold on
    subplot(1,2,1)
    hold on
    for i=1:8
        pcol=[0 (i)/8 1];
        plot(time,pert_matc_caxis(cdim,1+(i-1)*cond_size:cond_size*i),'Color',pcol)
        ylim([ylow,yupp])
        xlim([-100,500])
        
    end
    vline(0,'k')
    hline(0,'k')
    title(strcat('VAF: ',num2str(VAFc_cont_alig(j))))
    
    subplot(1,2,2)
    hold on
    for i=1:8
        pcol=[1 (i)/8 0];
        plot(time,pert_mati_caxis(cdim,1+(i-1)*cond_size:cond_size*i),'Color',pcol)
        ylim([ylow,yupp])
        xlim([-100,500])
        
    end
    vline(0,'k')
    hline(0,'k')
    title(strcat('VAF: ',num2str(VAFi_cont_alig(j))))
end










for j=1:d
    cdim=j;
    figure(cdim+1+10)
    hold on
    subplot(1,2,1)
    hold on
    for i=1:8
        pcol=[0 (i)/8 1];
        plot(time,pert_matc_iaxis(cdim,1+(i-1)*cond_size:cond_size*i),'Color',pcol)
        ylim([ylow,yupp])
        xlim([-100,500])
        
    end
    vline(0,'k')
    hline(0,'k')
    title(strcat('VAF: ',num2str(VAFc_ipsi_alig(j))))
    
    subplot(1,2,2)
    hold on
    for i=1:8
        pcol=[1 (i)/8 0];
        plot(time,pert_mati_iaxis(cdim,1+(i-1)*cond_size:cond_size*i),'Color',pcol)
        ylim([ylow,yupp])
        xlim([-100,500])
        
    end
    vline(0,'k')
    hline(0,'k')
    title(strcat('VAF: ',num2str(VAFi_ipsi_alig(j))))
end




assert(false)

cd('../')
curr_dir=strcat('figures/',data_type,'/orthogonalized/ortho_projections_overlayed_contra_ipsi_only/CV');
mkdir(curr_dir)
cd(curr_dir)
h=figure(1);
saveas(h,'VAF projections')
saveas(h,'VAF projections','epsc')
save('Diff of Variance of Randomly Aligned Axes','VAF_diff')
save('Amplitude of Contra Matrix from Random Projections','amp_contra')
save('Amplitude of Ipsi Matrix from Random Projections','amp_ipsi')

h=figure(102);
saveas(h,'Relative Amplitude of Contra Projections')
saveas(h,'Relative Amplitude of Contra Projections','epsc')

h=figure(103);
saveas(h,'Relative Amplitude of Ipsi Projections')
saveas(h,'Relative Amplitude of Ipsi Projections','epsc')


h=figure(2);
saveas(h,'Contra Projection 1')
saveas(h,'Contra Projection 1','epsc')

h=figure(3);
saveas(h,'Contra Projection 2')
saveas(h,'Contra Projection 2','epsc')


h=figure(4);
saveas(h,'Contra Projection 3')
saveas(h,'Contra Projection 3','epsc')



h=figure(12);
saveas(h,'Ipsi Projection 1')
saveas(h,'Ipsi Projection 1','epsc')

h=figure(13);
saveas(h,'Ipsi Projection 2')
saveas(h,'Ipsi Projection 2','epsc')


h=figure(14);
saveas(h,'Ipsi Projection 3')
saveas(h,'Ipsi Projection 3','epsc')







