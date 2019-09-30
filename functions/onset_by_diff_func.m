function [onset] = onset_by_diff_func(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [numb_neuron,tp]=size(data);
    start_ep=1;
    end_ep=200;
    
    baseline_avg=mean(data(:,start_ep:end_ep),2);
    baseline_std=std(data(:,start_ep:end_ep),[],2);
    
    onset=zeros(numb_neuron,1);
    for i=1:numb_neuron
        
        for j=1:tp-200-20
            curr_pts=data(i,j+200:j+200+19);
            numb_above=sum(curr_pts>baseline_avg(i)+baseline_std(i)*3);
            
            if numb_above==20
                onset(i)=j;
                break
            end
        end
    end
                

end

