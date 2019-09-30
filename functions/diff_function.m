function [counter] = diff_function(time_series,offset)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    t_pts=size(time_series,2);
    base_st=1;
    base_end=offset;
    
    base_avg=mean(time_series(1,base_st:base_end),2);
    base_std=std(time_series(1,base_st:base_end),[],2);
    
    upp_bd=base_avg+base_std*5;
    low_bd=base_avg-base_std*5;
    
    flag=1;
    counter=offset;
    while flag || (counter+20)>=t_pts
        temp_pts=time_series(1,counter);
        if temp_pts>upp_bd
            array=time_series(1,counter+1:counter+19);
            array=array>upp_bd;
            array=sum(array);
            if array==19
                flag=0;
            end
        end
        
        if temp_pts<low_bd
            array=time_series(1,counter+1:counter+19);
            array=array<low_bd;
            array=sum(array);
            if array==19
                flag=0;
            end
        end
        counter=counter+1;
    end
        
    counter=counter-offset-1;
        
end

