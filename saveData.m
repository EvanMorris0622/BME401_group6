function saveData(rawdata, sampleddata, rate)
    global trial_time
    global samplingR
    c = clock; 
    raw  = array2table(rawdata(1:trial_time*rate,:)); 
    sampled  = array2table(sampleddata(1:(trial_time*rate)/samplingR,:)); 

    raw.Properties.VariableNames(1:6) = {'Time (s)', 'X [V]', 'Y [V]', 'Radius [V]', 'Threshold Measured', 'Trigger Pulse'};
    sampled.Properties.VariableNames(1:6) = {'Time (s)', 'X [V]', 'Y [V]', 'Radius [V]', 'Threshold Measured', 'Trigger Pulse'};

    rawfilename = cat(1, "joystick_rawdata_", c(1:6)', ".csv"); %saved file name 
    sampledfilename = cat(1, "joystick_sampleddata_", c(1:6)', ".csv"); %saved file name 

    writetable(raw,string(strjoin(rawfilename)));
    writetable(sampled,string(strjoin(sampledfilename)));
end