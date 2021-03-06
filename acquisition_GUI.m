function acquisition_GUI
       clear 
       close all 
       clc
%        global a
%        a = arduino('COM3', 'Uno'); 
       
%     f = uifigure; 
%     ax = axes(f); 
%     ax.Units = 'pixels'; 
%     ax.Position = [75 75 325 280]; 
%     
%     btn = uibuttongroup('Visible', 'off',...
%                         'Position',[0 0 0.2 1],...
%                         'Selection
%     start = uicontrol; 
%     start.String = 'START'; 
%     start.Callback = @startAcquisition; 
%     
%     stop = uicontrol; 
%     stop.String = 'STOP'; 
%     stop.Callback = @stopAcquisition; 
%     
%     
    fig = uifigure; 
    fig.Name = "Data Acquisition GUI";
    
    gl = uigridlayout(fig, [2 2]); 
    gl.RowHeight = {30, '1x'}; 
    
    start = uibutton(gl, 'push',...
                     'BackgroundColor', [0.4660 0.6740 0.1880],...
                     'Text', 'START',...
                     'FontWeight', 'bold',...
                     'FontColor', 'white',...
                     'FontSize', 14,...
                     'FontName', 'Arial',...
                     'ButtonPushedFcn', @(btn,event) startAcquisition); 
                 
    stop = uibutton(gl, 'push',...
                     'BackgroundColor', [0.6350 0.0780 0.1840],...
                     'Text', 'STOP',...
                     'FontWeight', 'bold',...
                     'FontColor', 'white',...
                     'FontSize', 14,...
                     'FontName', 'Arial',...
                     'ButtonPushedFcn', @(btn,event) stopAcquisition); 
%     start.Text = "START";
%     start.BackgroundColor = [0.4660 0.6740 0.1880];
%     stop = uibutton(gl); 
%     stop.Text = "STOP"; 
%     stop.BackgroundColor = ;
    
    start.Layout.Row = 1;
    start.Layout.Column = 1;
    stop.Layout.Row = 1;
    stop.Layout.Column = 2;
    
    
end