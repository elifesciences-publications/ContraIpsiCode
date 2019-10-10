function [] = population_analysis(data,numb_dim,numb_it)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    %get neuron data
    [contra_data,ipsi_data] = get_neuron_data_pert_epoch(data,1);
    %restrict analysis to perturbation epoch
    pert_st=201;
    pert_end=pert_st+300;
    contra_data=contra_data(:,:,pert_st:pert_end);
    ipsi_data=ipsi_data(:,:,pert_st:pert_end);
    
    %preprocess the data
    %restructure array, substract off mean signal and normalize
    max_fr=squeeze(max(max(contra_data,[],1),[],3)).';
    [contra_mat]=preprocess(contra_data,max_fr);
    [ipsi_mat]  =preprocess(ipsi_data,max_fr);
    
    

    
%% PCA analysis
    %use SVD to find principal components
    [uc,~,~]=svd(contra_mat);
    [ui,~,~]=svd(ipsi_mat);

    %get the top PCs
    PC_c=uc(:,1:numb_dim).';
    PC_i=ui(:,1:numb_dim).';
    
    %calculate variance accounted for by each PC dimension
    [VAF_contra_PCc]=calc_VAF(contra_mat,PC_c);
    [VAF_ipsi_PCc  ]=calc_VAF(ipsi_mat,  PC_c);
    [VAF_contra_PCi]=calc_VAF(contra_mat,PC_i);
    [VAF_ipsi_PCi  ]=calc_VAF(ipsi_mat,  PC_i);
    
    
    %plot VAF for contra and ipsi PCs
    figure
    hold on
    %plot contra PCs
    subplot(1,2,1)
    hold on
    scatter(linspace(1,numb_dim,numb_dim),cumsum(VAF_contra_PCc(1:numb_dim))*100,'filled','b')
    scatter(linspace(1,numb_dim,numb_dim),cumsum(VAF_ipsi_PCc(1:numb_dim))*100,'filled','r')
    ylim([0,100])
    xlim([0.5,10.5])
    xlabel('PC #')
    ylabel('Accum VAF')
    title('Contra Principal Components')

    %plot ipsi PCs
    subplot(1,2,2)
    hold on
    scatter(linspace(1,numb_dim,numb_dim),cumsum(VAF_contra_PCi(1:numb_dim))*100,'filled','b')
    scatter(linspace(1,numb_dim,numb_dim),cumsum(VAF_ipsi_PCi(1:numb_dim))*100,'filled','r')
    ylim([0,100])
    xlim([0.5,10.5])
    xlabel('PC #')
    ylabel('Accum VAF')
    title('Ipsi Principal Components')
    
%% Alignment Index
    %construct covariance matrices (technically covariance matrices need to be normaled by the number of entries, however this is
    %unnecessary for our computations)
    cov_c=contra_mat*contra_mat.';
    cov_i=ipsi_mat*ipsi_mat.';


    %calculate the alignment index
    ac_i=trace(PC_c*cov_i*PC_c.')/(trace(PC_i*cov_i*PC_i.'));
    ai_c=trace(PC_i*cov_c*PC_i.')/(trace(PC_c*cov_c*PC_c.'));
    
    %generate alignment indices generated from random alignments
    mat=[contra_mat, ipsi_mat];
    mat=mat-repmat(mean(mat,2),[1,size(mat,2)]);%subtract mean activity
    [ align_random ] = generate_random_alignments( mat,numb_dim,numb_it );
    
    
    %plot alignment index
    figure
    hold on
    width=0.2; %error bar width
    bar(1,mean(align_random),width,'w')
    errorbar(1,mean(align_random),std(align_random))
    bar(1+width*2-width/2.0,ac_i,width,'k')
    bar(1+width*3-width/3.0,ai_c,width,'k')
    ylabel('Alignment Index')
    xlim([0.75,2.75])
    ylim([0,1])
    
%% Pairwise correlation analysis
    numb_neuron=size(cov_c,1);
    corr_c=corr(contra_mat.',contra_mat.');
    corr_i=corr(ipsi_mat.',ipsi_mat.');
    corr_c_resh=reshape(corr_c,[1,numb_neuron*numb_neuron]);
    corr_i_resh=reshape(corr_i,[1,numb_neuron*numb_neuron]);
    [bins,contra_nbins,ipsi_nbins] = bootstrap_corr_coef(data,numb_it);
    
    figure
    hold on
    subplot(1,2,1)
    hold on 
    scatter(corr_c_resh(1:10:end),corr_i_resh(1:10:end),4,'filled')
    [rho,pval]=corr(corr_c_resh.',corr_i_resh.');
    title(num2str(rho))
    xlabel('Contra Corr')
    ylabel('Ipsi Corr')
    xlim([-1,1])
    ylim([-1,1])
    axis square
    
    subplot(1,2,2)
    hold on 
    h=cdfplot(abs(corr_c_resh-corr_i_resh));
    h.Color='k';
    shadedErrorBar(bins,mean(contra_nbins),std(contra_nbins)*3,'b')
    shadedErrorBar(bins,mean(ipsi_nbins),std(ipsi_nbins)*3,'r')
    xlim([0,1.5])
    ylim([0,1])
    axis square
    xlabel('Absolute Change in Correlation')
    ylabel('Cumulative Sum')
    title(strcat('Median Correlation of Data: ',num2str(median(abs(corr_c_resh-corr_i_resh)))))
    
