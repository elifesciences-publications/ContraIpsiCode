function [ neuron_selected ] = extract_EMG_per( Data_str, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


    fields_all=fieldnames(Data_str.c3d);
    h=Data_str.c3d;
    field_cells_name=cell([0,0]);
    counter=1;
    for i=20:25
        test=fields_all{i,1};
%         if strcmp(test(1:5),'Neuro')
        if strcmp(test(1:4),'NS1_')
            field_cells_name(counter,1)=fields_all(i,1);
            counter=counter+1;
        end
    end
    neuron_numb=counter-1;
    




    file_index=[];
    numb_trials=length(Data_str.c3d);
    for i=1:numb_trials
        TP=Data_str.c3d(i).TRIAL.TP;
        EVENTS=Data_str.c3d(i).EVENTS;
        event_tri_type=EVENTS.LABELS{length(EVENTS.LABELS)-1};
        for j=1:length(varargin)
            if TP==varargin{j} 
                if strcmp('TRIAL_G',event_tri_type(1:7))
                    file_index=[file_index i];
                end

            end
        end
        
    end
    
    
    
    numb_files=length(file_index);
    pert_time=[];
    for i=1:numb_files
        curr_fil=file_index(i);
        EVENTS=Data_str.c3d(curr_fil).EVENTS;
        event_tri_type=EVENTS.LABELS{length(EVENTS.LABELS)-1};
        for j=1:length(EVENTS.LABELS)
            event_str=EVENTS.LABELS{j};
            if strcmp('PER',event_str(1:3)) 
                pert_time=[pert_time EVENTS.TIMES(j)*1000+5];
                break
            end
        end
    end
    
    
    
    
    neuron_selected=zeros(numb_files,neuron_numb,1101);
    for i=1:numb_files
        start_time=int32(pert_time(i)-400);
        end_time=int32(pert_time(i)+700);
        curr_file_index=file_index(i);

        for j=1:neuron_numb
            neuron_selected(i,j,:)=Data_str.c3d(curr_file_index).(field_cells_name{j})(start_time:end_time);
        end
    end
    
    
    
    

end

