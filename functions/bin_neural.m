function [ neuron_data_out ] = bin_neural( neuron_data,bin_size )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    [numb_neuron,time_pt]=size(neuron_data);
    nbins=int32(time_pt/bin_size);
    neuron_data_out=zeros(numb_neuron,nbins);
    for i=1:numb_neuron 
        for j=1:nbins
            neuron_data_out(i,j)=mean(neuron_data(i,1+(j-1)*bin_size:j*bin_size),2);
        end
    end

end

