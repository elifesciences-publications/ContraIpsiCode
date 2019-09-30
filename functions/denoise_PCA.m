function [ pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
    ,pert4i,pert5i,pert6i,pert7i,pert8i ] = denoise_PCA( pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
    ,pert4i,pert5i,pert6i,pert7i,pert8i )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


    numb_neurons=size(pert1c,1);
    for d=1:numb_neurons
        mat=[pert1c(d,:); pert2c(d,:); pert3c(d,:); pert4c(d,:); pert5c(d,:); pert6c(d,:); pert7c(d,:); pert8c(d,:)];

        [ud,sd,~]=svd(mat);
        
        map=ud(:,1:2).';
        %reconstruct neuron resp. from mapping
        reconst=map.'*map*mat;
        
        pert1c(d,:)=reconst(1,:);
        pert2c(d,:)=reconst(2,:);
        pert3c(d,:)=reconst(3,:);
        pert4c(d,:)=reconst(4,:);
        
        pert5c(d,:)=reconst(5,:);
        pert6c(d,:)=reconst(6,:);
        pert7c(d,:)=reconst(7,:);
        pert8c(d,:)=reconst(8,:);
        
        
        
        mat=[pert1i(d,:); pert2i(d,:); pert3i(d,:); pert4i(d,:); pert5i(d,:); pert6i(d,:); pert7i(d,:); pert8i(d,:)];

        [ud,sd,~]=svd(mat);
        
        map=ud(:,1:2).';
        %reconstruct neuron resp. from mapping
        reconst=map.'*map*mat;
        pert1i(d,:)=reconst(1,:);
        pert2i(d,:)=reconst(2,:);
        pert3i(d,:)=reconst(3,:);
        pert4i(d,:)=reconst(4,:);
        
        pert5i(d,:)=reconst(5,:);
        pert6i(d,:)=reconst(6,:);
        pert7i(d,:)=reconst(7,:);
        pert8i(d,:)=reconst(8,:);
        
       
        
    end


end

