function varargout = svca4_extractRefGui(varargin)
% SVCA4_EXTRACTREFGUI MATLAB code for svca4_extractRefGui.fig
%      SVCA4_EXTRACTREFGUI, by itself, creates a new SVCA4_EXTRACTREFGUI or raises the existing
%      singleton*.
%
%      H = SVCA4_EXTRACTREFGUI returns the handle to a new SVCA4_EXTRACTREFGUI or the handle to
%      the existing singleton*.
%
%      SVCA4_EXTRACTREFGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVCA4_EXTRACTREFGUI.M with the given input arguments.
%
%      SVCA4_EXTRACTREFGUI('Property','Value',...) creates a new SVCA4_EXTRACTREFGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before svca4_extractRefGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to svca4_extractRefGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help svca4_extractRefGui

% Last Modified by GUIDE v2.5 26-Jan-2017 14:27:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svca4_extractRefGui_OpeningFcn, ...
    'gui_OutputFcn',  @svca4_extractRefGui_OutputFcn, ...
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


% --- Executes just before svca4_extractRefGui is made visible.
function svca4_extractRefGui_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for svca4_extractRefGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global svca4
handles.listsubs.String = svca4.PET_list;
handles.listsubs.Max = length(svca4.PET_list);

% --- Outputs from this function are returned to the command line.
function varargout = svca4_extractRefGui_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in listsubs.
function listsubs_Callback(hObject, eventdata, handles)
global svca4

% --- Executes during object creation, after setting all properties.
function listsubs_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in extract.
function extract_Callback(hObject, eventdata, handles)

global svca4

if ~exist([svca4.outputPath filesep 'TACs'],'dir')
    mkdir([svca4.outputPath filesep 'TACs'])
end

% - quantiles : [lowerGRAY upperWHITE upperBLOOD upperTSPO]
% exclude under lowerGRAY
% exclude above upperWHITE upperBLOOD upperTSPO
svca4.quantiles = [str2num(handles.loGrey.String)/100,...
    str2num(handles.upWhite.String)/100,...
    str2num(handles.upBlood.String)/100,...
    str2num(handles.upTSPO.String)/100];

inds = handles.listsubs.Value; % indices to the subjects
GRAYtac =  zeros(1,length(svca4.PET_standardDurations));

