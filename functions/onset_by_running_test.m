function [onset] = onset_by_running_test(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [numb_neuron,tp]=size(data);
    start_ep=100;
    end_ep=200;
    
    
%     baseline_std=std(data(:,start_ep:end_ep),[],2);
    
    onset=[];
        baseline_avg=mean(data(:,start_ep:end_ep),2);
        for j=1:tp-200-20
            curr_pts=data(:,j+200:j+200+4);
            [h,pval]=ttest(curr_pts,repmat(baseline_avg,[1,5]),'Alpha',0.01);
            if sum(h)==5
                onset=[onset j];
                break

            end
        
    end
                

end

