function [AUC] = ROC_curve(t_series,base_st,base_end)
%UNTITLED2 Summary of this function goes here
    
    base=t_series(1,base_st:base_end);

     AUC=ones(numb_neuron,1)/2.0;
    for i=1:numb_neuron
        mech_resp=pd(:,i);
        unpert_resp=unpert(:,i);

        thresholds=union(mech_resp,unpert_resp);
        fpr=ones(1,1);
        tpr=ones(1,1);

        for j=1:length(thresholds)
            z=thresholds(j);
            tpr(j+1)=length(find(mech_resp>z))/length(mech_resp);
            fpr(j+1)=length(find(unpert_resp>z))/length(unpert_resp);

        end

%         if abs(mean(unpert_resp))>2 || abs(mean(mech_resp))>2
            AUC(i)=trapz(fliplr(fpr),fliplr(tpr));
%         end
    end



end

