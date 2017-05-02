function varargout = svca4_voiTACGui(varargin)
% SVCA4_VOITACGUI MATLAB code for svca4_voiTACGui.fig
%      SVCA4_VOITACGUI, by itself, creates a new SVCA4_VOITACGUI or raises the existing
%      singleton*.
%
%      H = SVCA4_VOITACGUI returns the handle to a new SVCA4_VOITACGUI or the handle to
%      the existing singleton*.
%
%      SVCA4_VOITACGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVCA4_VOITACGUI.M with the given input arguments.
%
%      SVCA4_VOITACGUI('Property','Value',...) creates a new SVCA4_VOITACGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before svca4_voiTACGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to svca4_voiTACGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help svca4_voiTACGui

% Last Modified by GUIDE v2.5 12-Jan-2017 14:59:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svca4_voiTACGui_OpeningFcn, ...
    'gui_OutputFcn',  @svca4_voiTACGui_OutputFcn, ...
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


% --- Executes just before svca4_voiTACGui is made visible.
function svca4_voiTACGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to svca4_voiTACGui (see VARARGIN)

% Choose default command line output for svca4_voiTACGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes svca4_voiTACGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = svca4_voiTACGui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
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

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in vois_txt.
function vois_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function vois_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function vois_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in norm.
function norm_Callback(hObject, eventdata, handles)


% --- Executes on button press in save_txt.
function save_txt_Callback(hObject, eventdata, handles)


function txt_name_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function txt_name_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in create_TAC.
function create_TAC_Callback(hObject, eventdata, handles)
global svca4
subj = handles.subs.String(handles.subs.Value);
voiNums = cellfun(@strtok, handles.vois.String(handles.vois.Value),'UniformOutput',false);
voiNums = cellfun(@str2num,voiNums,'UniformOutput',false);
voiNums = [voiNums{:}];

inds = handles.subs.Value; % indices to the subjects
for s = 1:length(handles.subs.Value) % loop on subjects
    
    %%% load segmentation image %%%
    SEG_struct = load_untouch_nii(fullfile(svca4.SUBJECTS_DIR, subj{s}, 'label', [subj{s} '_AparcAseg_in_PET.nii.gz']));
    SEG = single(SEG_struct.img);
    clear SEG_Struct
    indsVOI = ismember(SEG,voiNums);
    
    %%% load PET image %%%
    tt = strfind(svca4.Names,subj{s});
    Index = find(not(cellfun('isempty', tt)));
    PET_struct = load_untouch_nii(fullfile(svca4.PET_dir, svca4.PET_list{Index}));
    PET = single(PET_struct.img);
    svca4.Res = PET_struct.hdr.dime.pixdim([2 4 3]); %
    xDim = size(PET,1);
    yDim = size(PET,2);
    zDim = size(PET,3);
    clear PET_struct;
    
    switch handles.norm.Value
        case 0
            for t=1:svca4.nFrames
                PET_t = PET(:,:,:,t);
                vals(s,t)  = mean(PET_t(indsVOI));
            end
            if handles.save_txt.Value
                myGRAY_TAC = [svca4.PET_standardStartTimes svca4.PET_standardEndTimes vals(s,:)'];
                fname = sprintf('%s/TACs/%s_%s', svca4.outputPath, subj{s},handles.txt_name.String);
                fid = fopen(fname, 'w');
                fprintf(fid,'start[seconds]\tend[seconds]\tTAC[1/1]\n');
                fprintf(fid,'%.1f\t%.1f\t%.4f\n', myGRAY_TAC');
                fclose(fid);
            end
            %%%% testing - to be removed %%%%
%             plotInds = zeros(xDim,yDim,zDim);
%             plotInds(find(indsVOI)) = 1;
%             close all;
%             figure;
%             image(squeeze(PET(:,:,45,18))); hold on
%             im = imagesc(squeeze(plotInds(:,:,45))*100);im.AlphaData = .5;
            %%%% end %%%%
        case 1
            %%% load brain mask %%%
            MASK_struct = load_untouch_nii(fullfile(svca4.MASK_dir, svca4.MASK_list{s}));
            MASK = single(MASK_struct.img);
            clear MASK_struct
            
            indMASK = find(MASK==1);
            for t=1:svca4.nFrames
                PET_t = PET(:,:,:,t);
                nvals  = PET_t(indMASK) - mean(PET_t(indMASK));
                nvals = nvals/std(nvals(:));
                PET_t_norm = zeros(size(PET_t));
                PET_t_norm(indMASK) = nvals;
                vals(s,t)  = mean(PET_t_norm(indsVOI));
            end
            
            if handles.save_txt.Value
                myGRAY_TAC = [svca4.PET_standardStartTimes svca4.PET_standardEndTimes vals(s,:)'];
                fname = sprintf('%s/TACs/Norm_%s_%s', svca4.outputPath, subj{s},handles.txt_name.String);
                fid = fopen(fname, 'w');
                fprintf(fid,'start[seconds]\tend[seconds]\tTAC[1/1]\n');
                fprintf(fid,'%.1f\t%.1f\t%.4f\n', myGRAY_TAC');
                fclose(fid);
            end
    end
end

axes(handles.axes1);
cla
if size(vals) > 1
    plot(svca4.PET_standardEndTimes,mean(vals),'LineWidth',2)
    title('Mean VOI TAC')
    if handles.meanTAC.Value == 1
        myGRAY_TAC = [svca4.PET_standardStartTimes svca4.PET_standardEndTimes mean(vals)'];
        if handles.norm.Value
            fname = sprintf('%s/TACs/%s_%s', svca4.outputPath, 'Norm_mean',handles.txt_name.String);
        else fname = sprintf('%s/TACs/%s_%s', svca4.outputPath, 'mean',handles.txt_name.String);
        end
        fid = fopen(fname, 'w');
        fprintf(fid,'start[seconds]\tend[seconds]\tTAC[1/1]\n');
        fprintf(fid,'%.1f\t%.1f\t%.4f\n', myGRAY_TAC');
        fclose(fid);
        handles.meanTAC.Value = 0;
    end
    
else plot(svca4.PET_standardEndTimes,vals,'LineWidth',2)
    title('VOI TAC')
    
end
xlabel('Time after injection (sec)')

switch handles.norm.Value
    case 0
        ylabel('1/1')
    case 1
        ylabel('normalized 1/1')
end


% --- Executes on button press in meanTAC.
function meanTAC_Callback(hObject, eventdata, handles)