for s = 1:length(handles.listsubs.Value)
    ifeedback=str2num(handles.iteration.String);
    q = str2num(handles.it_q.String);
    
    % load the brain mask
    mname = fullfile(svca4.MASK_dir,svca4.MASK_list{inds(s)});
    MASK_struct = load_untouch_nii(mname);
    MASK = single(MASK_struct.img);
    clear MASK_struct
    
    if handles.remCereb.Value == 1
        CB = fullfile(svca4.outputPath, 'roiMasks', [svca4.Names{inds(s)} '_' 'cerebellum_grey.nii.gz']);
        % load the brain mask
        CB_struct = load_untouch_nii(CB);
        CB_mask = single(CB_struct.img);
        clear CB_struct
        MASK = MASK-CB_mask;
    end
    
    pname = fullfile(svca4.PET_dir,svca4.PET_list{inds(s)});
    PET_struct = load_untouch_nii(pname);
    PET = single(PET_struct.img);
    xDim = size(PET,1);
    yDim = size(PET,2);
    zDim = size(PET,3);
    PET_struct.img = [];
    
    %loading parametric maps
    if ifeedback == 0
        fname = sprintf('%s/weights/%s_GRAY_it%.2d.nii', svca4.outputPath, svca4.Names{inds(s)}, ifeedback);
    else fname = sprintf('%s/weights/%s_GRAY_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{inds(s)}, q*100,ifeedback);
    end
    GRAY = load_untouch_nii(fname);
    GRAY = GRAY.img;
    
    if ifeedback == 0
        fname = sprintf('%s/weights/%s_WHITE_it%.2d.nii', svca4.outputPath, svca4.Names{inds(s)}, ifeedback);
    else fname = sprintf('%s/weights/%s_WHITE_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{inds(s)}, q*100,ifeedback);
    end
    WHITE = load_untouch_nii(fname);
    WHITE = WHITE.img;
    
    if ifeedback == 0
        fname = sprintf('%s/weights/%s_BLOOD_it%.2d.nii', svca4.outputPath, svca4.Names{inds(s)}, ifeedback);
    else fname = sprintf('%s/weights/%s_BLOOD_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{inds(s)}, q*100,ifeedback);
    end
    BLOOD = load_untouch_nii(fname);
    BLOOD = BLOOD.img;
    
    if ifeedback == 0
        fname = sprintf('%s/weights/%s_TSPO_it%.2d.nii', svca4.outputPath, svca4.Names{inds(s)}, ifeedback);
    else fname = sprintf('%s/weights/%s_TSPO_q%d_it%.2d.nii', svca4.outputPath, svca4.Names{inds(s)}, q*100,ifeedback);
    end
    TSPO = load_untouch_nii(fname);
    TSPO = TSPO.img;
    
    % ----------------------------------------
    % - Compute quantiles
    % ----------------------------------------
    GRAY = GRAY.*MASK;
    indGRAY = find(GRAY~=0);
    indWHITE = find(WHITE~=0);
    indBLOOD = find(BLOOD~=0);
    indTSPO = find(TSPO~=0);
    GRAY_q(1) = quantile(GRAY(indGRAY),svca4.quantiles(1));
    GRAY_q(2) = quantile(WHITE(intersect(indGRAY,indWHITE)),svca4.quantiles(2));
    GRAY_q(3) = quantile(BLOOD(intersect(indGRAY,indBLOOD)),svca4.quantiles(3));
    GRAY_q(4) = quantile(TSPO(intersect(indGRAY,indTSPO)),svca4.quantiles(4));
    
    fprintf('ALL : %d voxels remaining\n', numel(indGRAY));
    indGRAY = intersect(indGRAY, find(GRAY.*MASK>GRAY_q(1)));
    fprintf('GRAY selection : %d voxels remaining\n', numel(indGRAY));
    indGRAY = intersect(indGRAY, find(WHITE.*MASK<GRAY_q(2)));
    fprintf('WHITE selection : %d voxels remaining\n', numel(indGRAY));
    indGRAY = intersect(indGRAY, find(BLOOD.*MASK<GRAY_q(3)));
    fprintf('BLOOD selection : %d voxels remaining\n', numel(indGRAY));
    indGRAY = intersect(indGRAY, find(TSPO.*MASK<GRAY_q(4)));
    fprintf('TSPO selection : %d voxels remaining\n', numel(indGRAY));
    
    %----------------------------------------------
    % - Calculate SVCA reference curve
    %----------------------------------------------
    for t=1:length(svca4.PET_standardDurations)
        PET_t=PET(:,:,:,t);
        TEMP = GRAY(indGRAY).*PET_t(indGRAY);
        GRAYtac(s,t) = sum(TEMP(:));
    end
    GRAYtac(s,:) = GRAYtac(s,:)/sum(GRAY(indGRAY));
    
    % add times for saving
    myGRAY_TAC = [svca4.PET_standardStartTimes svca4.PET_standardEndTimes GRAYtac(s,:)'];
    
    % - Write SVCA reference TAC to txt file
    if handles.save_txt.Value == 1 && handles.remCereb.Value == 0
        if ifeedback == 0
            fname = sprintf('%s/TACs/%s_svcaRef_G%.2fW%.2fB%.2fT%.2f.txt', svca4.outputPath, svca4.Names{inds(s)}, svca4.quantiles);
        else fname = sprintf('%s/TACs/%s_svcaRef_q%d_it%.2d_G%.2fW%.2fB%.2fT%.2f.txt', svca4.outputPath, svca4.Names{inds(s)}, q*100,ifeedback,svca4.quantiles);
            
        end
        fid = fopen(fname, 'w');
        fprintf(fid,'start[seconds]\tend[seconds]\tTAC[1/1]\n');
        fprintf(fid,'%.1f\t%.1f\t%.4f\n', myGRAY_TAC');
        fclose(fid);
    elseif handles.save_txt.Value == 1 && handles.remCereb.Value == 1
        if ifeedback == 0
            fname = sprintf('%s/TACs/%s_noCB_svcaRef_G%.2fW%.2fB%.2fT%.2f.txt', svca4.outputPath, svca4.Names{inds(s)}, svca4.quantiles);
        else fname = sprintf('%s/TACs/%s_noCB_svcaRef_q%d_it%.2d_G%.2fW%.2fB%.2fT%.2f.txt', svca4.outputPath, svca4.Names{inds(s)}, q*100,ifeedback,svca4.quantiles);
            
        end
        fid = fopen(fname, 'w');
        fprintf(fid,'start[seconds]\tend[seconds]\tTAC[1/1]\n');
        fprintf(fid,'%.1f\t%.1f\t%.4f\n', myGRAY_TAC'); 
        fclose(fid);
    end
%%%%%%%%%%%% testing - can be removed %%%%%%%%%%%%%%%    
%     figure;
%     plot(svca4.PET_standardEndTimes,GRAYtac(s,:))
%     figure;
%     imagesc(squeeze(PET(:,45,:,20)))
%     figure;
%     imagesc(squeeze(GRAY(:,45,:)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% calculate a reference TAC but instead of using quantiles just remove half of the randomly selected voxels
    % don't really need this now and should really double check the code!
    %     indGRAY = find(GRAY~=0);
    %     randGray = randperm(numel(indGRAY),round(numel(indGRAY)/400));
    %     fprintf('Random : %d voxels of %d remaining\n', numel(randGray),numel(indGRAY));
    %
    %     indGRAY = intersect(indGRAY(randGray), find(GRAY.*MASK));
    %     numel(indGRAY)
    %     for t=1:length(svca4.PET_standardDurations)
    %         PET_t=PET(:,:,:,t);
    %         TEMP = GRAY(indGRAY).*PET_t(indGRAY);
    %         GRAYt(s,t) = sum(TEMP(:));
    %     end
    %     GRAYt(s,:) = GRAYt(s,:)/sum(GRAY(indGRAY));
end
% plot for the random selection version. Not using now
% myGRAY_TAC = [svca4.PET_standardStartTimes svca4.PET_standardEndTimes mean(GRAYt)'];
% fname = sprintf('%s/TACs/mean_svcaRANDRef.txt', svca4.outputPath);
% fid = fopen(fname, 'w');
% fprintf(fid,'start[seconds]\tend[seconds]\tTAC[kBq/cc]\n');
% fprintf(fid,'%.1f\t%.1f\t%.4f\n', myGRAY_TAC');
% fclose(fid);

if handles.save_mean.Value == 1 && handles.remCereb.Value == 0
    myGRAY_TAC = [svca4.PET_standardStartTimes svca4.PET_standardEndTimes mean(GRAYtac)'];
    
    if ifeedback == 0
        fname = sprintf('%s/TACs/mean_svcaRef_G%.2fW%.2fB%.2fT%.2f.txt', svca4.outputPath, svca4.quantiles);
    else fname = sprintf('%s/TACs/mean_svcaRef_q%d_it%.2d_G%.2fW%.2fB%.2fT%.2f.txt', svca4.outputPath, q*100,ifeedback,svca4.quantiles);
    end
    fid = fopen(fname, 'w');
    fprintf(fid,'start[seconds]\tend[seconds]\tTAC[1/1]\n');
    fprintf(fid,'%.1f\t%.1f\t%.4f\n', myGRAY_TAC');
    fclose(fid);
    figure;
    plot(svca4.PET_standardEndTimes,mean(GRAYtac))
elseif handles.save_mean.Value == 1 && handles.remCereb.Value == 1
    myGRAY_TAC = [svca4.PET_standardStartTimes svca4.PET_standardEndTimes mean(GRAYtac)'];
    
    if ifeedback == 0
        fname = sprintf('%s/TACs/mean_noCB_svcaRef_G%.2fW%.2fB%.2fT%.2f.txt', svca4.outputPath, svca4.quantiles);
    else fname = sprintf('%s/TACs/mean_noCB_svcaRef_q%d_it%.2d_G%.2fW%.2fB%.2fT%.2f.txt', svca4.outputPath, q*100,ifeedback,svca4.quantiles);
    end
    fid = fopen(fname, 'w');
    fprintf(fid,'start[seconds]\tend[seconds]\tTAC[1/1]\n');
    fprintf(fid,'%.1f\t%.1f\t%.4f\n', myGRAY_TAC');
    fclose(fid);
    figure;
    plot(svca4.PET_standardEndTimes,mean(GRAYtac))
end

% --- Executes on button press in save_txt.
function save_txt_Callback(hObject, eventdata, handles)

function loGrey_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function loGrey_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function upWhite_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function upWhite_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function upBlood_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function upBlood_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function upTSPO_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function upTSPO_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in save_mean.
function save_mean_Callback(hObject, eventdata, handles)

function iteration_Callback(hObject, eventdata, handles)

function iteration_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function it_q_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function it_q_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in remCereb.
function remCereb_Callback(hObject, eventdata, handles)
