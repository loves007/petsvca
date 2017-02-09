function varargout = svca4_pathGui(varargin)
% SVCA4_PATHGUI MATLAB code for svca4_pathGui.fig
% NB: This is mainly a placeholder for the moment although it does allow to
% set the nifti_tools path. Should be modified to update the o structure
% with path details.

% Edit the above text to modify the response to help svca4_pathGui

% Last Modified by GUIDE v2.5 08-Dec-2016 15:02:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @svca4_pathGui_OpeningFcn, ...
                   'gui_OutputFcn',  @svca4_pathGui_OutputFcn, ...
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

% --- Executes just before svca4_pathGui is made visible.
function svca4_pathGui_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for svca4_pathGui
switch nargin
    case 1
        handles.output = varargin{1};
        
    otherwise 
        handles.output = hObject;
end

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = svca4_pathGui_OutputFcn(hObject, eventdata, handles) 
global svca4

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in nifti.
function nifti_Callback(hObject, eventdata, handles)
global svca4
niftipath = uigetdir('','Select the nifti_tools PATH');
addpath(niftipath)
hObject.Value = 0;

% --- Executes on button press in free_home.
function free_home_Callback(hObject, eventdata, handles)
global svca4
freehome = uigetdir('','Select the Freesurfer HOME directory (FREESURFER_HOME)');
svca4.FREESURFER_HOME = freehome;
hObject.Value = 0;

% --- Executes on button press in free_subj.
function free_subj_Callback(hObject, eventdata, handles)
global svca4
freepath = uigetdir('','Select the Freesurfer subjects directory (SUBJECTS_DIR)');
addpath(freepath)
svca4.SUBJECTS_DIR = freepath;
hObject.Value = 0;

% --- Executes on button press in itksnap_path.
function itksnap_path_Callback(hObject, eventdata, handles)
global svca4
itkpath = uigetdir('','Select the path to the ITK-SNAP app');
addpath(itkpath)
hObject.Value = 0;

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
global svca4
uisave({'svca4'}, 'svca4.mat')
