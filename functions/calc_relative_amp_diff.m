function [contra_amp,ipsi_amp] = calc_relative_amp_diff(data,numb_it,max_fr,contra_proj,ipsi_proj,contra_mat,ipsi_mat)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    %calculate the difference in amplitude
    [numb_dim]=size(contra_proj,1);
    
    %bootstrap trials
    [bstrap_contra_act,bstrap_ipsi_act] = bootstrap_timeseries(data,numb_it,max_fr,contra_proj,ipsi_proj);
    
    %project the contra and ipsi activity into their respective spaces
    contra_mat=contra_proj*contra_mat;
    ipsi_mat=ipsi_proj*ipsi_mat;
    
    contra_amp=zeros(numb_it,numb_dim);
    ipsi_amp=zeros(numb_it,numb_dim);
    
    for it=1:numb_it
        for d=1:numb_dim
            temp=bstrap_ipsi_act(it).contra_map(d,:);
            contra_amp(it,d)=norm(temp-contra_mat(d,:),'fro')/norm(contra_mat(d,:),'fro')*100;
            temp=bstrap_contra_act(it).ipsi_map(d,:);
            ipsi_amp(it,d)=norm(temp-ipsi_mat(d,:),'fro')/norm(ipsi_mat(d,:),'fro')*100;
        end
    end

end

