function [pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i,pert4i,pert5i,pert6i,pert7i,pert8i ] = get_neuron_data_per_trials_onset( convolved_H,bin_size )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    

        %get contralateral neurons at steady state
        pert1c=extract_neuron_numb_per_onset_null_potent(convolved_H,1);
        pert2c=extract_neuron_numb_per_onset_null_potent(convolved_H,2);
        pert3c=extract_neuron_numb_per_onset_null_potent(convolved_H,3);
        pert4c=extract_neuron_numb_per_onset_null_potent(convolved_H,4);%
        pert5c=extract_neuron_numb_per_onset_null_potent(convolved_H,5);
        pert6c=extract_neuron_numb_per_onset_null_potent(convolved_H,6);
        pert7c=extract_neuron_numb_per_onset_null_potent(convolved_H,7);
        pert8c=extract_neuron_numb_per_onset_null_potent(convolved_H,8);%

        %get ipsilateral neurons at steady state
        pert1i=extract_neuron_numb_per_onset_null_potent(convolved_H,10);
        pert2i=extract_neuron_numb_per_onset_null_potent(convolved_H,11);
        pert3i=extract_neuron_numb_per_onset_null_potent(convolved_H,12);
        pert4i=extract_neuron_numb_per_onset_null_potent(convolved_H,13);%
        pert5i=extract_neuron_numb_per_onset_null_potent(convolved_H,14);
        pert6i=extract_neuron_numb_per_onset_null_potent(convolved_H,15);
        pert7i=extract_neuron_numb_per_onset_null_potent(convolved_H,16);
        pert8i=extract_neuron_numb_per_onset_null_potent(convolved_H,17);%
        

        
        pert1c=bin_neural_trial(pert1c,bin_size);
        pert2c=bin_neural_trial(pert2c,bin_size);
        pert3c=bin_neural_trial(pert3c,bin_size);
        pert4c=bin_neural_trial(pert4c,bin_size);
    
        pert5c=bin_neural_trial(pert5c,bin_size);
        pert6c=bin_neural_trial(pert6c,bin_size);
        pert7c=bin_neural_trial(pert7c,bin_size);
        pert8c=bin_neural_trial(pert8c,bin_size);
    
        pert1i=bin_neural_trial(pert1i,bin_size);
        pert2i=bin_neural_trial(pert2i,bin_size);
        pert3i=bin_neural_trial(pert3i,bin_size);
        pert4i=bin_neural_trial(pert4i,bin_size);
    
        pert5i=bin_neural_trial(pert5i,bin_size);
        pert6i=bin_neural_trial(pert6i,bin_size);
        pert7i=bin_neural_trial(pert7i,bin_size);
        pert8i=bin_neural_trial(pert8i,bin_size);
        


end

