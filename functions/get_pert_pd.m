function [pd ] = get_pert_pd( pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    pd=[];

        [numb_neuron,time_pts]=size(pert1c);
        pd_array=zeros(numb_neuron,time_pts);
        
        for i=1:numb_neuron
%             pert_array=[pert1c(i,100:400);pert2c(i,100:400);pert3c(i,100:400);pert4c(i,100:400);...
%                 pert5c(i,100:400);pert6c(i,100:400);pert7c(i,100:400);pert8c(i,100:400);];
        
            a=200+0;
            b=200+300;
            pert_array=[pert1c(i,a:b);pert2c(i,a:b);pert3c(i,a:b);pert4c(i,a:b);...
                pert5c(i,a:b);pert6c(i,a:b);pert7c(i,a:b);pert8c(i,a:b);];
%             
            
            pert_array=mean(pert_array,2);
            [~,ind]=max(pert_array);
            
            a=1;
            b=200;
            switch ind
                case 1
                    mean_sig1=pert8c(i,:)-mean(pert8c(i,a:b),2);
                    mean_sig2=pert1c(i,:)-mean(pert1c(i,a:b),2);
                    mean_sig3=pert2c(i,:)-mean(pert2c(i,a:b),2);
                    pd_array(i,:)=pert1c(i,:)-mean(pert1c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
                case 2
                    mean_sig1=pert1c(i,:)-mean(pert1c(i,a:b),2);
                    mean_sig2=pert2c(i,:)-mean(pert2c(i,a:b),2);
                    mean_sig3=pert3c(i,:)-mean(pert3c(i,a:b),2);
                    pd_array(i,:)=pert2c(i,:)-mean(pert2c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
                case 3
                    mean_sig1=pert2c(i,:)-mean(pert2c(i,a:b),2);
                    mean_sig2=pert3c(i,:)-mean(pert3c(i,a:b),2);
                    mean_sig3=pert4c(i,:)-mean(pert4c(i,a:b),2);
                    pd_array(i,:)=pert3c(i,:)-mean(pert3c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
                    
                case 4
                    mean_sig1=pert3c(i,:)-mean(pert3c(i,a:b),2);
                    mean_sig2=pert4c(i,:)-mean(pert4c(i,a:b),2);
                    mean_sig3=pert5c(i,:)-mean(pert5c(i,a:b),2);
                    pd_array(i,:)=pert4c(i,:)-mean(pert4c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
                case 5
                    mean_sig1=pert4c(i,:)-mean(pert4c(i,a:b),2);
                    mean_sig2=pert5c(i,:)-mean(pert5c(i,a:b),2);
                    mean_sig3=pert6c(i,:)-mean(pert6c(i,a:b),2);
                    pd_array(i,:)=pert5c(i,:)-mean(pert5c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
                case 6
                    mean_sig1=pert5c(i,:)-mean(pert5c(i,a:b),2);
                    mean_sig2=pert6c(i,:)-mean(pert6c(i,a:b),2);
                    mean_sig3=pert7c(i,:)-mean(pert7c(i,a:b),2);
                    pd_array(i,:)=pert6c(i,:)-mean(pert6c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
                    
                case 7
                    mean_sig1=pert6c(i,:)-mean(pert6c(i,a:b),2);
                    mean_sig2=pert7c(i,:)-mean(pert7c(i,a:b),2);
                    mean_sig3=pert8c(i,:)-mean(pert8c(i,a:b),2);
                    pd_array(i,:)=pert7c(i,:)-mean(pert7c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
                case 8
                    mean_sig1=pert7c(i,:)-mean(pert7c(i,a:b),2);
                    mean_sig2=pert8c(i,:)-mean(pert8c(i,a:b),2);
                    mean_sig3=pert1c(i,:)-mean(pert1c(i,a:b),2);
                    pd_array(i,:)=pert8c(i,:)-mean(pert8c(i,a:b),2);
%                     pd_array(i,:)=mean([mean_sig1;mean_sig2;mean_sig3],1);
            end
            pd_array(i,:)=pd_array(i,:)*sign(mean(pd_array(i,200:500),2));
         
        end
        pd=[pd;pd_array];
    
        
        
        

end

