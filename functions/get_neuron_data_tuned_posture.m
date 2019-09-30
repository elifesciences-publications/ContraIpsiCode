function [pc1,pc2,pc3,pc4,pc5,pc6,pc7,pc8,pi1,pi2,pi3,pi4,pi5,pi6,pi7,pi8 ] = get_neuron_data_tuned( convolved_H_all )
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
        i
        %get contralateral neurons at steady state
        pert1c=extract_neuron_numb_tune_posture(convolved_H,1);
        pert2c=extract_neuron_numb_tune_posture(convolved_H,2);
        pert3c=extract_neuron_numb_tune_posture(convolved_H,3);
        pert4c=extract_neuron_numb_tune_posture(convolved_H,4);%
        pert5c=extract_neuron_numb_tune_posture(convolved_H,5);
        pert6c=extract_neuron_numb_tune_posture(convolved_H,6);
        pert7c=extract_neuron_numb_tune_posture(convolved_H,7);
        pert8c=extract_neuron_numb_tune_posture(convolved_H,8);%

        %get ipsilateral neurons at steady state
        pert1i=extract_neuron_numb_tune_posture(convolved_H,10);
        pert2i=extract_neuron_numb_tune_posture(convolved_H,11);
        pert3i=extract_neuron_numb_tune_posture(convolved_H,12);
        pert4i=extract_neuron_numb_tune_posture(convolved_H,13);%
        pert5i=extract_neuron_numb_tune_posture(convolved_H,14);
        pert6i=extract_neuron_numb_tune_posture(convolved_H,15);
        pert7i=extract_neuron_numb_tune_posture(convolved_H,16);
        pert8i=extract_neuron_numb_tune_posture(convolved_H,17);%
        
        
      
        
        [~,numb_neuron,tp]=size(pert1c);
        %trials average
        pert1c=reshape(mean(pert1c,1),[numb_neuron,tp]);
        pert2c=reshape(mean(pert2c,1),[numb_neuron,tp]);
        pert3c=reshape(mean(pert3c,1),[numb_neuron,tp]);
        pert4c=reshape(mean(pert4c,1),[numb_neuron,tp]);
        pert5c=reshape(mean(pert5c,1),[numb_neuron,tp]);
        pert6c=reshape(mean(pert6c,1),[numb_neuron,tp]);
        pert7c=reshape(mean(pert7c,1),[numb_neuron,tp]);
        pert8c=reshape(mean(pert8c,1),[numb_neuron,tp]);
        
        
        pert1i=reshape(mean(pert1i,1),[numb_neuron,tp]);
        pert2i=reshape(mean(pert2i,1),[numb_neuron,tp]);
        pert3i=reshape(mean(pert3i,1),[numb_neuron,tp]);
        pert4i=reshape(mean(pert4i,1),[numb_neuron,tp]);
        pert5i=reshape(mean(pert5i,1),[numb_neuron,tp]);
        pert6i=reshape(mean(pert6i,1),[numb_neuron,tp]);
        pert7i=reshape(mean(pert7i,1),[numb_neuron,tp]);
        pert8i=reshape(mean(pert8i,1),[numb_neuron,tp]);
        
       
          

        %average over time epoch
        pert1c=reshape(mean(pert1c,2),[numb_neuron,1]);
        pert2c=reshape(mean(pert2c,2),[numb_neuron,1]);
        pert3c=reshape(mean(pert3c,2),[numb_neuron,1]);
        pert4c=reshape(mean(pert4c,2),[numb_neuron,1]);
        pert5c=reshape(mean(pert5c,2),[numb_neuron,1]);
        pert6c=reshape(mean(pert6c,2),[numb_neuron,1]);
        pert7c=reshape(mean(pert7c,2),[numb_neuron,1]);
        pert8c=reshape(mean(pert8c,2),[numb_neuron,1]);
        
        
        pert1i=reshape(mean(pert1i,2),[numb_neuron,1]);
        pert2i=reshape(mean(pert2i,2),[numb_neuron,1]);
        pert3i=reshape(mean(pert3i,2),[numb_neuron,1]);
        pert4i=reshape(mean(pert4i,2),[numb_neuron,1]);
        pert5i=reshape(mean(pert5i,2),[numb_neuron,1]);
        pert6i=reshape(mean(pert6i,2),[numb_neuron,1]);
        pert7i=reshape(mean(pert7i,2),[numb_neuron,1]);
        pert8i=reshape(mean(pert8i,2),[numb_neuron,1]);
        
        
        
        
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

