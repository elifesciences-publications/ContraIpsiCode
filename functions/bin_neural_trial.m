function [ neuron_data_out ] = bin_neural_trial( neuron_data,bin_size )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    [trial,numb_neuron,time_pt]=size(neuron_data);
    nbins=int32(time_pt/bin_size);
    neuron_data_out=zeros(trial,numb_neuron,nbins);
    for k=1:trial
        for i=1:numb_neuron 
            for j=1:nbins
                neuron_data_out(k,i,j)=mean(neuron_data(k,i,1+(j-1)*bin_size:j*bin_size),3);
            end
        end
    end
end

