function [pd ] = get_pert_pd( pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,start_epoch,end_epoch )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    pd=[];

        [numb_neuron,time_pts]=size(pert1c);
        pd_array=zeros(numb_neuron,time_pts);
        
        for i=1:numb_neuron
%             pert_array=[pert1c(i,100:400);pert2c(i,100:400);pert3c(i,100:400);pert4c(i,100:400);...
%                 pert5c(i,100:400);pert6c(i,100:400);pert7c(i,100:400);pert8c(i,100:400);];
        
            a=200+start_epoch;
            b=200+end_epoch;
            pert_array=[pert1c(i,a:b);pert2c(i,a:b);pert3c(i,a:b);pert4c(i,a:b);...
                pert5c(i,a:b);pert6c(i,a:b);pert7c(i,a:b);pert8c(i,a:b);];
%             
            
            pert_array=mean(pert_array,2);
            [~,ind]=max(pert_array);
            
            a=1;
            b=200;
            switch ind
                case 1

                    pd_array(i,:)=pert1c(i,:)-mean(pert1c(i,a:b),2);
                case 2
                    pd_array(i,:)=pert2c(i,:)-mean(pert2c(i,a:b),2);
                case 3
                    pd_array(i,:)=pert3c(i,:)-mean(pert3c(i,a:b),2);      
                case 4
                    pd_array(i,:)=pert4c(i,:)-mean(pert4c(i,a:b),2);
                case 5
                    pd_array(i,:)=pert5c(i,:)-mean(pert5c(i,a:b),2);
                case 6
                    pd_array(i,:)=pert6c(i,:)-mean(pert6c(i,a:b),2);                    
                case 7
                    pd_array(i,:)=pert7c(i,:)-mean(pert7c(i,a:b),2);
                case 8
                    pd_array(i,:)=pert8c(i,:)-mean(pert8c(i,a:b),2);
            end
            pd_array(i,:)=pd_array(i,:)*sign(mean(pd_array(i,200+start_epoch:200+end_epoch),2));
         
        end
        pd=[pd;pd_array];
    
        
        
        

end

