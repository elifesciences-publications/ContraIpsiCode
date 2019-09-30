function [ bootstrap_potent,bootstrap_null ] = bootstrap_null_onset(convolved_H,potent_map,null_map,max_fr_val,numb_it)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

all_contra=cell(1,8);

numb_days=length(convolved_H);
for i=1:numb_days

    [pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c] = get_neuron_data_per_trials_onset(convolved_H{i},1 );

    all_contra{i,1}=pert1c;
    all_contra{i,2}=pert2c;
    all_contra{i,3}=pert3c;
    all_contra{i,4}=pert4c;

    all_contra{i,5}=pert5c;
    all_contra{i,6}=pert6c;
    all_contra{i,7}=pert7c;
    all_contra{i,8}=pert8c;

  
end

[bootstrap_potent,bootstrap_null] = bootstrap_trials_onset(all_contra,numb_it,max_fr_val,potent_map,null_map);

end