%% Orthogonlization Method
    %reduce the number of dimensions
    numb_dim=3;
    [contra_proj,ipsi_proj]=manifold_optimization(contra_mat,ipsi_mat,numb_dim);
    
    %calculate variance accounted for by each projection
    [VAF_contra_PCc]=calc_VAF(contra_mat,contra_proj);
    [VAF_ipsi_PCc  ]=calc_VAF(ipsi_mat,  contra_proj);
    [VAF_contra_PCi]=calc_VAF(contra_mat,ipsi_proj);
    [VAF_ipsi_PCi  ]=calc_VAF(ipsi_mat,  ipsi_proj);
    
    figure
    hold on
    subplot(1,2,1)
    hold on
    bar(1,sum(VAF_contra_PCc),0.2,'b')
    bar(1.2,sum(VAF_ipsi_PCc),0.2,'r')
    legend('Contra','Ipsi')
    ylim([0,1])
    ylabel('Variance Acct. For')
    title('Contra Align')

    subplot(1,2,2)
    hold on
    bar(1,sum(VAF_contra_PCi),0.2,'b')
    bar(1.2,sum(VAF_ipsi_PCi),0.2,'r')
    ylim([0,1])
    ylabel('Variance Acct. For')
    title('Ipsi Align')
    
    %calculate relative amplitude size
    [contra_amp,ipsi_amp]=calc_relative_amp_diff(data,100,max_fr,contra_proj,ipsi_proj,contra_mat,ipsi_mat);
    figure 
    hold on 
    for i=1:numb_dim
        subplot(2,numb_dim,i)
        hold on 
        cdfplot(contra_amp(:,i))
        subplot(2,numb_dim,i+numb_dim)
        hold on
        cdfplot(ipsi_amp(:,i))
        xlabel('Relative Amplitude (%)')
    end
end






function [VAF]=calc_VAF(data,map)
   %data are assumed to be NxCT
   %map is assumed to by dimensions x N
   numb_dim=size(map,1);
   VAR=norm(data,'fro');
   VAF=zeros(numb_dim,1);
   for d=1:numb_dim
       temp_map=map(d,:);
       reconst=(temp_map.')*temp_map*data;
       resd=norm(reconst-data,'fro');
       VAF(d,1)=1-resd^2/(VAR^2);
   end
end



function [contra_proj,ipsi_proj]=manifold_optimization(contra_data,ipsi_data,numb_dim)
    %assumes contra_data and ipsi_data are NxCT
    %assumes Manopt has been added to your path
%     importmanopt;
    [numb_neuron]=size(contra_data,1);
    
    %construct covariance matrices
    cov_c=contra_data*contra_data.';
    cov_i=ipsi_data*ipsi_data.';
    
    %perform SVD to get singular values of covariance matrices
    [~,sc,~]=svd(cov_c);
    [~,si,~]=svd(cov_i);
    
    %normalize covariance matrices by singular values
    cov_c=cov_c/(sum(diag(sc(1:numb_dim,1:numb_dim))));
    cov_i=cov_i/(sum(diag(si(1:numb_dim,1:numb_dim))));
    
    
    %necessary matrices to extract the appropriate dimensions
    K=eye(numb_dim,numb_dim*2).';
    J=[zeros(numb_dim,numb_dim) eye(numb_dim,numb_dim)].';

    manifold=stiefelfactory(numb_neuron,numb_dim*2,1);
    problem.M=manifold;
    problem.cost=@(x) -0.5*trace(K.'*x.'*cov_c*x*K+J.'*x.'*cov_i*x*J);
    problem.egrad=@(x) -0.5*(cov_c*x*(K*K.')+cov_c.'*x*(K*K.')+cov_i*x*(J*J.')+cov_i.'*x*(J*J.'));

    %find projections that minimze cost function on manifold
    [x,xcost,info,options]=trustregions(problem);

    %get the contra aligned and ipsi aligned projections
    cont_alig=x(:,1:numb_dim);
    ipsi_alig=x(:,numb_dim+1:end);

    %ordering the projections according to their VAF
    %project contralateral and ipsilateral activity onto the projections
    pert_matc_crecon=cont_alig.'*contra_data;
    pert_mati_irecon=ipsi_alig.'*ipsi_data;
    
    %perform PCA
    [ucrecon,~,~]=svd(pert_matc_crecon);
    [uirecon,~,~]=svd(pert_mati_irecon);

    
    contra_proj=ucrecon.'*cont_alig.';
    ipsi_proj=uirecon.'*ipsi_alig.';


end