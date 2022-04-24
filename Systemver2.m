%% Initiate DAQ Session

clear all 
close all 
clc 


s = daq.createSession('ni');

addAnalogInputChannel(s,'Dev2',0,'Voltage'); %x joystick
addAnalogInputChannel(s,'Dev2',1,'Voltage'); %y joystick

addAnalogOutputChannel(s,'Dev2',0,'Voltage'); %joystick power
addDigitalChannel(s,'dev2','Port0/Line0:1', 'OutputOnly') %0 = il1, 1 = il2
%% Trial Specifications

global samplingR
global trial_time
global reward_length
global threshold

s.Rate = 10000; % sampling rate of acquisition
samplingR = 1000; %sampling rate of callback function
trial_type = 1; %0=manual rewarding, 1=experimental trial
trial_time = 5;  %trial length, in seconds
reward_length   = 3;  %in seconds
threshold = 1.2;

%% Variable Initialization


global scans_acquired %amount of data samples collected,
global alreadyQueued 
global sampling_count 
global task_completion
global running
global reward_counter
global time  
global sample_start 

scans_acquired = 1;
alreadyQueued = false; %is reward queued for next delivery buffer
sampling_count = 0; %sampling_count*samplingR = time elapsed in sampling buffer
task_completion = false; %threshold state
running = false; %infusion pump state
reward_counter = 0; %number of seconds reward delivered
time = -1; %time counter for stopping acquisition
sample_start = false; %used for first sample storage

%% Pump Pulse States

global on_state_pulse
global off_state_pulse 
global stop_state_pulse

off_state_pulse(1:s.Rate, 1) = 0; %pump power
off_state_pulse(1:s.Rate,2) = 1; %digital pin (il1)
off_state_pulse(1:s.Rate,3) = 1; %digital pin (il2)

on_state_pulse(1:s.Rate,1)  = 5; %pump power
on_state_pulse(1:s.Rate,2) = 0;
on_state_pulse(1:s.Rate,3) = 1;

stop_state_pulse(1:s.Rate/2,1:3) = 0;

%% Pulse Visualization

% figure(1) 
% stem(on_state_pulse(:,1))
% hold on
% stem(off_state_pulse(:,1))
% legend('On-State', 'Off-State')
% xlabel('Time [s]')
% ylabel('Voltage [V]')
% hold off

%% Data Storage Variable

global raw_data
global sampled_data

raw_data = zeros(1,5); %raw data acquired at s.Rate
sampled_data = zeros(1,5); %sampled data


%% Acquisition System and Visualization

s.queueOutputData(off_state_pulse)

lh = s.addlistener('DataAvailable', @(src,event) analyzeSignal(src,event));
lh2 = s.addlistener('DataRequired',@(src,event) sendData(src,event));
s.NotifyWhenScansQueuedBelow =  s.Rate; %data required
s.NotifyWhenDataAvailableExceeds = samplingR; %data available

s.IsContinuous = true;
prepare(s)
s.startBackground();

while s.IsRunning

    switch(trial_type)
        case 0 

        case 1
            pause(trial_time+1)
            stop(s) 
            disp(['Trial Ended at: ' num2str(trial_time) ' seconds'])
            raw_data(1,:) = []; %remove first  row used to initialize table
            saveData(raw_data,sampled_data, s.Rate)
    end

end


delete(lh)
delete(lh2)
%% Storing Data at End of Run

function saveData(rawdata, sampleddata, rate)

    global trial_time
    global samplingR
    c = clock; 
    raw  = array2table(rawdata(1:trial_time*rate,:)); 
    sampled  = array2table(sampleddata(1:(trial_time*rate)/samplingR,:)); 
    

    raw.Properties.VariableNames(1:5) = {'Time (s)', 'X [V]', 'Y [V]', 'Radius [V]', 'Threshold Measured'};
    sampled.Properties.VariableNames(1:5) = {'Time (s)', 'X [V]', 'Y [V]', 'Radius [V]', 'Threshold Measured'};

    rawfilename = cat(1, "joystick_rawdata_", c(1:5)', ".csv");
    sampledfilename = cat(1, "joystick_sampleddata_", c(1:5)', ".csv");

    writetable(raw,string(strjoin(rawfilename)));
    writetable(sampled,string(strjoin(sampledfilename)));


end
%% Threshold Visualization

function [xp,yp] = circle(x,y,radius)
    ang=0:0.01:2*pi;
    xp = radius*cos(ang)+2.6;
    yp=radius*sin(ang)+2.8;
end
%% Send Output Signal to Pump

function sendData(src,evt)
    global on_state_pulse
    global off_state_pulse
    global stop_state_pulse
    global alreadyQueued
    global reward_counter
    global running
    global reward_length
    global trial_time
    global stop_bool
    global time
    
    time  = time+1;
    disp(time)

    if(reward_counter == reward_length)
        disp('Enter reward = reward length')
        running = false; 
        reward_counter = 0; 
    end

    disp(['Reward Counter: ' num2str(reward_counter)])

    switch(running)
        case true
            disp('On')
            if(time == trial_time)
                src.queueOutputData(stop_state_pulse);
                disp('Stop Trigger Sent')
%                 flush(s)
                stop_bool = true;
            else
                src.queueOutputData(on_state_pulse);
                reward_counter = reward_counter + 1;
            end

            
        case false
            switch(alreadyQueued)
                case true
                if(time == trial_time)
                    src.queueOutputData(stop_state_pulse);
                    disp('Stop Trigger Sent')
%                     flush(s)
                    stop_bool = true;
                else
                    disp('On')
                    running = true;
                    src.queueOutputData(on_state_pulse);  
                    reward_counter = reward_counter + 1;
                end

                case false
                    disp('Off')
                    src.queueOutputData(off_state_pulse)
            end
    end

end

%% Sampling Analysis

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

    r = sqrt(((evt.Data(:,1)).^2 + (evt.Data(:,2)).^2));
    avg_ext = mean(r)- sqrt(2.6^2 + 2.8^2);      
    
    if(sampling_count == src.Rate/samplingR)
        sampling_count = 0; 
        alreadyQueued = false; 
    end 

    disp(avg_ext)
    disp(['Sampling Counter: ' num2str(sampling_count)])
    
    
    if(avg_ext<=threshold || avg_ext>=2.6-threshold)
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
        
        raw_data = cat(1,raw_data, cat(2,evt.TimeStamps, evt.Data(:,1),evt.Data(:,2),r,temp_trigger));
        
        if(~sample_start)
            sampled_data = cat(2,evt.TimeStamps(1),mean(evt.Data(:,1)),mean(evt.Data(:,2)),avg_ext,task_completion);
            sample_start = true;
        else
            sampled_data = cat(1,sampled_data, cat(2,evt.TimeStamps(end),mean(evt.Data(:,1)),mean(evt.Data(:,2)),avg_ext,task_completion));
        end

       
        disp(scans_acquired)
        scans_acquired = scans_acquired + 1; 
        
        figure(1)
        [circx, circy] = circle(2.6,2.8,threshold);
        plot(circx,circy, 'b')
        hold on
        plot(mean(evt.Data(:,1)),mean(evt.Data(:,2)),'.r','MarkerSize',20)
        ylim([0 5.3]) 
        xlim([0 5.1])
        hold off
        
end
