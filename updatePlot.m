function updatePlot(xData,yData) 
    global plotgraph
    global min
    global max
    set(plotgraph, 'XData', xData, 'YData', yData); 
    drawnow;
    axis([min max min max]);
end 