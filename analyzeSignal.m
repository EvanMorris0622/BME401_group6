function analyzeSignal(src,evt)
    global scans_acquired
    global samplingR
    global threshold
    global raw_data
    global sampled_data
    global alreadyQueued
    global sampling_count
    global sample_start
    global task_completion

    r = sqrt((((evt.Data(end,1))-2.5).^2 + ((evt.Data(end,2))-2.5).^2));
%     avg_ext = mean(r)- sqrt(2.6^2 + 2.8^2);

    if(sampling_count == src.Rate/samplingR)
        sampling_count = 0; 
        alreadyQueued = false; 
    end 

%     disp(avg_ext)
    disp(['Sampling Counter: ' num2str(sampling_count)])
    
    
%     if(avg_ext<=threshold || avg_ext>=2.6-threshold)
    if(r>=threshold)
        task_completion = true;
    else
        task_completion = false;
    end

    temp_trigger = zeros(samplingR,1);

    switch(task_completion)
        case true
            disp('Successful Scan')
            switch(alreadyQueued)
                case true
                    disp('Already Queued')
                    %do nothing

                case false
                    disp('Not Already Queued')
                    alreadyQueued = true;    
            end

        case false
            %do nothing    
            disp('Unsuccessful Scan')
            temp_trigger(1:samplingR) = 0;
    end
            
            
    
        sampling_count = sampling_count + 1; 
        
        raw_data = cat(1,raw_data, cat(2,evt.TimeStamps, evt.Data(:,1),evt.Data(:,2),r,temp_trigger, evt.Data(:,3)));
        
        if(~sample_start)
%             sampled_data = cat(2,evt.TimeStamps(1),mean(evt.Data(:,1)),mean(evt.Data(:,2)),r,task_completion);
            sampled_data = cat(2,evt.TimeStamps(1),evt.Data(end,1),evt.Data(end,2),r,task_completion);

            sample_start = true;
        else
            sampled_data = cat(1,sampled_data, cat(2,evt.TimeStamps(end),mean(evt.Data(:,1)),mean(evt.Data(:,2)),r,task_completion));
        end

        %%%Update Plot 
        updatePlot(evt.Data(end,1), evt.Data(end,2))
        
        disp(scans_acquired)
        scans_acquired = scans_acquired + 1; 

%         
end