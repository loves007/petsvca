function varargout = svca4_compareTacsGui(varargin)
% SVCA4_COMPARETACSGUI MATLAB code for svca4_compareTacsGui.fig
%      SVCA4_COMPARETACSGUI, by itself, creates a new SVCA4_COMPARETACSGUI or raises the existing
%      singleton*.
%
%      H = SVCA4_COMPARETACSGUI returns the handle to a new SVCA4_COMPARETACSGUI or the handle to
%      the existing singleton*.
%
%      SVCA4_COMPARETACSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVCA4_COMPARETACSGUI.M with the given input arguments.
%
%      SVCA4_COMPARETACSGUI('Property','Value',...) creates a new SVCA4_COMPARETACSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before svca4_compareTacsGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to svca4_compareTacsGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help svca4_compareTacsGui

% Last Modified by GUIDE v2.5 23-Jan-2017 16:05:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @svca4_compareTacsGui_OpeningFcn, ...
                   'gui_OutputFcn',  @svca4_compareTacsGui_OutputFcn, ...
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


% --- Executes just before svca4_compareTacsGui is made visible.
function svca4_compareTacsGui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global svca4
handles.subs.String = svca4.Names;

% --- Outputs from this function are returned to the command line.
function varargout = svca4_compareTacsGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function TAC1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function TAC1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TAC2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function TAC2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in subs.
function subs_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function subs_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compare.
function compare_Callback(hObject, eventdata, handles)
global svca4

T1 = handles.TAC1.String;
T2 = handles.TAC2.String;

for s = handles.subs.Value
    tac1name = fullfile(svca4.outputPath,'TACs',[svca4.Names{handles.subs.Value(s)} '_' T1])
    tacTable = readtable(tac1name);
    tac1(s,:) = tacTable.TAC_kBq_cc_;
    
    tac2name = fullfile(svca4.outputPath,'TACs',[svca4.Names{handles.subs.Value(s)} '_' T2])
    tacTable = readtable(tac2name);
    tac2(s,:) = tacTable.TAC_kBq_cc_;
    
    diffTac(s,:) = tac1(s,:) - tac2(s,:);
end
figure;
plot(svca4.PET_standardEndTimes,mean(tac1));hold on
plot(svca4.PET_standardEndTimes,mean(tac2));
plot(svca4.PET_standardEndTimes,mean(diffTac))

% --- Executes on button press in meanDiff.
function meanDiff_Callback(hObject, eventdata, handles)

