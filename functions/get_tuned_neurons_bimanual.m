function [ indices,pd,sho_all,elb_all,mag ] = get_tuned_neurons_bimanual( pert1,pert2,pert3,pert4,pert5,pert6,pert7,pert8 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numb_neurons=size(pert1,1);

indices=[];
pd=[];
sho_all=[];
elb_all=[];
mag=[];
for i=1:numb_neurons
    array=[pert1(i),pert2(i),pert3(i),pert4(i),pert5(i),pert6(i),pert7(i),pert8(i)].';
    array=array-mean(array);
    sho=[0.2,   0.14,     0,    -0.14,  -0.2,   -0.14,     0,   0.14];
    elb=[  0,   0.14,   0.2,     0.14,     0,   -0.14,  -0.2,  -0.14];
    tor=[sho;elb].';
    [coef,~,r,~,stats]=regress(array,tor);
    Rsq=1-r.'*r/(norm(array,'fro'))^2;
    if stats(3)<=0.05
        indices=[indices i];
    end
    
    sho=coef(1);
    elb=coef(2);
    sho_all=[sho_all sho];
    elb_all=[elb_all elb];
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
    
    
    
end
    
        
end




