function [counter] = peak_activity_function(time_series,offset)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    t_pts=size(time_series,2);
    peak_onset=max(time_series(1,offset:end));
    
    upp_bd=peak_onset*0.1;
    
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
        
        counter=counter+1;
    end
        
    counter=counter-offset-1;
        
end

