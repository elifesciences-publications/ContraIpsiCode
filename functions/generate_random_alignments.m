function [ align_random ] = generate_random_alignments( mat,dim,numb_it )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    %initializing some variables
    numb_neuron=size(mat,1);
    align_random=zeros(numb_it,1);
    
    %calculating the variance of the super matrix, its covariance of its
    %PCs
    cov_mat=cov(mat.');
    [um,sm,~]=svd(cov_mat);
    for i=1:numb_it
        
        %select random dimensions that are biased towards those spanning
        %the super data matrix.  The bias arises from the 'sm' factor which
        %is the variance accounted for by each vector in um
        Z1=um*sm*randn(numb_neuron,dim);
        Z2=um*sm*randn(numb_neuron,dim);

    
        Z1=Z1/(norm(Z1,'fro'));
        Z2=Z2/(norm(Z2,'fro'));

        [uz1,~,~]=svd(Z1);
        [uz2,~,~]=svd(Z2);

        %this is an unnecssary variable hand-off but I'm not bothering to
        %fix it
        val1=uz1(:,1:dim);
        val2=uz2(:,1:dim);

        %calculate the alignment
        ar=trace(val1.'*(val2*val2.')*val1)/dim;
        align_random(i,1)=ar;
        

        
    end


end

