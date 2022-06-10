function acqGui = createGUI(s) 

acqGui.Fig = figure('Name','Joystick Data Acquisition GUI', ...
    'NumberTitle', 'off', 'Resize', 'off', ...
    'Toolbar', 'None', 'Menu', 'None',...
    'Position', [100 100 750 650]);
acqGui.Fig.DeleteFcn = {@endDAQ, s};
uiBackgroundColor = acqGui.Fig.Color; 


acqGui.Axes1 = axes; 
acqGui.LivePlot = plot(2.5,2.5); 
xlabel('X-position'); 
ylabel('Y-position'); 
xlim([0 5]);
ylim([0 5]);
title('Joystick Position') 
acqGui.Axes1.Units = 'Pixels'; 
acqGui.Axes1.Position = [207 391 488 196];
acqGui.Axes1.Toolbar.Visible = 'off'; 
disableDefaultInteractivity(acqGui.Axes1); 

% Create a stop acquisition button and configure a callback function
acqGui.DAQButton = uicontrol('style', 'pushbutton', 'string', 'Stop DAQ',...
    'units', 'pixels', 'position', [65 394 81 38]);
acqGui.DAQButton.Callback = {@endDAQ, s};


    function endDAQ(~,~,s) 
        if isvalid(s) 
            if s.Running
                stop(s); 
            end 
        end
    end 



end