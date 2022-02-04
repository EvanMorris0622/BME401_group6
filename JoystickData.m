clearvars
close all
clc 


%User Defined Properties 
a = arduino("/dev/cu.usbserial-D306ENP4", "Uno");  % define the Arduino Communication port



plotTitle = 'Arduino Data Log';  % plot title
xLabel = 'Elapsed Time (s)';     % x-axis label
yLabel = 'Positions (C)';      % y-axis label
legend1 = 'X'
legend2 = 'Y'

yMax  = 5;                           %y Maximum Value
yMin  = 0;                       %y minimum Value
plotGrid = 'on';                 % 'off' to turn off grid
min = 0;                         % set y-min
max = 5;                        % set y-max
delay = .001;                     % make sure sample faster than resolution 
%Define Function Variables
time = 0;
X = 0;
Y = 0;
count = 0;

%Set up Plot
f = figure;
ax1 = subplot(2,1,1);
plotGraph = plot(time,X,'-r', 'LineWidth',1.5);  % every AnalogRead needs to be on its own Plotgraph
hold on                            %hold on makes sure all of the channels are plotted
plotGraph1 = plot(time,Y,'-b', 'LineWidth',1.5);
title(plotTitle,'FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
legend(legend1,legend2);
axis([yMin yMax min max]);
grid(plotGrid);
tic;
stop = 1;
hold off

ax2 = subplot(2,1,2);
plotGraph_point = plot(X,Y,'.r', 'MarkerSize', 20);  % every AnalogRead needs to be on its own Plotgraph
xlabel('X-position','FontSize',15);
ylabel('Y-Position','FontSize',15);
title('Positioning Map','FontSize',15);
axis([0 6 0 6]);
grid(plotGrid);
hold off

sgtitle('Joystick Data');
pos = get(gcf, 'Position');
set(gcf, 'Position',pos+[0 -500 0 500]);

configurePin(a,'D7', 'DigitalOutput')
configurePin(a,'D6', 'DigitalInput')



while ishandle(f) %Loop when Plot is Active will run until plot is closed
% while stop==1
         x1 = a.readVoltage('A0'); %Data from the arduino
         y1 = a.readVoltage('A1');
%          btn = a.readDigitalPin('D6');
         
         r =  sqrt(((x1-2.5)^2 + (y1-2.5)^2));
         
         %%%threshold
         if r >1.25
             writeDigitalPin(a,'D13',1)
%              writeDigitalPin(a,'D7',1)
             a.writeDigitalPin('D3',1);
             a.readVoltage('A4')

             
         else
             writeDigitalPin(a,'D13',0)
%              writeDigitalPin(a,'D7',0)
             a.writeDigitalPin('D3',0);
%              a.readVoltage('A4')
          
         end  
         
         %%%check if live figure is still open
         if ~ishghandle(f)
            return
         end
        
%          if btn == 0
%             return
%          end 
         
         if y1>2.5513
             y1 = 2.5 - (y1-2.5);
         else 
             y1 = 2.5 + (2.5-y1);
         end
         
         count = count + 1;    
         time(count) = toc;    
         X(count) = x1(1);         
         Y(count) = y1(1);
%          axis([0 time(count) min max]);

         %This is the magic code 
         %Using plot will slow down the sampling time.. At times to over 20
         %seconds per sample!
         
         set(plotGraph,'XData',time,'YData',X);
         set(plotGraph1,'XData',time,'YData',Y);
%          xlim([0 time(count)]);
%          axis([0 time(count) min max]);

         ax1.XLim = [0 time(count)];
         ax1.YLim = [0 5];

         
         
         set(plotGraph_point, 'XData', x1, 'YData', y1);
         ax2.XLim = [0 5];
         ax2.YLim = [0 5];
      
%          set(plotGraph_point, 'XLim', [0 5]);
%          xlim([0 5]);
          %Update the graph
         pause(delay);
         
%          if readDigitalPin(a,'D7')==1
%              return
%          end
end
delete(a);
