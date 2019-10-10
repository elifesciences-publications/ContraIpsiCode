function [ind_sign ] = anova_each_cell( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    ind_sign=[];
    

    
    base_st=1;
    base_end=200;

    pert_st=201;
    pert_end=200+300;
    
   
%     for i=1:numb_days
%         convolved_H=convolved_H_all{i};
%         
    [contra_data,ipsi_data] = get_neuron_data_pert_epoch(data,0);
    numb_days=size(contra_data,1);
    for day=1:numb_days
        [~,numb_neurons,~]=size(contra_data{day,1});
        for neuron=1:numb_neurons
            base_contra=[];
            pert_contra=[];
            base_ipsi=[];
            pert_ipsi=[];
            for TP_numb=1:8
                temp_data_contra=squeeze(contra_data{day,TP_numb}(:,neuron,:));% data are trial by time points
                temp_data_ipsi=squeeze(ipsi_data{day,TP_numb}(:,neuron,:));% data are trial by time points
                base_contra=[base_contra,mean(temp_data_contra(:,base_st:base_end),2)];
                pert_contra=[pert_contra,mean(temp_data_contra(:,pert_st:pert_end),2)];
                base_ipsi=[base_ipsi,mean(temp_data_ipsi(:,base_st:base_end),2)];
                pert_ipsi=[pert_ipsi,mean(temp_data_ipsi(:,pert_st:pert_end),2)];
            end
            sign=ANOVA_analysis(base_contra,pert_contra,base_ipsi,pert_ipsi);
            ind_sign=[ind_sign sign];
        end
    end
    ind_sign=find(ind_sign==1);
end

                
           

function [sign]=ANOVA_analysis(base_contra,pert_contra,base_ipsi,pert_ipsi)
   %assume base_contra is trials x conditions
   trials=size(base_contra,1);
   full_data=[];
   label_dir=[];
   label_context=[];
   label_time=[];
   for TP_numb=1:8
       full_data=[full_data;base_contra(:,TP_numb)];
       full_data=[full_data;pert_contra(:,TP_numb)];
       full_data=[full_data;base_ipsi(:,TP_numb)];
       full_data=[full_data;pert_ipsi(:,TP_numb)];
       label_dir=[label_dir;zeros(trials*4,1)+TP_numb];
       label_context=[label_context;[zeros(trials*2,1);zeros(trials*2,1)+1]];
       label_time=[label_time;[zeros(trials,1);zeros(trials,1)+1;zeros(trials,1);zeros(trials,1)+1]];
   end
   
   [p,~,~]=anovan(full_data,{label_context,label_dir,label_time},'model','full','varnames',{'context','load direction','time'});
    close ALL hidden
    if p(3)<0.05 || p(5)<0.05 || p(6)<0.05 || p(7)<0.05 %index: 3=main time effect, 5=intrxn time with context, 6=intrxn time with load dir, 7=3way intrxn
        sign=1;
    else
        sign=0;
    end
       
        
        
end
