function varargout = svca4_dispGui(varargin)
% SVCA4_DISPGUI MATLAB code for svca4_dispGui.fig
% Display a results class file as an overlay on the T1 and PET data.
% NB: change this to use Freeview!!!

% Last Modified by GUIDE v2.5 12-Oct-2016 12:17:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svca4_dispGui_OpeningFcn, ...
    'gui_OutputFcn',  @svca4_dispGui_OutputFcn, ...
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

% --- Executes just before svca4_dispGui is made visible.
function svca4_dispGui_OpeningFcn(hObject, eventdata, handles, varargin)

global svca4
handles.subj.String = 1:length(svca4.targetIDs);

% Choose default command line output for svca4_dispGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = svca4_dispGui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in subj.
function subj_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function subj_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in display.
function display_Callback(hObject, eventdata, handles)

global svca4
global class_index
popup_sel_index = get(handles.subj, 'Value');
iteration_index = get(handles.iteration, 'Value');
class_index = get(handles.class, 'Value');

switch class_index
    case 1
        class_file = fullfile(svca4.outputPath,['TARGET_' sprintf('%.2d', popup_sel_index) '_BLOOD_it' sprintf('%.2d', iteration_index) '.nii']);
    case 2
        class_file = fullfile(svca4.outputPath,['TARGET_' sprintf('%.2d', popup_sel_index) '_GRAY_it' sprintf('%.2d', iteration_index) '.nii']);
    case 3
        class_file = fullfile(svca4.outputPath,['TARGET_' sprintf('%.2d', popup_sel_index) '_WHITE_it' sprintf('%.2d', iteration_index) '.nii']);
    case 4
        class_file = fullfile(svca4.outputPath,['TARGET_' sprintf('%.2d', popup_sel_index) '_TSPO_it' sprintf('%.2d', iteration_index) '.nii']);
end
irm = fullfile(svca4.MRI_dir,svca4.MRI_list{popup_sel_index});
%pet = fullfile(svca4.PET_dir,svca4.PET_list{popup_sel_index});

cmd = ['source ${HOME}/.profile; /usr/local/bin/itksnap -g ' irm ' -o ' class_file];
disp(cmd)
system(cmd)

% --- Executes on selection change in class.
function class_Callback(hObject, eventdata, handles)
global class_index
class_index = get(handles.class, 'Value');

% --- Executes during object creation, after setting all properties.
function class_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in iteration.
function iteration_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function iteration_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
