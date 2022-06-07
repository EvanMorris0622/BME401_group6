%% Initiate DAQ Session

clear all 
close all 
clc 

global s
s = daq.createSession('ni');

%%Inputs%%
addAnalogInputChannel(s,'Dev2',0,'Voltage'); %x joystick
addAnalogInputChannel(s,'Dev2',1,'Voltage'); %y joystick
addAnalogInputChannel(s,'Dev2',2,'Voltage'); %camera trigger pulse train 

%%Outputs%%
addAnalogOutputChannel(s,'Dev2',0,'Voltage'); %pump driver power
addDigitalChannel(s,'dev2','Port0/Line0:1', 'OutputOnly') %0 = il1, 1 = il2
%% Trial Specifications

global samplingR
global trial_time
global reward_length
global threshold
global refractory_periodL

s.Rate = 10000; %acquisition rate from DAQ
samplingR = s.Rate/4; %sampling rate 
trial_type = 1; %0=manual rewarding, 1=experimental trial
trial_time = 5;  %trial length, in seconds
reward_length   = 3;  %in seconds
threshold = 1.2; %min = 0, max = 2.5
refractory_periodL = 5; %in seconds

%% Variable Initialization

global scans_acquired %amount of data samples collected,
global alreadyQueued %reward delivery flag for next buffer of output data
global sampling_count %count of analysis callbacks
global task_completion %above/below-threshold flag
global running %pump activity flag
global reward_counter %duration passed in reward delivery, in seconds
global time %acquisition clock   
global sample_start %first analysis callback flag
global refractory_period %flag
global rperiod_count %duration elapsed in refractory period 

scans_acquired = 1;
alreadyQueued = false; %is reward queued for next delivery buffer
sampling_count = 0; %sampling_count*samplingR = time elapsed in sampling buffer
task_completion = false; %threshold state
running = false; %infusion pump state
reward_counter = 0; %number of seconds reward delivered
time = -1; %time counter for stopping acquisition
sample_start = false; %used for first sample storage
refractory_period = false; 
rperiod_count = 0;

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

stop_state_pulse(1:s.Rate,1:3) = 0;

%% Data Storage Variable

global raw_data
global sampled_data

raw_data = zeros(1,6); %raw data acquired at s.Rate
sampled_data = zeros(1,6); %sampled data


%% Visualization
global min 
global max 

plotTitle = 'Live Joystick Position'; 
xLabel = 'X'; 
yLabel = 'Y';
max = 5;
min = 0;

x = 2.5; 
y = 2.5;
xData = 0; 
yData = 0; 
count = 0; 

global plotgraph
plotgraph = plot(x,y,'b.','MarkerSize', 8); 
title(plotTitle, 'FontSize', 15); 
xlabel(xLabel, 'FontSize', 15);
ylabel(yLabel, 'FontSize', 15);
axis([min max min max]);

%% 
s.queueOutputData(off_state_pulse)

lh = s.addlistener('DataAvailable', @(src,event) analyzeSignal(src,event));
lh2 = s.addlistener('DataRequired',@(src,event) sendData(src,event));
s.NotifyWhenScansQueuedBelow =  s.Rate; %data required
s.NotifyWhenDataAvailableExceeds = samplingR; %data available

s.IsContinuous = true;
prepare(s)
% s.startBackground();

% while s.IsRunning
% 
%     switch(trial_type)
%         case 0 
% 
%         case 1
% %             pause(trial_time+1)
%             stop(s) 
%             disp(['Trial Ended at: ' num2str(trial_time) ' seconds'])
%             raw_data(1,:) = []; %remove first  row used to initialize table
%             saveData(raw_data,sampled_data, s.Rate)
%     end
% 
% end


delete(lh)
delete(lh2)



