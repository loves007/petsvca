function varargout = svca4_ClassGui(varargin)
% svca4_ClassGui MATLAB code for svca4_ClassGui.fig

% Edit the above text to modify the response to help svca4_ClassGui

% Last Modified by GUIDE v2.5 25-Jan-2017 16:27:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svca4_ClassGui_OpeningFcn, ...
    'gui_OutputFcn',  @svca4_ClassGui_OutputFcn, ...
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

% --- Executes just before svca4_ClassGui is made visible.
function svca4_ClassGui_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for svca4_ClassGui

handles.output = varargin{1};

% change max frame dropdown
tmp = load_nii_hdr(fullfile(handles.output.PET_dir,handles.output.PET_list{1}));
handles.max_frame.String = 1:tmp.dime.dim(5);
handles.max_frame.Value = handles.output.nFrames;

% change targets
handles.target_subs.String = num2str(handles.output.targetIDs);

% change targets
handles.blood_subs.String = num2str(handles.output.BLOOD_sel);

% change targets
handles.gmwm_subs.String = num2str(handles.output.GMWM_sel);

% change targets
handles.classSubs.String = num2str(handles.output.classIDs);

% change targets
handles.tspo_subs.String = num2str(handles.output.TSPO_sel);
% Update handles structuref
guidata(hObject, handles);

% UIWAIT makes svca4_ClassGui wait for user response (see UIRESUME)
%uiwait(handles.figure1);

global svca4


% --- Outputs from this function are returned to the command line.
function varargout = svca4_ClassGui_OutputFcn(hObject, eventdata, handles)
global svca4

varargout{1} = svca4;
%delete(handles.figure1);

% --- Executes on button press in out_path.
function out_path_Callback(hObject, eventdata, handles)
global svca4
if get(hObject,'Value') == 1
    svca4.outputPath = uigetdir('','Select the output PATH');
end
hObject.Value = 0;

% --- Executes on button press in PET_data.
function PET_data_Callback(hObject, eventdata, handles)
global svca4

if get(hObject,'Value') == 1
    [svca4.PET_list, svca4.PET_dir] = uigetfile({'*.nii','*.nii.gz'},'Select the PET data','MultiSelect','on');
end
hObject.Value = 0;

% --- Executes on button press in t1_data.
function t1_data_Callback(hObject, eventdata, handles)
global svca4

if get(hObject,'Value') == 1
    [svca4.MRI_list, svca4.MRI_dir] = uigetfile({'*.nii','*.nii.gz'},'Select MRI files','MultiSelect','on');
end
hObject.Value = 0;

% --- Executes on button press in brain_masks.
function brain_masks_Callback(hObject, eventdata, handles)
global svca4

if get(hObject,'Value') == 1
    [svca4.MASK_list, svca4.MASK_dir] = uigetfile({'*.nii','*.nii.gz'},'Select brain masks','MultiSelect','on');
end
hObject.Value = 0;

% --- Executes on button press in gmwm_masks.
function gmwm_masks_Callback(hObject, eventdata, handles)
global svca4

if get(hObject,'Value') == 1
    [svca4.SEG_list, svca4.SEG_dir] = uigetfile({'*.nii','*.nii.gz'},'Select segmented MRI files','MultiSelect','on');
end
hObject.Value = 0;

% --- Executes on button press in venous_masks.
function venous_masks_Callback(hObject, eventdata, handles)
global svca4

if get(hObject,'Value') == 1
    [svca4.BANANA_list svca4.BANANA_dir] = uigetfile({'*.nii','*.nii.gz'},'Select Venous sinus masks','MultiSelect','on');
end
hObject.Value = 0;

% --- Executes on button press in tspo_masks.
function tspo_masks_Callback(hObject, eventdata, handles)
global svca4

if get(hObject,'Value') == 1
    [svca4.INF_list, svca4.INF_dir] = uigetfile({'*.nii','*.nii.gz'},'Select TSPO masks','MultiSelect','on');
end
hObject.Value = 0;

% --- Executes on button press in time_data.
function time_data_Callback(hObject, eventdata, handles)
global svca4

if get(hObject,'Value') == 1
    [svca4.TIMES, svca4.TIMES_dir] = uigetfile({'*.txt'},'Select acquisition time files','MultiSelect','on');
end
hObject.Value = 0;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end

% --- Executes on selection change in max_frame.
function max_frame_Callback(hObject, eventdata, handles)
global svca4
contents = cellstr(get(hObject,'String'));
svca4.nFrames = str2num(contents{get(hObject,'Value')});

% --- Executes during object creation, after setting all properties.
function max_frame_CreateFcn(hObject, eventdata, handles,varargin)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function target_subs_Callback(hObject, eventdata, handles)
global svca4

svca4.targetIDs = str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function target_subs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function blood_subs_Callback(hObject, eventdata, handles)
global svca4

svca4.BLOOD_sel = str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function blood_subs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function gmwm_subs_Callback(hObject, eventdata, handles)
global svca4

svca4.GMWM_sel = str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function gmwm_subs_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tspo_subs_Callback(hObject, eventdata, handles)
global svca4

svca4.TSPO_sel = str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tspo_subs_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in calc.
function calc_Callback(hObject, eventdata, handles)
%global svca4 %not sure if this should be handles.output instead !!! Really need to clean this up in this code
global svca4
if get(hObject,'Value') == 1
    [TAC_TABLE] = svca4_calculate_classes(svca4);
    %[TAC_TABLE] = svca4_calculate_classes_yaqub(svca4);
    %figure1_CloseRequestFcn(gcbf, eventdata, handles)
end

% --- Executes on button press in save_svca4.
function save_svca4_Callback(hObject, eventdata, handles)
global svca4
uisave('svca4', 'svca4.mat')


function classSubs_Callback(hObject, eventdata, handles)
global svca4

svca4.classIDs = str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function classSubs_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
