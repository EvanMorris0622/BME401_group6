function varargout = acquisitionGUI(varargin)
% ACQUISITIONGUI MATLAB code for acquisitionGUI.fig
%      ACQUISITIONGUI, by itself, creates a new ACQUISITIONGUI or raises the existing
%      singleton*.
%
%      H = ACQUISITIONGUI returns the handle to a new ACQUISITIONGUI or the handle to
%      the existing singleton*.
%
%      ACQUISITIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACQUISITIONGUI.M with the given input arguments.
%
%      ACQUISITIONGUI('Property','Value',...) creates a new ACQUISITIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before acquisitionGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to acquisitionGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help acquisitionGUI

% Last Modified by GUIDE v2.5 08-Jun-2022 15:29:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @acquisitionGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @acquisitionGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before acquisitionGUI is made visible.
function acquisitionGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to acquisitionGUI (see VARARGIN)

% Choose default command line output for acquisitionGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes acquisitionGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% clear arduino_object 
% handles.board = arduino();



% --- Outputs from this function are returned to the command line.
function varargout = acquisitionGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_PB.
function start_PB_Callback(hObject, eventdata, handles)
% hObject    handle to start_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global a 
    a = arduino('COM3', 'Uno'); 


% --- Executes on button press in stop_PB.
function stop_PB_Callback(hObject, eventdata, handles)
% hObject    handle to stop_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a
clear a 
