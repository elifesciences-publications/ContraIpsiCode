function [data_mat]=preprocess(data,max_fr)
    %data are assumed to be CxNxT
    %max_fr is assumed to be Nx1
    %restruct to a NxCT array with mean signal subtracted
    [C,N,T]=size(data);
    data_mat=zeros(N,C*ceil(T/10)); %downsample to every 10ms
    
    %subtract mean signal
    data=data-repmat(mean(data,1),[C,1,1]);
    for n=1:N
        temp_arr=[];
        for c=1:C
            temp_arr=[temp_arr;squeeze(data(c,n,1:10:end))];%downsample to every 10ms
        end
        data_mat(n,:)=temp_arr.';
    end
    data_mat=data_mat./repmat(max_fr,[1,C*ceil(T/10)]);
end

