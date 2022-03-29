dq = daq("ni");
dq.Rate = 10000;
duration = 10; %trial time, in seconds

threshold; % threshold radius for switch  

addinput(dq,"Dev2","ai0","Voltage")
addinput(dq,"Dev2","ai1","Voltage")
addoutput(dq,"Dev2","ao1","Voltage")

% continuous 5V output for joystick
v_out = zeros(2, dq.Rate*duration); 
v_out(1,:) = 5; %fill with appropriate voltage value %%%% will need to make multiple columns for multiple output channels  


% preload(dq, signalData')
% start(d,"NumScans",dq.Rate*duration)  % continuous writing 5V to the joystick for power supply

start(d,"Duration",seconds(5))
    
inData = read(d,"all")

write(d,v_out') 

scanData = read(d,dq.Rate*duration);

x = scanData(end)(); %live x-position  %%%%%
y  = scanData(end)(); %live y-position %%%%%

r_square = x^2 * y^2; 
active_radius = sqrt(r_square); 

if (active_radius> threshold) 
   state = 'sub'; 
end

switch(state)  
    case 'sub'
        %leave empty to do nothing
    case 'above'
        v
        %do something 
        
        state  = 'sub'; %bring state  back to sub after reward 
        
end

%% 

% preload(dq,v_out); %background output of 5 V
% start(dq, "repeatoutput")

% j_data = readwrite(dq,v_out); %simultaneously read in joystick and output power to it

% [inScanData,timeStamp,triggerTime] = readwrite(dq,"OutputFormat","Matrix");
% %read data
% j_data = read(dq,4000);

% preload(d,v_out') % Column of data for one channel
% start(dq,"RepeatOutput")
% 
% scanData = read(d,"all")
