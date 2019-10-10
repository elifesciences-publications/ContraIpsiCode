function [ indices,pd,mag, rsq ] = get_tuned_neurons_input_matrix( pert_mat )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numb_neurons=size(pert_mat,1);

%arrays to store key metrics
indices=[];
pd=[];
mag=[];
rsq=[];


%regressor matrix
sho=[0.2,   0.14,     0,    -0.14,  -0.2,   -0.14,     0,   0.14];
elb=[  0,   0.14,   0.2,     0.14,     0,   -0.14,  -0.2,  -0.14];
tor=[sho;elb;].';

for i=1:numb_neurons
    array=pert_mat(i,:).';
    array=array-mean(array);
    [coef,~,r,~,stats]=regress(array,tor);
    Rsq=1-r.'*r/(norm(array,'fro'))^2;
    if stats(3)<=0.05
        indices=[indices i];
    end

    sho=coef(1);
    elb=coef(2);
    theta=atan(elb/sho);
    if elb>0 && sho<0
        theta=pi+theta;
    elseif elb<0 && sho>0
        theta=2*pi+theta;
    elseif elb<0 && sho<0
        theta=pi+theta;
    end
    pd=[pd theta*180/pi];
    mag=[mag sqrt(sho.^2+elb.^2)];
    
    rsq=[rsq Rsq];
    
    
end
    
        
end



