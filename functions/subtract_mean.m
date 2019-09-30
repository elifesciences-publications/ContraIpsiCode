function [pert_matc] = subtract_mean(pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [numb_neurons,time_pts]=size(pert1c);
    
    mean_rp=zeros(numb_neurons,time_pts);
    for i=1:numb_neurons
        for j=1:time_pts
            arr=[pert1c(i,j),pert2c(i,j),pert3c(i,j),pert4c(i,j),pert5c(i,j),pert6c(i,j),pert7c(i,j),pert8c(i,j)] ;
            mean_rp(i,j)=mean(arr);
        end
    end
    
    mean_rp=repmat(mean_rp,[1,8]);
    pert_matc=[pert1c pert2c pert3c pert4c pert5c pert6c pert7c pert8c];
    pert_matc=pert_matc-mean_rp;

end

