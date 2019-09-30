function [ indices,coef_all, rsq ] = get_tuned_neurons_input_matrix_loo_cv( pert1,pert2,pert3,pert4,pert5,pert6,pert7,pert8,reg_mat_ori )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numb_neurons=size(pert1,1);

indices=[];
coef_all=[];
rsq=[];
for i=1:numb_neurons
    for j=1:8
        
        array=[pert1(i),pert2(i),pert3(i),pert4(i),pert5(i),pert6(i),pert7(i),pert8(i)].';
        array=array-mean(array);
        reg_mat=reg_mat_ori;
        
        array_lo=array(j);
        reg_mat_lo=reg_mat(:,j);
        
        array(j)=[];
        reg_mat(:,j)=[];
        [coef,~,r,~,stats]=regress(array,reg_mat.');
        
        
        pred=coef.'*reg_mat_lo;
        resd=(pred-array_lo);
        rsq(i,j)=resd.^2/(array_lo+0.1).^2;
        
%         Rsq=1-r.'*r/(norm(array,'fro'))^2;
%         if stats(3)<=0.05
%             indices=[indices i];
%         end
%     
%    
%         coef_all=[coef_all coef];
%         rsq(i,j)=[rsq Rsq];
    end
    
end
    
        
end



