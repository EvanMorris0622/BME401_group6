function joystickTest
global a
global min; global max;
global t 

a = arduino('COM3', 'Uno'); 
on = true; 
max = 5;
min = 0;
sampling_rate = 250; 
current_time = 0; 

plotTitle = 'Live Joystick Position'; 
xLabel = 'X'; 
yLabel = 'Y';
delay = 0.25; 

tStart = tic; 
while(on)
    val = toc(tStart);
    if(val>=current_time)
        current_time = current_time + sampling_rate; 
        x = readVoltage(a,'A1'); y = readVoltage(a,'A0');
        disp("Time" + string(val));
        
    end

end 

disp('End Acquisition') 
clear a 

% while ishandle(plotgraph)
    
%     r = sqrt(((x-2.5).^2 + (y-2.5).^2));
%     t = toc(start);
%     count = count+1; 
%     time(count) = toc; 
%     xData(count) = x; 
%     yData(count) = y; 
    
%     disp('Time: ' + string(t));
%     disp('X: ' + string(x));
%     disp('Y: ' + string(y));
%     disp('R: ' + string(r));
%     disp('------------');
% 
%     
%     set(plotgraph, 'XData', x, 'YData', y); 
%     drawnow;
%     axis([min max min max]);
%     setPlotData(x,y)
%     pause(delay);
    
end

% function setPlotData(xData, yData)
%     global plotgraph
%     global min
%     global max
%     set(plotgraph, 'XData', xData, 'YData', yData); 
%     drawnow;
%     axis([min max min max]);
% 
% end
