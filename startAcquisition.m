function startAcquisition(src, event)
%     global s 
%     s.startBackground();

disp('Acquisition Begun')

global a 
a = arduino('COM3', 'Uno');

joystickTest();

end