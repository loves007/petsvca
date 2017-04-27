function varargout = svca4_imageTACGui(varargin)
% SVCA4_IMAGETACGUI MATLAB code for svca4_imageTACGui.fig
%      SVCA4_IMAGETACGUI, by itself, creates a new SVCA4_IMAGETACGUI or raises the existing
%      singleton*.
%
%      H = SVCA4_IMAGETACGUI returns the handle to a new SVCA4_IMAGETACGUI or the handle to
%      the existing singleton*.
%
%      SVCA4_IMAGETACGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVCA4_IMAGETACGUI.M with the given input arguments.
%
%      SVCA4_IMAGETACGUI('Property','Value',...) creates a new SVCA4_IMAGETACGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before svca4_imageTACGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to svca4_imageTACGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help svca4_imageTACGui

% Last Modified by GUIDE v2.5 29-Mar-2017 13:48:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svca4_imageTACGui_OpeningFcn, ...
    'gui_OutputFcn',  @svca4_imageTACGui_OutputFcn, ...
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


% --- Executes just before svca4_imageTACGui is made visible.
function svca4_imageTACGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to svca4_imageTACGui (see VARARGIN)

% Choose default command line output for svca4_imageTACGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes svca4_imageTACGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = svca4_imageTACGui_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

% --- Executes on button press in image.
function image_Callback(hObject, eventdata, handles)
global svca4
handles.imageF = uipickfiles('FilterSpec',svca4.outputPath,'Prompt','Select one binary mask image.');
guidata(hObject, handles);

% --- Executes on button press in pet.
function pet_Callback(hObject, eventdata, handles)
global svca4
handles.petF = uipickfiles('FilterSpec',svca4.PET_dir,'Prompt','Select corresponding PET data.');
guidata(hObject, handles);

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)

% --- Executes on button press in create.
function create_Callback(hObject, eventdata, handles)
global svca4
%handles.petF{1}
%handles.imageF{1}
%%% load PET image %%%
PET_struct = load_untouch_nii(handles.petF{1});
PET = single(PET_struct.img);

%%% load mask %%%
MASK_struct = load_untouch_nii(handles.imageF{1});
MASK = single(MASK_struct.img);

%%% if the image is not binary threshold at 95% %%%
%%% would be best to change or remove this %%%
q = quantile(MASK(MASK>0),.95)
if numel(unique(MASK))>2
    MASK(MASK<=q) = 0;
    MASK(MASK>=q) = 1;
end

for t=1:svca4.nFrames
    tmp = single(MASK).*PET(:,:,:,t);
    TAC(t) = mean(tmp(tmp~=0));
end
numel(find(MASK==1))
figure;set(gcf,'Color','w')
plot(svca4.PET_standardEndTimes,TAC)

if handles.save.Value
    myGRAY_TAC = [svca4.PET_standardStartTimes svca4.PET_standardEndTimes TAC'];
    fname = sprintf('%s/TACs/%s', svca4.outputPath,handles.name.String);
    fid = fopen(fname, 'w');
    fprintf(fid,'start[seconds]\tend[seconds]\tTAC[kBq/cc]\n');
    fprintf(fid,'%.1f\t%.1f\t%.4f\n', myGRAY_TAC');
    fclose(fid);
end

function name_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function name_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
