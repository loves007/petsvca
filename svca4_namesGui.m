function varargout = svca4_namesGui(varargin)
% SVCA4_NAMESGUI MATLAB code for svca4_namesGui.fig
%      SVCA4_NAMESGUI, by itself, creates a new SVCA4_NAMESGUI or raises the existing
%      singleton*.
%
%      H = SVCA4_NAMESGUI returns the handle to a new SVCA4_NAMESGUI or the handle to
%      the existing singleton*.
%
%      SVCA4_NAMESGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVCA4_NAMESGUI.M with the given input arguments.
%
%      SVCA4_NAMESGUI('Property','Value',...) creates a new SVCA4_NAMESGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before svca4_namesGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to svca4_namesGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help svca4_namesGui

% Last Modified by GUIDE v2.5 12-Jan-2017 10:17:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @svca4_namesGui_OpeningFcn, ...
                   'gui_OutputFcn',  @svca4_namesGui_OutputFcn, ...
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


% --- Executes just before svca4_namesGui is made visible.
function svca4_namesGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to svca4_namesGui (see VARARGIN)
global svca4

% Choose default command line output for svca4_namesGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if isfield(svca4,'Names')
    handles.uitable1.Data = svca4.Names;
else handles.uitable1.Data = cell(length(svca4.PET_list),1);
end
handles.uitable1.ColumnWidth = {200};
handles.uitable2.Data = svca4.PET_list';
handles.uitable2.ColumnWidth = {400};

% --- Outputs from this function are returned to the command line.
function varargout = svca4_namesGui_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in index.
function index_Callback(hObject, eventdata, handles)
global svca4

B = cellfun(@(x) x(str2num(handles.start.String):str2num(handles.finish.String)), svca4.PET_list, 'un', 0);
handles.uitable1.Data = B';

function start_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function start_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function finish_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function finish_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in saveNames.
function saveNames_Callback(hObject, eventdata, handles)
global svca4
svca4.Names = handles.uitable1.Data;

uisave('svca4','svca4')