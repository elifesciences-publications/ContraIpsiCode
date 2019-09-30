function [ bootstrap_contra_calign,bootstrap_contra_ialign,bootstrap_ipsi_calign,bootstrap_ipsi_ialign ] = ...
    bootstrap_amp_btwn_contra_ipsi(convolved_H,cont_alig,ipsi_alig,ucrecon,uirecon,max_fr_val,numb_it)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

all_contra=cell(1,8);
all_ipsi=cell(1,8);

numb_days=length(convolved_H);
for i=1:numb_days

    [pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
            ,pert4i,pert5i,pert6i,pert7i,pert8i ] = get_neuron_data_per_trials(convolved_H{i},10 );

    all_contra{i,1}=pert1c;
    all_contra{i,2}=pert2c;
    all_contra{i,3}=pert3c;
    all_contra{i,4}=pert4c;

    all_contra{i,5}=pert5c;
    all_contra{i,6}=pert6c;
    all_contra{i,7}=pert7c;
    all_contra{i,8}=pert8c;


    all_ipsi{i,1}=pert1i;
    all_ipsi{i,2}=pert2i;
    all_ipsi{i,3}=pert3i;
    all_ipsi{i,4}=pert4i;

    all_ipsi{i,5}=pert5i;
    all_ipsi{i,6}=pert6i;
    all_ipsi{i,7}=pert7i;
    all_ipsi{i,8}=pert8i;
  
end



[bootstrap_contra_calign,bootstrap_contra_ialign] = bootstrap_trials(all_contra,numb_it,max_fr_val,ucrecon,cont_alig,uirecon,ipsi_alig);
[bootstrap_ipsi_calign,bootstrap_ipsi_ialign] = bootstrap_trials(all_ipsi,numb_it,max_fr_val,ucrecon,cont_alig,uirecon,ipsi_alig);


end