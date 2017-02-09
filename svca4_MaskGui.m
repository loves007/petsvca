function varargout = svca4_MaskGui(varargin)
% SVCA4_MASKGUI MATLAB code for svca4_MaskGui.fig
%      SVCA4_MASKGUI, by itself, creates a new SVCA4_MASKGUI or raises the existing
%      singleton*.
%
%      H = SVCA4_MASKGUI returns the handle to a new SVCA4_MASKGUI or the handle to
%      the existing singleton*.
%
%      SVCA4_MASKGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVCA4_MASKGUI.M with the given input arguments.
%
%      SVCA4_MASKGUI('Property','Value',...) creates a new SVCA4_MASKGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before svca4_MaskGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to svca4_MaskGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help svca4_MaskGui

% Last Modified by GUIDE v2.5 14-Dec-2016 10:14:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @svca4_MaskGui_OpeningFcn, ...
                   'gui_OutputFcn',  @svca4_MaskGui_OutputFcn, ...
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


% --- Executes just before svca4_MaskGui is made visible.
function svca4_MaskGui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = svca4_MaskGui_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on selection change in subs.
function subs_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function subs_CreateFcn(hObject, eventdata, handles)
global svca4
dr = dir(svca4.SUBJECTS_DIR);
dr(1:2) = [];
drFlags = [dr.isdir];

set(hObject,'String',{dr(drFlags).name});
set(hObject,'Max',length(svca4.PET_list));

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in rois.
function rois_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function rois_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in createMask.
function createMask_Callback(hObject, eventdata, handles)
global svca4
setenv('PATH', [getenv('PATH') ':/usr/local/bin']);
if ~exist([svca4.outputPath '/roiMasks'],'dir')
    mkdir([svca4.outputPath '/roiMasks'])
end
subj = handles.subs.String(handles.subs.Value);

outRoiNums = cellfun(@strtok, handles.rois.String(handles.rois.Value),'UniformOutput',false);
outRoiNums = cellfun(@str2num,outRoiNums,'UniformOutput',false);
outRoiNums = [outRoiNums{:}];
zs = zeros(size(outRoiNums));

changeVec = [outRoiNums; zs];
changeVec = changeVec(:)';

inds = handles.subs.Value; % indices to the subjects
for s = 1:length(handles.subs.Value) % loop on subjects
    % this will use the c3d commands that come with itksnap. You may have
    % problems with the path to this command. Put the c3d executable in a
    % folder in the computers $PATH. See the setenv call above, you may
    % need to change /usr/local/bin for example. Basically make the c3d
    % executable visible to the terminal MATLAB calls.
    roiFile = fullfile(svca4.SUBJECTS_DIR, subj{s}, 'label', [subj{s} '_AparcAseg_in_PET.nii.gz']);
    outFile = fullfile(svca4.outputPath, 'roiMasks', [subj{s} '_' handles.outName.String]);
    cmd = ['source ${HOME}/.profile; c3d ' roiFile ' -replace ' num2str(changeVec) ' -binarize -o ' outFile];
    system(cmd);
end

function outName_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function outName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
