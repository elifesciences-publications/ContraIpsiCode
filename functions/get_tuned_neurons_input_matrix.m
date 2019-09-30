function [ indices,coef_all, rsq ] = get_tuned_neurons_input_matrix( pert1,pert2,pert3,pert4,pert5,pert6,pert7,pert8,reg_mat )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numb_neurons=size(pert1,1);

indices=[];
coef_all=[];
rsq=[];
for i=1:numb_neurons
    array=[pert1(i),pert2(i),pert3(i),pert4(i),pert5(i),pert6(i),pert7(i),pert8(i)].';
    array=array-mean(array);
    [coef,~,r,~,stats]=regress(array,reg_mat.');
    Rsq=1-r.'*r/(norm(array,'fro'))^2;
    if stats(3)<=0.05
        indices=[indices i];
    end
    
   
    coef_all=[coef_all coef];
    rsq=[rsq Rsq];
    
    
end
    
        
end



