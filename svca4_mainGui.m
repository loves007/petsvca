function varargout = svca4_mainGui(varargin)
% SVCA4_MAINGUI MATLAB code for svca4_mainGui.fig

% Last Modified by GUIDE v2.5 03-Mar-2017 09:36:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svca4_mainGui_OpeningFcn, ...
    'gui_OutputFcn',  @svca4_mainGui_OutputFcn, ...
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


% --- Executes just before svca4_mainGui is made visible.
function svca4_mainGui_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for svca4_mainGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
if exist('/Users/scott/Dropbox/MATLAB/Toolboxes/nifti_tools', 'dir')
    addpath('/Users/scott/Dropbox/MATLAB/Toolboxes/nifti_tools')
else
    warning('nifti_tools path not set')
end

if exist('/Applications/MRI/freesurfer_v6beta', 'dir')
    addpath('/Applications/MRI/freesurfer_v6beta')
else
    warning('Freesurfer Home path not set')
end


% --- Outputs from this function are returned to the command line.
function varargout = svca4_mainGui_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in set_path.
function set_path_Callback(hObject, eventdata, handles)
global svca4
if exist('svca4','var') && exist('TAC_TABLE','var')
    svca4_pathGui(svca4)
else svca4_pathGui
end

% --- Executes on button press in flip.
function flip_Callback(hObject, eventdata, handles)
% use to flip the time dimension of the PET data.
% The first frame of the data was really in the last frame of the image so
% we needed to flip them.
[files, filepath] = uigetfile({'.nii','.nii.gz'},'Multiselect','on');
if size(files,1) == 1
    pname = fullfile(filepath,files);
    PET_struct = load_untouch_nii(pname);
    PET_struct.img = flip(PET_struct.img,4);
    fname = [pname(1:end-4) '_flip.nii'];
    save_untouch_nii(PET_struct, fname);
elseif size(files,1) > 1
    for s = 1:length(files)
        pname = fullfile(filepath,files(s));
        PET_struct = load_untouch_nii(pname);
        PET_struct.img = flip(PET_struct.img,4);
        fname = [pname(1:end-4) '_flipTime.nii'];
        save_untouch_nii(PET_struct, fname);
    end
end

% --- Executes on button press in load_o.
function load_o_Callback(hObject, eventdata, handles)
% Use to load an svca4 structure
global svca4
global TAC_TABLE
uiopen('load')

% --- Executes on button press in create_svca4.
function create_svca4_Callback(hObject, eventdata, handles)
% hObject    handle to create_svca4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
svca4_createSVCAGui

% --- Executes on button press in show_svca4.
% change this to create a variable in the workspace!
function show_svca4_Callback(hObject, eventdata, handles)
global svca4
svca4
assignin('base','svca4',svca4)

% --- Executes on button press in time_shift.
function time_shift_Callback(hObject, eventdata, handles)

global svca4
if exist('svca4','var')
    svca4_timeShiftGui(svca4)
else warndlg('Please load svca4 structure first')
end

% --- Executes on button press in freesurfer.
function freesurfer_Callback(hObject, eventdata, handles)
% NB: Placeholder: use this button to open a gui that collects the
% SUBJECTS_DIR, the subject and runs a recon-all
global svca4
if exist('svca4','var')
    svca4_freesurferGui(svca4)
else warndlg('Please load a data structure first')
end

% --- Executes on button press in calc_class.
function calc_class_Callback(hObject, eventdata, handles)
global svca4
global TAC_TABLE

if exist('svca4','var') && exist('TAC_TABLE','var')
    svca4_ClassGui(svca4,TAC_TABLE)
else warndlg('Please load a TAC_TABLE and o structure first')
end

% --- Executes on button press in plot_class.
function plot_class_Callback(hObject, eventdata, handles)
global svca4
global TAC_TABLE
if exist('svca4','var') && exist('TAC_TABLE','var')
    svca4_PlotClassGui(svca4,TAC_TABLE)
else warndlg('Please load a TAC_TABLE and o structure first')
end


% --- Executes on button press in calc_svca4.
function calc_svca4_Callback(hObject, eventdata, handles)
global svca4
global TAC_TABLE

if exist('svca4','var') && exist('TAC_TABLE','var')
    svca4_calculate(svca4)
else warndlg('Please load a TAC_TABLE and svca4 structure first')
end

% --- Executes on button press in show.
function show_Callback(hObject, eventdata, handles)
% use itksnap to display SPM style results
global svca4
disp(svca4)
if exist('svca4','var')
    svca4_dispGui(svca4)
else warndlg('Please load a TAC_TABLE and svca4 structure first')
    
end

% --- Executes on button press in extract_ref.
function extract_ref_Callback(hObject, eventdata, handles)
global svca4
if exist('svca4','var')
    svca4_extractRefGui(svca4)
else warndlg('Please load svca4 structure first')
end


% --- Executes on button press in cereb_ref.
function cereb_ref_Callback(hObject, eventdata, handles)
global svca4

CBtac =  zeros(length(svca4.PET_list),length(svca4.PET_standardDurations));

