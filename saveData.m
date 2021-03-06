function saveData(rawdata, sampleddata, rate)
    global raw_data
    global sampled_data
    
    c = clock; 
    raw_data(1,:) = [];
    begin_raw_idx = find(raw_data(:,6)>0, 'first'); 
    end_raw_idx = find(raw_data(:,6)>0, 'last'); 
    
    begin_sampled_idx = find(sampled_data(:,6), 'first'); 
    end_sampled_idx = find(sampled_data(:,6), 'last'); 
    

%     raw  = array2table(rawdata(1:trial_time*rate,:)); 
%     sampled  = array2table(sampleddata(1:(trial_time*rate)/samplingR,:)); 
    
    raw  = array2table(raw_data(begin_raw_idx:end_raw_idx,:)); 
    sampled  = array2table(sampled_data(begin_sampled_idx:end_sampled_idx,:)); 

    raw.Properties.VariableNames(1:6) = {'Time (s)', 'X [V]', 'Y [V]', 'Radius [V]', 'Threshold Measured', 'Trigger Pulse'};
    sampled.Properties.VariableNames(1:6) = {'Time (s)', 'X [V]', 'Y [V]', 'Radius [V]', 'Threshold Measured', 'Trigger Pulse'};

    rawfilename = strrep(strjoin(cat(1, "joystick_rawdata_", c(1:5)', ".csv")), ' ' , '_'); %saved file name 
    sampledfilename = strrep(strjoin(cat(1, "joystick_sampleddata_", c(1:5)', ".csv")), ' ' , '_'); %saved file name 

    raw_path = fullfile([pwd '\Data'], rawfilename);
    sampled_path = fullfile([pwd '\Data'], sampledfilename); 
    
    writetable(raw,raw_path);
    writetable(sampled,sampled_path);
end
