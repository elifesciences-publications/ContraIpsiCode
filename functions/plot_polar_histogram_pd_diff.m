function [r,theta] = plot_polar_histogram_pd_diff(pds,color)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%     numb_in_bins=histcounts(pds,16);
    
    t=linspace(0,2*pi);
    r=0.5;
    x=r*cos(t);
    y=r*sin(t);

    for i=1:16
        ang_upp=360*(i)/16-180;
        ang_low=360*(i-1)/16-180;
%         ang_upp=mod(360*(i+0.5)/16,360);
%         ang_low=mod(360*(i-0.5)/16,360);
        ang=360*(i-0.5)/16-180;
        
        numb_upp=length(find(pds<ang_upp));
        numb_low=length(find(pds<ang_low));
        
        numb_in_bins=numb_upp-numb_low;
        
        if numb_in_bins>0
            for j=1:numb_in_bins
                plot(x+(j+2)*r*2*cos(ang*pi/180),y+(j+2)*r*2*sin(ang*pi/180),color)
            end
        end
    end
    

    
    
    numb_neuron=size(pds,2);
    rcos=sum(cos(pds*pi/180));
    rsin=sum(sin(pds*pi/180));
    r=sqrt(rcos^2+rsin^2)/numb_neuron;
    theta=atan(rsin/rcos)*180/pi;
    if rsin<0 && rcos<0
        theta=theta+180;
    end
    if rcos<0 && rsin>0
        theta=theta+180;
    end



end
        