for s = 1:length(svca4.PET_list) % loop on subjects
    
    CB = fullfile(svca4.outputPath, 'roiMasks', [svca4.Names{s} '_' 'cerebellum_grey.nii.gz']);
    % load the brain mask
    CB_struct = load_nii(CB);
    CB_mask = single(CB_struct.img);
    clear CB_struct
    
    pname = fullfile(svca4.PET_dir,svca4.PET_list{s});
    PET_struct = load_nii(pname);
    PET = single(PET_struct.img);
    xDim = size(PET,1);
    yDim = size(PET,2);
    zDim = size(PET,3);
    PET_struct.img = [];
    
    for t=1:length(svca4.PET_standardDurations)
        PET_t=PET(:,:,:,t);
        TEMP = CB_mask.*PET_t;
        CBtac(s,t) = sum(TEMP(:));
    end
    CBtac(s,:) = CBtac(s,:)/sum(CB_mask(:)==1);
    
    myCB_TAC = [svca4.PET_standardStartTimes svca4.PET_standardEndTimes CBtac(s,:)'];
    
    fname = sprintf('%s/TACs/%s_CB_GM.txt', svca4.outputPath, svca4.Names{s});
    fid = fopen(fname, 'w');
    fprintf(fid,'start[seconds]\tend[seconds]\tTAC[kBq/cc]\n');
    fprintf(fid,'%.1f\t%.1f\t%.4f\n', myCB_TAC');
    fclose(fid);
    figure;plot(svca4.PET_standardEndTimes,CBtac(s,:))
end
mean(CBtac)
myCB_TAC = [svca4.PET_standardStartTimes svca4.PET_standardEndTimes mean(CBtac)'];

fname = sprintf('%s/TACs/mean_CB_GM.txt', svca4.outputPath);
fid = fopen(fname, 'w');
fprintf(fid,'start[seconds]\tend[seconds]\tTAC[kBq/cc]\n');
fprintf(fid,'%.1f\t%.1f\t%.4f\n', myCB_TAC');
fclose(fid);
figure;plot(svca4.PET_standardEndTimes,mean(CBtac))
disp('Cerebellum (CB) reference TACs were output in the TACs folder.')

% --- Executes on button press in iterate.
function iterate_Callback(hObject, eventdata, handles)
global svca4
if exist('svca4','var')
    svca4_iterateGui(svca4)
end

% --- Executes on button press in tac_voi.
function tac_voi_Callback(hObject, eventdata, handles)
global svca4
if exist('svca4','var')
    svca4_voiTACGui(svca4)
end

% --- Executes on button press in plot_TACs.
function plot_TACs_Callback(hObject, eventdata, handles)
global svca4
[filenames,pathname,filterindex] = uigetfile([svca4.outputPath filesep 'TACs' filesep '*.txt'],'MultiSelect', 'on');

hf = figure;
set(hf,'color','white')
if ~iscell(filenames)
    filenames = {filenames};
end

for f=1:size(filenames,2)
    fname = fullfile(pathname,filenames{f});
    
    tacTable = readtable(fname);
    tac(f,:) = tacTable.TAC_kBq_cc_;
end
plot(svca4.PET_standardEndTimes,tac,'linewidth',3)
xlabel('Time after injection (sec)')
hl = legend(filenames,'location','southoutside');
set(hl,'Interpreter', 'none')

% --- Executes on button press in subj_names.
function subj_names_Callback(hObject, eventdata, handles)
% use to add or change the short name that will be used to identify
% subjects in output files
global svca4

if exist('svca4','var')
    svca4_namesGui(svca4)
end


% --- Executes on button press in compareTacs.
function compareTacs_Callback(hObject, eventdata, handles)
global svca4

if exist('svca4','var')
    svca4_compareTacsGui(svca4)
end


% --- Executes on button press in bp_voi.
function bp_voi_Callback(hObject, eventdata, handles)
% This call will create a table containing the average BP value for
% each VOIs and each subject.
global svca4

% get the BP image files to work on
if get(hObject,'Value') == 1
    %[bp_list, bp_dir] = uigetfile(fullfile(svca4.outputPath, '*.nii;*.nii.gz'),'Select the BP images','MultiSelect','on');
    bp_list = uipickfiles('FilterSpec',[svca4.outputPath]);
end
hObject.Value = 0;

% get an output name for the results table
outName = inputdlg('output file name?');

% load all label names
load(fullfile(fileparts(which('svca4_mainGui')),'freeLabels.mat'))

for i = 1:length(bp_list)
    
    % find BP image for current subject
    subj = svca4.Names{i};
    ind = strfind(bp_list, subj);
    ind = find(not(cellfun('isempty', ind)));
    bpf = bp_list{ind};
    
    %%% load all BP image %%%
    BP_struct = load_nii(bpf);
    BP = single(BP_struct.img);
    
    %%% load all VOIs %%%
    VOI_struct = load_nii([svca4.SUBJECTS_DIR filesep subj filesep 'label' filesep subj '_AparcAseg_in_PET.nii.gz']);
    VOI = single(VOI_struct.img);
    VOInums = unique(VOI);
    VOInums = VOInums(VOInums > 0);
    nVOIs = length(VOInums);
    
    % get mean of each VOI
    count = 1;
    for v = 1:nVOIs
        % not all aubjects have exactly the same labels eg the 5th ventricle
        % so I use the loaded label list which contains the important ones
        if ismember(VOInums(v),labels.LabelNumber) 
            indVOI = find(VOI==VOInums(v));
            
            bp_voi(i,count) = mean(BP(indVOI));
            count = count+1;
        end
    end
end
bpTable = array2table(bp_voi,'variablenames',labels.Region);
uisave('bpTable',outName{1})
