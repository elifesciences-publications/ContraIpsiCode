function [pc1,pc2,pc3,pc4,pc5,pc6,pc7,pc8,pi1,pi2,pi3,pi4,pi5,pi6,pi7,pi8 ] = get_neuron_data_per_onset( convolved_H_all,bin_size )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    numb_days=length(convolved_H_all);
    
    pc1=[];
    pc2=[];
    pc3=[];
    pc4=[];
    pc5=[];
    pc6=[];
    pc7=[];
    pc8=[];
    
    pi1=[];
    pi2=[];
    pi3=[];
    pi4=[];
    pi5=[];
    pi6=[];
    pi7=[];
    pi8=[];
    
    
    for i=1:numb_days
        convolved_H=convolved_H_all{i};
        %get contralateral neurons at steady state
        pert1c=extract_neuron_numb_per_onset(convolved_H,1);
        pert2c=extract_neuron_numb_per_onset(convolved_H,2);
        pert3c=extract_neuron_numb_per_onset(convolved_H,3);
        pert4c=extract_neuron_numb_per_onset(convolved_H,4);%
        pert5c=extract_neuron_numb_per_onset(convolved_H,5);
        pert6c=extract_neuron_numb_per_onset(convolved_H,6);
        pert7c=extract_neuron_numb_per_onset(convolved_H,7);
        pert8c=extract_neuron_numb_per_onset(convolved_H,8);%

        %get ipsilateral neurons at steady state
        pert1i=extract_neuron_numb_per_onset(convolved_H,10);
        pert2i=extract_neuron_numb_per_onset(convolved_H,11);
        pert3i=extract_neuron_numb_per_onset(convolved_H,12);
        pert4i=extract_neuron_numb_per_onset(convolved_H,13);%
        pert5i=extract_neuron_numb_per_onset(convolved_H,14);
        pert6i=extract_neuron_numb_per_onset(convolved_H,15);
        pert7i=extract_neuron_numb_per_onset(convolved_H,16);
        pert8i=extract_neuron_numb_per_onset(convolved_H,17);%
        
        
%         pert1c=decimate_neural_trial(pert1c,bin_size);
%         pert2c=decimate_neural_trial(pert2c,bin_size);
%         pert3c=decimate_neural_trial(pert3c,bin_size);
%         pert4c=decimate_neural_trial(pert4c,bin_size);
%     
%         pert5c=decimate_neural_trial(pert5c,bin_size);
%         pert6c=decimate_neural_trial(pert6c,bin_size);
%         pert7c=decimate_neural_trial(pert7c,bin_size);
%         pert8c=decimate_neural_trial(pert8c,bin_size);
%     
%         pert1i=decimate_neural_trial(pert1i,bin_size);
%         pert2i=decimate_neural_trial(pert2i,bin_size);
%         pert3i=decimate_neural_trial(pert3i,bin_size);
%         pert4i=decimate_neural_trial(pert4i,bin_size);
%     
%         pert5i=decimate_neural_trial(pert5i,bin_size);
%         pert6i=decimate_neural_trial(pert6i,bin_size);
%         pert7i=decimate_neural_trial(pert7i,bin_size);
%         pert8i=decimate_neural_trial(pert8i,bin_size);
        
        
    
        %trial average
        pert1c=squeeze(mean(pert1c,1));
        pert2c=squeeze(mean(pert2c,1));
        pert3c=squeeze(mean(pert3c,1));
        pert4c=squeeze(mean(pert4c,1));
        
        pert5c=squeeze(mean(pert5c,1));
        pert6c=squeeze(mean(pert6c,1));
        pert7c=squeeze(mean(pert7c,1));
        pert8c=squeeze(mean(pert8c,1));
        
        
        pert1i=squeeze(mean(pert1i,1));
        pert2i=squeeze(mean(pert2i,1));
        pert3i=squeeze(mean(pert3i,1));
        pert4i=squeeze(mean(pert4i,1));
        
        pert5i=squeeze(mean(pert5i,1));
        pert6i=squeeze(mean(pert6i,1));
        pert7i=squeeze(mean(pert7i,1));
        pert8i=squeeze(mean(pert8i,1));
        

        
        
%         %filter
%         [b,a]=butter(3,50/1000);
%         for j=1:numb_neuron
%             pert1c(j,:)=filtfilt(b,a,pert1c(j,:));
%             pert2c(j,:)=filtfilt(b,a,pert2c(j,:));
%             pert3c(j,:)=filtfilt(b,a,pert3c(j,:));
%             pert4c(j,:)=filtfilt(b,a,pert4c(j,:));
%             pert5c(j,:)=filtfilt(b,a,pert5c(j,:));
%             pert6c(j,:)=filtfilt(b,a,pert6c(j,:));
%             pert7c(j,:)=filtfilt(b,a,pert7c(j,:));
%             pert8c(j,:)=filtfilt(b,a,pert8c(j,:));
%         end
%         
%         for j=1:numb_neuron
%             pert1i(j,:)=filtfilt(b,a,pert1i(j,:));
%             pert2i(j,:)=filtfilt(b,a,pert2i(j,:));
%             pert3i(j,:)=filtfilt(b,a,pert3i(j,:));
%             pert4i(j,:)=filtfilt(b,a,pert4i(j,:));
%             pert5i(j,:)=filtfilt(b,a,pert5i(j,:));
%             pert6i(j,:)=filtfilt(b,a,pert6i(j,:));
%             pert7i(j,:)=filtfilt(b,a,pert7i(j,:));
%             pert8i(j,:)=filtfilt(b,a,pert8i(j,:));
%         end
        
        


        pc1=[pc1; pert1c];
        pc2=[pc2; pert2c];
        pc3=[pc3; pert3c];
        pc4=[pc4; pert4c];
        
        pc5=[pc5; pert5c];
        pc6=[pc6; pert6c];
        pc7=[pc7; pert7c];
        pc8=[pc8; pert8c];
        
        pi1=[pi1; pert1i];
        pi2=[pi2; pert2i];
        pi3=[pi3; pert3i];
        pi4=[pi4; pert4i];
        
        pi5=[pi5; pert5i];
        pi6=[pi6; pert6i];
        pi7=[pi7; pert7i];
        pi8=[pi8; pert8i];
    end

end

