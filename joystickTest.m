function joystickTest
global a
global min; global max;
max = 5;
min = 0;

while(true)
x = readVoltage(a,'A1'); y = readVoltage(a,'A0');
plotTitle = 'Live Joystick Position'; 
xLabel = 'X'; 
yLabel = 'Y';
delay = 0.25; 




% while ishandle(plotgraph)
    
    r = sqrt(((x-2.5).^2 + (y-2.5).^2));
%     t = toc(start);
%     count = count+1; 
%     time(count) = toc; 
%     xData(count) = x; 
%     yData(count) = y; 
    
%     disp('Time: ' + string(t));
    disp('X: ' + string(x));
    disp('Y: ' + string(y));
    disp('R: ' + string(r));
    disp('------------');
% 
%     
%     set(plotgraph, 'XData', x, 'YData', y); 
%     drawnow;
%     axis([min max min max]);
%     setPlotData(x,y)
    pause(delay);
    
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
end