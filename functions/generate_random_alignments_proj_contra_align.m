function [ VAF_diff,amp_contra,amp_ipsi ] = generate_random_alignments_proj_contra_align( cont_mat,ipsi_mat,dim,numb_it )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    mat=[cont_mat ipsi_mat];
    numb_neuron=size(mat,1);
    VAF_diff=zeros(numb_it,1);
    
    amp_contra=zeros(numb_it,dim);
    amp_ipsi=zeros(numb_it,dim);
    
    matc_VAR=norm(cont_mat,'fro');
    mati_VAR=norm(ipsi_mat,'fro');
    
    cov_mat=mat*mat.';
    [um,sm,~]=svd(cov_mat);
    csize=size(cont_mat,2)/8;
    for i=1:numb_it
        
        Z1=um*sm*randn(numb_neuron,dim);
        Z1=Z1/(norm(Z1,'fro').^2);

        [uz1,~,~]=svd(Z1);
        proj1=uz1(:,1:dim);
        
        contra_reconstr=proj1*proj1.'*cont_mat;
        ipsi_reconstr=proj1*proj1.'*ipsi_mat;
        
        resd1=norm(contra_reconstr-cont_mat,'fro');
        VAF_c=1-resd1^2/matc_VAR^2;
        
        resd2=norm(ipsi_reconstr-ipsi_mat,'fro');
        VAF_i=1-resd2^2/mati_VAR^2;
        
        VAF_diff(i,1)=VAF_c-VAF_i;
        
        
        %calculate amplitude
        for j=1:dim
            contra_reconstr=norm(proj1(:,j).'*cont_mat,'fro');
            ipsi_reconstr=norm(proj1(:,j).'*ipsi_mat,'fro');
            
            amp_contra(i,j)=contra_reconstr;
            amp_ipsi(i,j)=ipsi_reconstr;
        end
        
        
        
    end


end

